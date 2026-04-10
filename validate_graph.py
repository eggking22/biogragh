"""离线验证脚本 - 不需要 Neo4j，直接校验知识图谱 JSON 数据"""
import json
from collections import defaultdict

DATA_FILE = "knowledge-base/verified/biochem-chapters.json"

with open(DATA_FILE) as f:
    nodes = json.load(f)

# ── 基本统计 ──
print("=" * 60)
print("📊 生物化学知识图谱 - 数据验证报告")
print("=" * 60)

total = len(nodes)
by_level = defaultdict(int)
by_chapter = defaultdict(int)
for n in nodes:
    by_level[n["level"]] += 1
    by_chapter[n["chapter"]] += 1

print(f"\n总节点数: {total}")
print(f"\n按层级分布:")
for lv in sorted(by_level):
    label = {1: "章", 2: "节", 3: "小节"}[lv]
    print(f"  Level {lv} ({label}): {by_level[lv]}")

print(f"\n按章节分布:")
for ch in sorted(by_chapter):
    chapter_names = {n["name"] for n in nodes if n["chapter"] == ch and n["level"] == 1}
    name = chapter_names.pop() if chapter_names else "?"
    print(f"  第{ch}章 {name}: {by_chapter[ch]} 个节点")

# ── ID 唯一性检查 ──
ids = [n["id"] for n in nodes]
dup_ids = [i for i in set(ids) if ids.count(i) > 1]
print(f"\n{'✅' if not dup_ids else '❌'} ID 唯一性: {len(dup_ids)} 个重复" if dup_ids else f"\n✅ ID 唯一性: 全部唯一 ({total} 个)")

# ── 必填字段检查 ──
required = ["id", "name", "level", "domain", "chapter", "section_code", "importance", "prerequisites", "tags"]
missing_fields = []
for n in nodes:
    for f in required:
        if f not in n or n[f] is None:
            missing_fields.append((n.get("id", "?"), f))
print(f"{'✅' if not missing_fields else '❌'} 必填字段: {len(missing_fields)} 个缺失" if missing_fields else f"✅ 必填字段: 全部完整")

# ── 关系完整性检查 ──
id_set = set(ids)
broken_prereqs = []
broken_related = []
for n in nodes:
    for pid in n.get("prerequisites", []):
        if pid not in id_set:
            broken_prereqs.append((n["id"], pid))
    for rid in n.get("related", []):
        if rid not in id_set:
            broken_related.append((n["id"], rid))

print(f"\n{'✅' if not broken_prereqs else '⚠️ '} PREREQUISITE 引用: {len(broken_prereqs)} 个断链")
for src, tgt in broken_prereqs[:5]:
    print(f"    {src} → {tgt} (不存在)")
if len(broken_prereqs) > 5:
    print(f"    ... 还有 {len(broken_prereqs)-5} 个")

print(f"{'✅' if not broken_related else '⚠️ '} RELATED 引用: {len(broken_related)} 个断链")
for src, tgt in broken_related[:5]:
    print(f"    {src} → {tgt} (不存在)")

# ── 孤儿节点检查 ──
connected = set()
for n in nodes:
    for pid in n.get("prerequisites", []):
        connected.add(n["id"])
        connected.add(pid)
    for rid in n.get("related", []):
        connected.add(n["id"])
        connected.add(rid)
orphans = [n for n in nodes if n["id"] not in connected]
print(f"\n{'✅' if not orphans else '⚠️ '} 孤儿节点: {len(orphans)} 个")
for o in orphans[:10]:
    print(f"    {o['id']}: {o['name']} ({o['section_code']})")

# ── CONTAINS 关系模拟 ──
contains_edges = []
id_map = {n["id"]: n for n in nodes}
for n in nodes:
    parts = n["section_code"].split(".")
    if len(parts) == 2:
        parent_id = f"biochem-{parts[0].zfill(2)}"
        if parent_id in id_map:
            contains_edges.append((parent_id, n["id"]))
    elif len(parts) == 3:
        for n2 in nodes:
            if n2["section_code"] == f"{parts[0]}.{parts[1]}" and n2["level"] == 2:
                contains_edges.append((n2["id"], n["id"]))
                break
print(f"\n📂 CONTAINS 边: {len(contains_edges)} 条 (章→节→小节)")

# ── 关系统计 ──
prereq_edges = sum(len(n.get("prerequisites", [])) for n in nodes)
related_edges = sum(len(n.get("related", [])) for n in nodes)
print(f"\n🔗 关系总数:")
print(f"  PREREQUISITE: {prereq_edges} 条")
print(f"  RELATED:      {related_edges} 条")
print(f"  CONTAINS:     {len(contains_edges)} 条")
print(f"  合计:         {prereq_edges + related_edges + len(contains_edges)} 条")

# ── 抽样：前置依赖路径 ──
print(f"\n🔍 抽样路径查询:")
def trace_prereq(node_id, depth=0, visited=None):
    if visited is None:
        visited = set()
    if node_id in visited or depth > 5:
        return []
    visited.add(node_id)
    node = id_map.get(node_id)
    if not node:
        return []
    path = [node["name"]]
    for pid in node.get("prerequisites", []):
        sub = trace_prereq(pid, depth+1, visited)
        if sub:
            path = sub + ["→"] + path
    return path

for target_name in ["糖酵解", "脂肪酸的生物合成", "肽链合成的起始"]:
    target = next((n for n in nodes if n["name"] == target_name), None)
    if target:
        path = trace_prereq(target["id"])
        print(f"  {target_name}: {' → '.join(path)}")

# ── importance 分布 ──
imp_dist = defaultdict(list)
for n in nodes:
    imp_dist[n["importance"]].append(n["name"])
print(f"\n⭐ 考纲重要度分布:")
for imp in sorted(imp_dist):
    names = imp_dist[imp]
    print(f"  {imp}分: {len(names)} 个")
    if imp >= 5:
        print(f"      {'、'.join(names[:10])}")

print(f"\n{'=' * 60}")
print(f"✅ 验证完成! 共 {total} 节点, {prereq_edges + related_edges + len(contains_edges)} 关系")
print(f"{'=' * 60}")
