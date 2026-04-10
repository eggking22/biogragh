import React from 'react'

export default function Legend() {
  return (
    <div className="legend">
      <div className="legend-title">图例</div>
      <div className="legend-item">
        <div className="legend-dot" style={{ background: '#E74C3C', width: 16, height: 16 }} />
        学科根节点
      </div>
      <div className="legend-item">
        <div className="legend-dot" style={{ background: '#F39C12', width: 12, height: 12 }} />
        一级节点（章）
      </div>
      <div className="legend-item">
        <div className="legend-dot" style={{ background: '#3498DB', width: 8, height: 8 }} />
        二级节点（节）
      </div>
      <div className="legend-item" style={{ marginTop: 8, color: '#666' }}>
        点击章节点展开/折叠
      </div>
    </div>
  )
}
