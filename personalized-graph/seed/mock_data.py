"""模拟数据生成脚本（用于快速测试，不需要 Neo4j）"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))

from models import AnswerRecord
from datetime import datetime
import json


def generate_mock_records(student_id="stu_test", count=30):
    """生成一批模拟答题记录"""
    import random

    all_kps = [
        "减数分裂", "同源染色体", "交叉互换", "染色体组",
        "二倍体与多倍体", "有丝分裂", "DNA复制", "基因重组",
        "基因突变", "连锁遗传",
    ]

    # 给不同知识点设不同难度，模拟真实场景
    difficulty = {
        "有丝分裂": 0.9, "DNA复制": 0.85, "减数分裂": 0.7,
        "同源染色体": 0.4, "染色体组": 0.5, "二倍体与多倍体": 0.75,
        "交叉互换": 0.3, "基因重组": 0.35, "基因突变": 0.45,
        "连锁遗传": 0.25,
    }

    records = []
    for i in range(count):
        # 每题关联 1-3 个知识点
        n_kps = random.randint(1, 3)
        kps = random.sample(all_kps, n_kps)
        # 正确概率取决于知识点难度
        prob = sum(difficulty[kp] for kp in kps) / len(kps)
        is_correct = random.random() < prob

        records.append(AnswerRecord(
            student_id=student_id,
            question_id=f"q_test_{i+1:03d}",
            knowledge_points=kps,
            is_correct=is_correct,
            timestamp=datetime.now().isoformat(),
        ))

    return records


if __name__ == "__main__":
    records = generate_mock_records()
    print(f"生成了 {len(records)} 条模拟答题记录\n")

    # 模拟分析
    from analyzer import build_profiles
    profiles = build_profiles(records)

    print("知识点掌握画像:")
    print(f"{'知识点':<15} {'做题数':>6} {'正确':>6} {'正确率':>8} {'等级':<10}")
    print("-" * 50)
    for kp, p in sorted(profiles.items(), key=lambda x: x[1].accuracy):
        print(f"{kp:<15} {p.total:>6} {p.correct:>6} {p.accuracy:>7.1%} {p.level:<10}")

    # 输出为 JSON 方便前端使用
    output = {
        "student_id": "stu_test",
        "records": [r.model_dump() for r in records],
        "profiles": {k: v.model_dump() for k, v in profiles.items()},
    }
    out_path = os.path.join(os.path.dirname(__file__), "mock_output.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2, default=str)
    print(f"\n已保存到 {out_path}")
