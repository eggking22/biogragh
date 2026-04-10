"""
Neo4j 导入脚本 - 生物化学知识图谱
用法:
  1. Docker 启动 Neo4j: docker run -d --name neo4j-bio -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/bio123456 neo4j:5
  2. 安装依赖: pip install neo4j
  3. 运行: python import_neo4j.py
"""

import json
from neo4j import GraphDatabase

NEO4J_URI = "bolt://localhost:7687"
NEO4J_AUTH = ("neo4j", "bio123456")
DATA_FILE = "knowledge-base/verified/biochem-chapters.json"

driver = GraphDatabase.driver(NEO4J_URI, auth=NEO4J_AUTH)


def clear_database():
    """清空数据库（测试用）"""
    with driver.session() as s:
        s.run("MATCH (n) DETACH DELETE n")
        print("✅ 数据库已清空")


def create_constraints():
    """创建唯一性约束"""
    with driver.session() as s:
        s.run("CREATE CONSTRAINT IF NOT EXISTS FOR (k:Knowledge) REQUIRE k.id IS UNIQUE")
        print("✅ 唯一性约束已创建")


def import_nodes(nodes):
    """批量导入知识点节点"""
    with driver.session() as s:
        result = s.run(
            "UNWIND $nodes AS n "
            "MERGE (k:Knowledge {id: n.id}) "
            "SET k.name = n.name, "
            "    k.level = n.level, "
            "    k.domain = n.domain, "
            "    k.chapter = n.chapter, "
            "    k.section_code = n.section_code, "
            "    k.importance = n.importance, "
            "    k.tags = n.tags",
            nodes=nodes
        )
        print(f"✅ 导入 {len(nodes)} 个知识点节点")


def import_prerequisites(nodes):
    """创建前置依赖关系 (PREREQUISITE)"""
    with driver.session() as s:
        result = s.run(
            "UNWIND $nodes AS n "
            "UNWIND n.prerequisites AS pid "
            "MATCH (k:Knowledge {id: n.id}) "
            "MATCH (p:Knowledge {id: pid}) "
            "MERGE (p)-[:PREREQUISITE]->(k)",
            nodes=nodes
        )
        counters = result.consume().counters
        print(f"✅ 创建 {counters.relationships_created} 条 PREREQUISITE 关系")


def import_related(nodes):
    """创建关联关系 (RELATED)"""
    with driver.session() as s:
        result = s.run(
            "UNWIND $nodes AS n "
            "UNWIND n.related AS rid "
            "MATCH (k:Knowledge {id: n.id}) "
            "MATCH (r:Knowledge {id: rid}) "
            "MERGE (k)-[:RELATED]->(r)",
            nodes=nodes
        )
        counters = result.consume().counters
        print(f"✅ 创建 {counters.relationships_created} 条 RELATED 关系")


def import_contains(nodes):
    """创建层级包含关系 (CONTAINS): 章→节→小节"""
    edges = []
    for node in nodes:
        sc = node["section_code"]
        parts = sc.split(".")
        if len(parts) == 2:  # 节 → 归属章
            parent_id = f"biochem-{parts[0].zfill(2)}"
            edges.append({"parent": parent_id, "child": node["id"]})
        elif len(parts) == 3:  # 小节 → 归属节
            parent_id = f"biochem-{parts[0].zfill(2)}-{parts[1].zfill(2)}"
            # 查找父节ID
            for n2 in nodes:
                if n2["section_code"] == f"{parts[0]}.{parts[1]}" and n2["level"] == 2:
                    edges.append({"parent": n2["id"], "child": node["id"]})
                    break
    
    with driver.session() as s:
        result = s.run(
            "UNWIND $edges AS e "
            "MATCH (p:Knowledge {id: e.parent}) "
            "MATCH (c:Knowledge {id: e.child}) "
            "MERGE (p)-[:CONTAINS]->(c)",
            edges=edges
        )
        counters = result.consume().counters
        print(f"✅ 创建 {counters.relationships_created} 条 CONTAINS 关系")


def verify():
    """验证导入结果"""
    with driver.session() as s:
        node_count = s.run("MATCH (k:Knowledge) RETURN count(k) AS c").single()["c"]
        rel_count = s.run("MATCH ()-[r]->() RETURN count(r) AS c").single()["c"]
        
        # 按关系类型统计
        type_stats = s.run(
            "MATCH ()-[r]->() RETURN type(r) AS t, count(r) AS c ORDER BY c DESC"
        ).data()
        
        # 孤儿节点
        orphans = s.run(
            "MATCH (k:Knowledge) WHERE NOT (k)--() RETURN k.id, k.name"
        ).data()
        
        print(f"\n📊 验证结果:")
        print(f"   节点总数: {node_count}")
        print(f"   关系总数: {rel_count}")
        print(f"   关系类型分布:")
        for row in type_stats:
            print(f"     {row['t']}: {row['c']}")
        
        if orphans:
            print(f"\n⚠️  孤儿节点 ({len(orphans)} 个):")
            for o in orphans[:10]:
                print(f"     {o['k.id']}: {o['k.name']}")
            if len(orphans) > 10:
                print(f"     ... 还有 {len(orphans)-10} 个")
        else:
            print("   ✅ 无孤儿节点")
        
        # 抽样查询
        print(f"\n🔍 抽样: '糖酵解' 的完整前置路径:")
        paths = s.run(
            "MATCH path = (pre:Knowledge)-[:PREREQUISITE*]->(k:Knowledge {name: '糖酵解'}) "
            "RETURN [n IN nodes(path) | n.name] AS names"
        ).data()
        for p in paths:
            print(f"   {' → '.join(p['names'])}")


def main():
    # with open(DATA_FILE) as f:
    with open(DATA_FILE, encoding="utf-8") as f:
        nodes = json.load(f)
    
    print(f"📖 读取 {len(nodes)} 个知识点\n")
    
    clear_database()
    create_constraints()
    import_nodes(nodes)
    import_prerequisites(nodes)
    import_related(nodes)
    import_contains(nodes)
    verify()
    
    driver.close()
    print("\n🎉 导入完成! 打开 http://localhost:7474 查看图谱")


if __name__ == "__main__":
    main()
