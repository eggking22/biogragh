// Neo4j Cypher - 生物化学知识图谱 Level 1 + Level 2 导入脚本
// 使用方式: 在 Neo4j Browser 中粘贴执行，或通过 cypher-shell 导入

// 清理旧数据（谨慎使用）
// MATCH (n:KnowledgeNode {domain: '生物化学'}) DETACH DELETE n;

// ==================== 创建根节点 ====================
CREATE (root:KnowledgeNode {
  id: 'biochem',
  name: '生物化学',
  domain: '生物化学',
  level: 0,
  color: '#E74C3C',
  description: '生物化学学科根节点'
})

// ==================== Level 1: 章节点 ====================
CREATE (c1:KnowledgeNode {id:'biochem_1', name:'绪论', domain:'生物化学', level:1, parent_id:'biochem', chapter:1})
CREATE (c2:KnowledgeNode {id:'biochem_2', name:'蛋白质', domain:'生物化学', level:1, parent_id:'biochem', chapter:2})
CREATE (c3:KnowledgeNode {id:'biochem_3', name:'核酸', domain:'生物化学', level:1, parent_id:'biochem', chapter:3})
CREATE (c4:KnowledgeNode {id:'biochem_4', name:'糖类', domain:'生物化学', level:1, parent_id:'biochem', chapter:4})
CREATE (c5:KnowledgeNode {id:'biochem_5', name:'脂质和生物膜', domain:'生物化学', level:1, parent_id:'biochem', chapter:5})
CREATE (c6:KnowledgeNode {id:'biochem_6', name:'酶', domain:'生物化学', level:1, parent_id:'biochem', chapter:6})
CREATE (c7:KnowledgeNode {id:'biochem_7', name:'维生素和辅酶', domain:'生物化学', level:1, parent_id:'biochem', chapter:7})
CREATE (c8:KnowledgeNode {id:'biochem_8', name:'新陈代谢总论与生物氧化', domain:'生物化学', level:1, parent_id:'biochem', chapter:8})
CREATE (c9:KnowledgeNode {id:'biochem_9', name:'糖代谢', domain:'生物化学', level:1, parent_id:'biochem', chapter:9})
CREATE (c10:KnowledgeNode {id:'biochem_10', name:'脂质代谢', domain:'生物化学', level:1, parent_id:'biochem', chapter:10})
CREATE (c11:KnowledgeNode {id:'biochem_11', name:'蛋白质的降解和氨基酸代谢', domain:'生物化学', level:1, parent_id:'biochem', chapter:11})
CREATE (c12:KnowledgeNode {id:'biochem_12', name:'核苷酸代谢', domain:'生物化学', level:1, parent_id:'biochem', chapter:12})
CREATE (c13:KnowledgeNode {id:'biochem_13', name:'DNA的生物合成', domain:'生物化学', level:1, parent_id:'biochem', chapter:13})
CREATE (c14:KnowledgeNode {id:'biochem_14', name:'RNA的生物合成', domain:'生物化学', level:1, parent_id:'biochem', chapter:14})
CREATE (c15:KnowledgeNode {id:'biochem_15', name:'蛋白质的生物合成', domain:'生物化学', level:1, parent_id:'biochem', chapter:15})
CREATE (c16:KnowledgeNode {id:'biochem_16', name:'物质代谢的调节控制', domain:'生物化学', level:1, parent_id:'biochem', chapter:16})

// ==================== Level 1 边: contains ====================
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_1'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_2'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_3'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_4'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_5'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_6'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_7'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_8'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_9'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_10'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_11'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_12'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_13'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_14'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_15'}) CREATE (r)-[:CONTAINS]->(c)
MATCH (r:KnowledgeNode {id:'biochem'}), (c:KnowledgeNode {id:'biochem_16'}) CREATE (r)-[:CONTAINS]->(c)

// ==================== Level 2: 节节点 ====================
// 第1章 绪论
CREATE (n:KnowledgeNode {id:'biochem_1_1', name:'生物化学的内容', domain:'生物化学', level:2, parent_id:'biochem_1', section:'1.1'})
CREATE (n:KnowledgeNode {id:'biochem_1_2', name:'生物化学的产生与发展', domain:'生物化学', level:2, parent_id:'biochem_1', section:'1.2'})
CREATE (n:KnowledgeNode {id:'biochem_1_3', name:'生物化学的知识框架和学习方法', domain:'生物化学', level:2, parent_id:'biochem_1', section:'1.3'})

// 第2章 蛋白质
CREATE (n:KnowledgeNode {id:'biochem_2_1', name:'蛋白质的分类', domain:'生物化学', level:2, parent_id:'biochem_2', section:'2.1'})
CREATE (n:KnowledgeNode {id:'biochem_2_2', name:'蛋白质的组成单位——氨基酸', domain:'生物化学', level:2, parent_id:'biochem_2', section:'2.2'})
CREATE (n:KnowledgeNode {id:'biochem_2_3', name:'肽', domain:'生物化学', level:2, parent_id:'biochem_2', section:'2.3'})
CREATE (n:KnowledgeNode {id:'biochem_2_4', name:'蛋白质的结构', domain:'生物化学', level:2, parent_id:'biochem_2', section:'2.4'})
CREATE (n:KnowledgeNode {id:'biochem_2_5', name:'蛋白质结构与功能的关系', domain:'生物化学', level:2, parent_id:'biochem_2', section:'2.5'})
CREATE (n:KnowledgeNode {id:'biochem_2_6', name:'蛋白质的性质与分离、分析技术', domain:'生物化学', level:2, parent_id:'biochem_2', section:'2.6'})

// 第3章 核酸
CREATE (n:KnowledgeNode {id:'biochem_3_1', name:'核酸的组成成分', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.1'})
CREATE (n:KnowledgeNode {id:'biochem_3_2', name:'核酸的一级结构', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.2'})
CREATE (n:KnowledgeNode {id:'biochem_3_3', name:'DNA的二级结构', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.3'})
CREATE (n:KnowledgeNode {id:'biochem_3_4', name:'DNA的高级结构', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.4'})
CREATE (n:KnowledgeNode {id:'biochem_3_5', name:'DNA和基因组', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.5'})
CREATE (n:KnowledgeNode {id:'biochem_3_6', name:'RNA的结构和功能', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.6'})
CREATE (n:KnowledgeNode {id:'biochem_3_7', name:'核酸的性质和研究方法', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.7'})
CREATE (n:KnowledgeNode {id:'biochem_3_8', name:'核酸的序列测定', domain:'生物化学', level:2, parent_id:'biochem_3', section:'3.8'})

// 第4章 糖类
CREATE (n:KnowledgeNode {id:'biochem_4_1', name:'单糖', domain:'生物化学', level:2, parent_id:'biochem_4', section:'4.1'})
CREATE (n:KnowledgeNode {id:'biochem_4_2', name:'重要单糖及其衍生物', domain:'生物化学', level:2, parent_id:'biochem_4', section:'4.2'})
CREATE (n:KnowledgeNode {id:'biochem_4_3', name:'寡糖', domain:'生物化学', level:2, parent_id:'biochem_4', section:'4.3'})
CREATE (n:KnowledgeNode {id:'biochem_4_4', name:'多糖', domain:'生物化学', level:2, parent_id:'biochem_4', section:'4.4'})
CREATE (n:KnowledgeNode {id:'biochem_4_5', name:'糖复合物', domain:'生物化学', level:2, parent_id:'biochem_4', section:'4.5'})
CREATE (n:KnowledgeNode {id:'biochem_4_6', name:'糖类研究方法', domain:'生物化学', level:2, parent_id:'biochem_4', section:'4.6'})

// 第5章 脂质和生物膜
CREATE (n:KnowledgeNode {id:'biochem_5_1', name:'三酰甘油', domain:'生物化学', level:2, parent_id:'biochem_5', section:'5.1'})
CREATE (n:KnowledgeNode {id:'biochem_5_2', name:'脂肪酸', domain:'生物化学', level:2, parent_id:'biochem_5', section:'5.2'})
CREATE (n:KnowledgeNode {id:'biochem_5_3', name:'磷脂', domain:'生物化学', level:2, parent_id:'biochem_5', section:'5.3'})
CREATE (n:KnowledgeNode {id:'biochem_5_4', name:'鞘脂', domain:'生物化学', level:2, parent_id:'biochem_5', section:'5.4'})
CREATE (n:KnowledgeNode {id:'biochem_5_5', name:'类固醇', domain:'生物化学', level:2, parent_id:'biochem_5', section:'5.5'})
CREATE (n:KnowledgeNode {id:'biochem_5_6', name:'生物膜', domain:'生物化学', level:2, parent_id:'biochem_5', section:'5.6'})

// 第6章 酶
CREATE (n:KnowledgeNode {id:'biochem_6_1', name:'酶的概念与特点', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.1'})
CREATE (n:KnowledgeNode {id:'biochem_6_2', name:'酶的化学本质与组成', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.2'})
CREATE (n:KnowledgeNode {id:'biochem_6_3', name:'酶的命名与分类', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.3'})
CREATE (n:KnowledgeNode {id:'biochem_6_4', name:'酶的结构与功能', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.4'})
CREATE (n:KnowledgeNode {id:'biochem_6_5', name:'酶的专一性', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.5'})
CREATE (n:KnowledgeNode {id:'biochem_6_6', name:'酶的作用机制', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.6'})
CREATE (n:KnowledgeNode {id:'biochem_6_7', name:'酶促反应动力学', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.7'})
CREATE (n:KnowledgeNode {id:'biochem_6_8', name:'影响酶促反应速率的因素', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.8'})
CREATE (n:KnowledgeNode {id:'biochem_6_9', name:'酶活性的调节', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.9'})
CREATE (n:KnowledgeNode {id:'biochem_6_10', name:'酶的研究方法与酶工程', domain:'生物化学', level:2, parent_id:'biochem_6', section:'6.10'})

// 第7章 维生素和辅酶
CREATE (n:KnowledgeNode {id:'biochem_7_1', name:'脂溶性维生素', domain:'生物化学', level:2, parent_id:'biochem_7', section:'7.1'})
CREATE (n:KnowledgeNode {id:'biochem_7_2', name:'水溶性维生素', domain:'生物化学', level:2, parent_id:'biochem_7', section:'7.2'})

// 第8章 新陈代谢总论与生物氧化
CREATE (n:KnowledgeNode {id:'biochem_8_1', name:'新陈代谢总论', domain:'生物化学', level:2, parent_id:'biochem_8', section:'8.1'})
CREATE (n:KnowledgeNode {id:'biochem_8_2', name:'生物氧化', domain:'生物化学', level:2, parent_id:'biochem_8', section:'8.2'})

// 第9章 糖代谢
CREATE (n:KnowledgeNode {id:'biochem_9_1', name:'多糖和低聚糖的酶促降解', domain:'生物化学', level:2, parent_id:'biochem_9', section:'9.1'})
CREATE (n:KnowledgeNode {id:'biochem_9_2', name:'糖的分解代谢', domain:'生物化学', level:2, parent_id:'biochem_9', section:'9.2'})
CREATE (n:KnowledgeNode {id:'biochem_9_3', name:'糖的合成代谢', domain:'生物化学', level:2, parent_id:'biochem_9', section:'9.3'})

// 第10章 脂质代谢
CREATE (n:KnowledgeNode {id:'biochem_10_1', name:'脂质的酶促水解', domain:'生物化学', level:2, parent_id:'biochem_10', section:'10.1'})
CREATE (n:KnowledgeNode {id:'biochem_10_2', name:'三酰甘油的分解代谢', domain:'生物化学', level:2, parent_id:'biochem_10', section:'10.2'})
CREATE (n:KnowledgeNode {id:'biochem_10_3', name:'三酰甘油的合成代谢', domain:'生物化学', level:2, parent_id:'biochem_10', section:'10.3'})
CREATE (n:KnowledgeNode {id:'biochem_10_4', name:'磷脂的代谢', domain:'生物化学', level:2, parent_id:'biochem_10', section:'10.4'})
CREATE (n:KnowledgeNode {id:'biochem_10_5', name:'胆固醇的代谢', domain:'生物化学', level:2, parent_id:'biochem_10', section:'10.5'})

// 第11章 蛋白质的降解和氨基酸代谢
CREATE (n:KnowledgeNode {id:'biochem_11_1', name:'蛋白质的酶促降解', domain:'生物化学', level:2, parent_id:'biochem_11', section:'11.1'})
CREATE (n:KnowledgeNode {id:'biochem_11_2', name:'氨基酸的分解代谢', domain:'生物化学', level:2, parent_id:'biochem_11', section:'11.2'})
CREATE (n:KnowledgeNode {id:'biochem_11_3', name:'氨基酸合成代谢', domain:'生物化学', level:2, parent_id:'biochem_11', section:'11.3'})

// 第12章 核苷酸代谢
CREATE (n:KnowledgeNode {id:'biochem_12_1', name:'核酸的酶促降解', domain:'生物化学', level:2, parent_id:'biochem_12', section:'12.1'})
CREATE (n:KnowledgeNode {id:'biochem_12_2', name:'核苷酸的分解', domain:'生物化学', level:2, parent_id:'biochem_12', section:'12.2'})
CREATE (n:KnowledgeNode {id:'biochem_12_3', name:'核苷酸的生物合成', domain:'生物化学', level:2, parent_id:'biochem_12', section:'12.3'})
CREATE (n:KnowledgeNode {id:'biochem_12_4', name:'核苷酸生物合成的调节', domain:'生物化学', level:2, parent_id:'biochem_12', section:'12.4'})
CREATE (n:KnowledgeNode {id:'biochem_12_5', name:'核苷酸合成的抗代谢物', domain:'生物化学', level:2, parent_id:'biochem_12', section:'12.5'})
CREATE (n:KnowledgeNode {id:'biochem_12_6', name:'辅酶核苷酸的生物合成', domain:'生物化学', level:2, parent_id:'biochem_12', section:'12.6'})

// 第13章 DNA的生物合成
CREATE (n:KnowledgeNode {id:'biochem_13_1', name:'DNA复制的概况', domain:'生物化学', level:2, parent_id:'biochem_13', section:'13.1'})
CREATE (n:KnowledgeNode {id:'biochem_13_2', name:'原核生物DNA的复制', domain:'生物化学', level:2, parent_id:'biochem_13', section:'13.2'})
CREATE (n:KnowledgeNode {id:'biochem_13_3', name:'真核生物DNA的复制', domain:'生物化学', level:2, parent_id:'biochem_13', section:'13.3'})
CREATE (n:KnowledgeNode {id:'biochem_13_4', name:'逆转录作用', domain:'生物化学', level:2, parent_id:'biochem_13', section:'13.4'})
CREATE (n:KnowledgeNode {id:'biochem_13_5', name:'DNA的损伤与修复', domain:'生物化学', level:2, parent_id:'biochem_13', section:'13.5'})
CREATE (n:KnowledgeNode {id:'biochem_13_6', name:'DNA重组和克隆', domain:'生物化学', level:2, parent_id:'biochem_13', section:'13.6'})

// 第14章 RNA的生物合成
CREATE (n:KnowledgeNode {id:'biochem_14_1', name:'RNA生物合成的概况', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.1'})
CREATE (n:KnowledgeNode {id:'biochem_14_2', name:'原核生物的转录', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.2'})
CREATE (n:KnowledgeNode {id:'biochem_14_3', name:'真核生物的转录', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.3'})
CREATE (n:KnowledgeNode {id:'biochem_14_4', name:'原核生物和真核生物转录调控的特点', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.4'})
CREATE (n:KnowledgeNode {id:'biochem_14_5', name:'转录的选择性抑制', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.5'})
CREATE (n:KnowledgeNode {id:'biochem_14_6', name:'转录产物的加工', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.6'})
CREATE (n:KnowledgeNode {id:'biochem_14_7', name:'RNA的复制', domain:'生物化学', level:2, parent_id:'biochem_14', section:'14.7'})

// 第15章 蛋白质的生物合成
CREATE (n:KnowledgeNode {id:'biochem_15_1', name:'蛋白质合成体系', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.1'})
CREATE (n:KnowledgeNode {id:'biochem_15_2', name:'蛋白质的合成过程', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.2'})
CREATE (n:KnowledgeNode {id:'biochem_15_3', name:'蛋白质合成后的加工', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.3'})
CREATE (n:KnowledgeNode {id:'biochem_15_4', name:'蛋白质合成所需的能量', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.4'})
CREATE (n:KnowledgeNode {id:'biochem_15_5', name:'蛋白质的定向转运', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.5'})
CREATE (n:KnowledgeNode {id:'biochem_15_6', name:'蛋白质合成的抑制剂', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.6'})
CREATE (n:KnowledgeNode {id:'biochem_15_7', name:'寡肽的生物合成', domain:'生物化学', level:2, parent_id:'biochem_15', section:'15.7'})

// 第16章 物质代谢的调节控制
CREATE (n:KnowledgeNode {id:'biochem_16_1', name:'物质代谢的相互联系', domain:'生物化学', level:2, parent_id:'biochem_16', section:'16.1'})
CREATE (n:KnowledgeNode {id:'biochem_16_2', name:'分子水平的调节', domain:'生物化学', level:2, parent_id:'biochem_16', section:'16.2'})
CREATE (n:KnowledgeNode {id:'biochem_16_3', name:'细胞水平的调节', domain:'生物化学', level:2, parent_id:'biochem_16', section:'16.3'})
CREATE (n:KnowledgeNode {id:'biochem_16_4', name:'多细胞整体水平的调节', domain:'生物化学', level:2, parent_id:'biochem_16', section:'16.4'})

// ==================== Level 2 边: contains ====================
MATCH (p:KnowledgeNode {id:'biochem_1'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_1' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_2'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_2' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_3'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_3' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_4'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_4' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_5'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_5' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_6'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_6' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_7'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_7' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_8'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_8' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_9'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_9' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_10'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_10' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_11'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_11' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_12'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_12' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_13'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_13' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_14'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_14' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_15'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_15' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)
MATCH (p:KnowledgeNode {id:'biochem_16'}), (c:KnowledgeNode) WHERE c.parent_id = 'biochem_16' AND c.level = 2 CREATE (p)-[:CONTAINS]->(c)

// ==================== 跨章 RELATED 边（代谢通路关联）====================
// 糖类(4) → 糖代谢(9)
MATCH (a:KnowledgeNode {id:'biochem_4'}), (b:KnowledgeNode {id:'biochem_9'}) CREATE (a)-[:RELATED {type:'代谢通路'}]->(b)
// 脂质(5) → 脂质代谢(10)
MATCH (a:KnowledgeNode {id:'biochem_5'}), (b:KnowledgeNode {id:'biochem_10'}) CREATE (a)-[:RELATED {type:'代谢通路'}]->(b)
// 蛋白质(2) → 氨基酸代谢(11)
MATCH (a:KnowledgeNode {id:'biochem_2'}), (b:KnowledgeNode {id:'biochem_11'}) CREATE (a)-[:RELATED {type:'代谢通路'}]->(b)
// 核酸(3) → 核苷酸代谢(12)
MATCH (a:KnowledgeNode {id:'biochem_3'}), (b:KnowledgeNode {id:'biochem_12'}) CREATE (a)-[:RELATED {type:'代谢通路'}]->(b)
// 核酸(3) → DNA合成(13)
MATCH (a:KnowledgeNode {id:'biochem_3'}), (b:KnowledgeNode {id:'biochem_13'}) CREATE (a)-[:RELATED {type:'信息流'}]->(b)
// DNA合成(13) → RNA合成(14)
MATCH (a:KnowledgeNode {id:'biochem_13'}), (b:KnowledgeNode {id:'biochem_14'}) CREATE (a)-[:RELATED {type:'中心法则'}]->(b)
// RNA合成(14) → 蛋白质合成(15)
MATCH (a:KnowledgeNode {id:'biochem_14'}), (b:KnowledgeNode {id:'biochem_15'}) CREATE (a)-[:RELATED {type:'中心法则'}]->(b)
// 酶(6) → 各代谢章(9,10,11,12)
MATCH (a:KnowledgeNode {id:'biochem_6'}), (b:KnowledgeNode {id:'biochem_9'}) CREATE (a)-[:RELATED {type:'催化'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_6'}), (b:KnowledgeNode {id:'biochem_10'}) CREATE (a)-[:RELATED {type:'催化'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_6'}), (b:KnowledgeNode {id:'biochem_11'}) CREATE (a)-[:RELATED {type:'催化'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_6'}), (b:KnowledgeNode {id:'biochem_12'}) CREATE (a)-[:RELATED {type:'催化'}]->(b)
// 维生素和辅酶(7) → 酶(6)
MATCH (a:KnowledgeNode {id:'biochem_7'}), (b:KnowledgeNode {id:'biochem_6'}) CREATE (a)-[:RELATED {type:'辅因子'}]->(b)
// 生物氧化(8) → 各代谢章
MATCH (a:KnowledgeNode {id:'biochem_8'}), (b:KnowledgeNode {id:'biochem_9'}) CREATE (a)-[:RELATED {type:'能量'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_8'}), (b:KnowledgeNode {id:'biochem_10'}) CREATE (a)-[:RELATED {type:'能量'}]->(b)
// 调节控制(16) → 各代谢章
MATCH (a:KnowledgeNode {id:'biochem_16'}), (b:KnowledgeNode {id:'biochem_9'}) CREATE (a)-[:RELATED {type:'调控'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_16'}), (b:KnowledgeNode {id:'biochem_10'}) CREATE (a)-[:RELATED {type:'调控'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_16'}), (b:KnowledgeNode {id:'biochem_11'}) CREATE (a)-[:RELATED {type:'调控'}]->(b)
MATCH (a:KnowledgeNode {id:'biochem_16'}), (b:KnowledgeNode {id:'biochem_12'}) CREATE (a)-[:RELATED {type:'调控'}]->(b)
