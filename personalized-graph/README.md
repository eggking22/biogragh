# 个性化图谱 (Personalized Graph) - P0

学生做题后，根据答题记录生成个性化的知识点掌握图谱。

## 目录结构

```
personalized-graph/
├── backend/           # FastAPI 后端
│   ├── main.py        # 入口 + 路由
│   ├── analyzer.py    # 答题分析逻辑
│   ├── graph_query.py # Neo4j 子图查询
│   ├── models.py      # 数据模型
│   └── requirements.txt
├── frontend/          # 前端 demo
│   └── index.html     # 单文件可视化 demo
├── seed/              # 测试数据
│   └── mock_data.py   # 模拟答题记录 + Neo4j 数据
└── README.md
```

## 快速启动

### 1. 安装依赖

```bash
cd backend
pip install -r requirements.txt
```

### 2. 初始化测试数据（可选，需要 Neo4j）

```bash
python seed/mock_data.py
```

### 3. 启动后端

```bash
cd backend
uvicorn main:app --reload --port 8001
```

### 4. 打开前端

直接浏览器打开 `frontend/index.html`，或用任意静态服务器。

## API 接口

- `POST /api/answer` — 提交答题记录
- `GET /api/student/{id}/profile` — 获取知识点掌握画像
- `GET /api/student/{id}/personalized-graph` — 获取个性化子图（带染色）
- `GET /api/student/{id}/weak-points` — 获取薄弱知识点列表
