"""数据模型定义"""
from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class AnswerRecord(BaseModel):
    """单条答题记录"""
    student_id: str
    question_id: str
    knowledge_points: list[str]          # 题目关联的知识点
    is_correct: bool
    selected_option: Optional[str] = None
    correct_option: Optional[str] = None
    timestamp: Optional[datetime] = None


class KPProfile(BaseModel):
    """单个知识点的掌握画像"""
    kp_name: str
    total: int = 0
    correct: int = 0
    accuracy: float = 0.0
    level: str = "untested"  # mastered / familiar / weak / critical / untested


class PersonalizedNode(BaseModel):
    """个性化图谱中的节点"""
    id: str
    name: str
    category: Optional[str] = None
    level: str = "untested"
    accuracy: float = 0.0
    total: int = 0
    color: str = "#999999"  # 前端直接用


class PersonalizedEdge(BaseModel):
    """个性化图谱中的边"""
    source: str
    target: str
    relation: str


class PersonalizedGraph(BaseModel):
    """完整的个性化图谱"""
    student_id: str
    nodes: list[PersonalizedNode]
    edges: list[PersonalizedEdge]
    summary: dict  # {mastered: n, familiar: n, weak: n, critical: n, untested: n}
