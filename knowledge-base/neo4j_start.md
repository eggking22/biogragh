## 查看方式：
JSON 数据：直接用 VS Code 打开 biochem-chapters.json，可以看到每个知识点的 id、name、level、前置依赖、标签等
Schema 定义：打开 schema.json 查看字段说明
▶️ 运行导入（本地操作）：
# 1. 启动 Neo4j
docker run -d --name neo4j-bio -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/bio123456 neo4j:5

# 2. 安装 Python 驱动
pip install neo4j

# 3. 运行导入
cd D:\openclaw\workspace\biochem-graph
python import_neo4j.py

# 4. 浏览器查看图谱
# 打开 http://localhost:7474
# 用户名 neo4j / 密码 bio123456 or BioGraph2026!

脚本会自动导入所有节点、创建 PREREQUISITE/RELATED/CONTAINS 三种关系，并输出验证报告（节点数、关系数、孤儿节点检测）。