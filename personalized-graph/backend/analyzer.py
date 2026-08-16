"""答题分析：从答题记录生成知识点掌握画像"""
from collections import defaultdict
from models import AnswerRecord, KPProfile


# 掌握度分级阈值
LEVEL_THRESHOLDS = {
    "mastered": 0.85,
    "familiar": 0.60,
    "weak": 0.30,
    "critical": 0.0,
}

# 染色方案
LEVEL_COLORS = {
    "mastered": "#4CAF50",   # 绿
    "familiar": "#FFC107",   # 黄
    "weak": "#FF9800",       # 橙
    "critical": "#F44336",   # 红
    "untested": "#9E9E9E",   # 灰
}


def classify_level(accuracy: float) -> str:
    if accuracy >= LEVEL_THRESHOLDS["mastered"]:
        return "mastered"
    elif accuracy >= LEVEL_THRESHOLDS["familiar"]:
        return "familiar"
    elif accuracy >= LEVEL_THRESHOLDS["weak"]:
        return "weak"
    else:
        return "critical"


def build_profiles(records: list[AnswerRecord]) -> dict[str, KPProfile]:
    """
    输入一批答题记录，输出每个知识点的掌握画像。
    """
    stats: dict[str, dict] = defaultdict(lambda: {"correct": 0, "total": 0})

    for r in records:
        for kp in r.knowledge_points:
            stats[kp]["total"] += 1
            if r.is_correct:
                stats[kp]["correct"] += 1

    profiles = {}
    for kp_name, data in stats.items():
        acc = data["correct"] / data["total"] if data["total"] > 0 else 0.0
        level = classify_level(acc)
        profiles[kp_name] = KPProfile(
            kp_name=kp_name,
            total=data["total"],
            correct=data["correct"],
            accuracy=round(acc, 3),
            level=level,
        )

    return profiles


def get_color(level: str) -> str:
    return LEVEL_COLORS.get(level, "#9E9E9E")
