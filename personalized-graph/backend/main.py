"""FastAPI 主入口"""
import sys
import os
from datetime import datetime

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# 确保能 import 同目录模块
sys.path.insert(0, os.path.dirname(__file__))

from models import AnswerRecord, PersonalizedGraph, KPProfile
from analyzer import build_profiles
from graph_query import add_answer, get_answers, build_personalized_graph

app = FastAPI(title="个性化图谱 API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/api/answer")
def submit_answer(record: AnswerRecord):
    """提交一条答题记录"""
    data = record.model_dump()
    if data["timestamp"] is None:
        data["timestamp"] = datetime.now().isoformat()
    add_answer(data)
    return {"status": "ok", "message": "答题记录已保存"}


@app.post("/api/answers/batch")
def submit_answers(records: list[AnswerRecord]):
    """批量提交答题记录"""
    for record in records:
        data = record.model_dump()
        if data["timestamp"] is None:
            data["timestamp"] = datetime.now().isoformat()
        add_answer(data)
    return {"status": "ok", "count": len(records)}


@app.get("/api/student/{student_id}/profile")
def get_profile(student_id: str):
    """获取学生的知识点掌握画像"""
    records_raw = get_answers(student_id)
    if not records_raw:
        return {"student_id": student_id, "profiles": [], "total_questions": 0}

    from models import AnswerRecord as AR
    records = [AR(**r) for r in records_raw]
    profiles = build_profiles(records)

    return {
        "student_id": student_id,
        "total_questions": len(records_raw),
        "profiles": {k: v.model_dump() for k, v in profiles.items()},
    }


@app.get("/api/student/{student_id}/personalized-graph")
def get_personalized_graph(student_id: str, use_neo4j: bool = False):
    """获取个性化图谱（带染色）"""
    graph = build_personalized_graph(student_id, use_neo4j=use_neo4j)
    return graph.model_dump()


@app.get("/api/student/{student_id}/weak-points")
def get_weak_points(student_id: str, threshold: float = 0.6):
    """获取薄弱知识点（正确率低于 threshold 的）"""
    records_raw = get_answers(student_id)
    if not records_raw:
        return {"student_id": student_id, "weak_points": []}

    from models import AnswerRecord as AR
    records = [AR(**r) for r in records_raw]
    profiles = build_profiles(records)

    weak = [
        p.model_dump() for p in profiles.values()
        if p.accuracy < threshold
    ]
    # 按正确率排序，最差的在前
    weak.sort(key=lambda x: x["accuracy"])

    return {"student_id": student_id, "weak_points": weak}


@app.get("/api/demo/seed")
def seed_demo_data():
    """注入演示数据（方便测试）"""
    demo_records = [
        {"student_id": "stu_demo", "question_id": "q1", "knowledge_points": ["减数分裂", "同源染色体"], "is_correct": True},
        {"student_id": "stu_demo", "question_id": "q2", "knowledge_points": ["减数分裂", "交叉互换"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q3", "knowledge_points": ["同源染色体"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q4", "knowledge_points": ["同源染色体", "染色体组"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q5", "knowledge_points": ["有丝分裂"], "is_correct": True},
        {"student_id": "stu_demo", "question_id": "q6", "knowledge_points": ["有丝分裂", "DNA复制"], "is_correct": True},
        {"student_id": "stu_demo", "question_id": "q7", "knowledge_points": ["DNA复制", "减数分裂"], "is_correct": True},
        {"student_id": "stu_demo", "question_id": "q8", "knowledge_points": ["基因重组"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q9", "knowledge_points": ["基因突变", "基因重组"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q10", "knowledge_points": ["连锁遗传", "交叉互换"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q11", "knowledge_points": ["减数分裂"], "is_correct": True},
        {"student_id": "stu_demo", "question_id": "q12", "knowledge_points": ["二倍体与多倍体", "染色体组"], "is_correct": True},
        {"student_id": "stu_demo", "question_id": "q13", "knowledge_points": ["连锁遗传"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q14", "knowledge_points": ["交叉互换", "基因重组"], "is_correct": False},
        {"student_id": "stu_demo", "question_id": "q15", "knowledge_points": ["有丝分裂"], "is_correct": True},
    ]
    for r in demo_records:
        r["timestamp"] = datetime.now().isoformat()
        add_answer(r)

    return {"status": "ok", "message": f"已注入 {len(demo_records)} 条演示数据（学生: stu_demo）"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
