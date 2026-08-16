"""Neo4j 子图查询：从全局图谱中抽取个性化子图"""
from neo4j import GraphDatabase
from models import PersonalizedNode, PersonalizedEdge, PersonalizedGraph
from analyzer import build_profiles, get_color, LEVEL_COLORS


# ===== 配置 =====
NEO4J_URI = "bolt://localhost:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "your_password"

_driver = None


def get_driver():
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    return _driver


def close_driver():
    global _driver
    if _driver:
        _driver.close()
        _driver = None


# ===== 内存 mock 模式（不需要 Neo4j 也能测试）=====
MOCK_GRAPH = {
    "nodes": [
        {"id": "kp_001", "name": "减数分裂", "category": "细胞生物学"},
        {"id": "kp_002", "name": "同源染色体", "category": "细胞生物学"},
        {"id": "kp_003", "name": "交叉互换", "category": "细胞生物学"},
        {"id": "kp_004", "name": "染色体组", "category": "细胞生物学"},
        {"id": "kp_005", "name": "二倍体与多倍体", "category": "遗传学"},
        {"id": "kp_006", "name": "有丝分裂", "category": "细胞生物学"},
        {"id": "kp_007", "name": "DNA复制", "category": "分子生物学"},
        {"id": "kp_008", "name": "基因重组", "category": "遗传学"},
        {"id": "kp_009", "name": "基因突变", "category": "遗传学"},
        {"id": "kp_010", "name": "连锁遗传", "category": "遗传学"},
    ],
    "edges": [
        {"source": "kp_001", "target": "kp_002", "relation": "CONTAINS"},
        {"source": "kp_001", "target": "kp_003", "relation": "CONTAINS"},
        {"source": "kp_002", "target": "kp_004", "relation": "RELATED"},
        {"source": "kp_004", "target": "kp_005", "relation": "PREREQUISITE"},
        {"source": "kp_006", "target": "kp_001", "relation": "PREREQUISITE"},
        {"source": "kp_007", "target": "kp_001", "relation": "PREREQUISITE"},
        {"source": "kp_003", "target": "kp_008", "relation": "RELATED"},
        {"source": "kp_008", "target": "kp_009", "relation": "RELATED"},
        {"source": "kp_002", "target": "kp_010", "relation": "RELATED"},
        {"source": "kp_003", "target": "kp_010", "relation": "RELATED"},
    ],
}

# 内存答题记录存储
_answer_store: list[dict] = []


def add_answer(record: dict):
    """存一条答题记录（内存模式）"""
    _answer_store.append(record)


def get_answers(student_id: str) -> list[dict]:
    """获取某学生的所有答题记录"""
    return [r for r in _answer_store if r["student_id"] == student_id]


def build_personalized_graph(student_id: str, use_neo4j: bool = False) -> PersonalizedGraph:
    """
    核心函数：生成个性化图谱。

    1. 获取答题记录 → 分析知识点掌握度
    2. 从 Neo4j / Mock 数据中抽取子图
    3. 染色 + 返回
    """
    from models import AnswerRecord

    # Step 1: 获取答题记录并分析
    records_raw = get_answers(student_id)
    records = [AnswerRecord(**r) for r in records_raw]
    profiles = build_profiles(records)
    tested_kps = set(profiles.keys())

    # Step 2: 获取图谱数据
    if use_neo4j:
        nodes_raw, edges_raw = _query_neo4j_subgraph(tested_kps)
    else:
        nodes_raw = MOCK_GRAPH["nodes"]
        edges_raw = MOCK_GRAPH["edges"]

    # Step 3: 给节点染色
    p_nodes = []
    summary = {"mastered": 0, "familiar": 0, "weak": 0, "critical": 0, "untested": 0}

    for node in nodes_raw:
        name = node["name"]
        if name in profiles:
            p = profiles[name]
            level = p.level
            accuracy = p.accuracy
            total = p.total
        else:
            level = "untested"
            accuracy = 0.0
            total = 0

        summary[level] += 1
        p_nodes.append(PersonalizedNode(
            id=node["id"],
            name=name,
            category=node.get("category", ""),
            level=level,
            accuracy=accuracy,
            total=total,
            color=get_color(level),
        ))

    p_edges = [
        PersonalizedEdge(source=e["source"], target=e["target"], relation=e["relation"])
        for e in edges_raw
    ]

    return PersonalizedGraph(
        student_id=student_id,
        nodes=p_nodes,
        edges=p_edges,
        summary=summary,
    )


def _query_neo4j_subgraph(kp_names: set[str]) -> tuple[list[dict], list[dict]]:
    """从 Neo4j 查询子图（真实模式）"""
    driver = get_driver()
    with driver.session() as session:
        # 查学生涉及的知识点 + 展开1-2层关联
        result = session.run("""
            MATCH (kp:KnowledgePoint)
            WHERE kp.name IN $names
            WITH collect(kp) as seed_nodes
            OPTIONAL MATCH path = (kp:KnowledgePoint)-[:PREREQUISITE|RELATED|PART_OF|CONTAINS*1..2]-(kp2:KnowledgePoint)
            WHERE kp IN seed_nodes
            WITH seed_nodes, collect(DISTINCT path) as paths
            // 提取所有节点和边
            UNWIND seed_nodes as n
            WITH collect(DISTINCT {id: elementId(n), name: n.name, category: coalesce(n.category, '')}) as all_nodes, paths
            UNWIND range(0, size(paths)-1) as i
            WITH all_nodes, paths[i] as p
            UNWIND relationships(p) as rel
            WITH all_nodes, collect(DISTINCT {
                source: elementId(startNode(rel)),
                target: elementId(endNode(rel)),
                relation: type(rel)
            }) as all_edges
            RETURN all_nodes, all_edges
        """, names=list(kp_names))

        record = result.single()
        if record:
            return record["all_nodes"], record["all_edges"]
        return [], []
