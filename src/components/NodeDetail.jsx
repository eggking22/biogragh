import React from 'react'

export default function NodeDetail({ node, onClose }) {
  if (!node) {
    return (
      <div className="detail-panel hidden" />
    )
  }

  const levelNames = { 0: '学科根节点', 1: '章', 2: '节' }
  const childCount = node.children?.length || 0

  return (
    <div className="detail-panel">
      <h2>{node.name}</h2>
      
      <div className="detail-row">
        <span className="detail-label">层级</span>
        <span className="detail-value">{levelNames[node.level] || `L${node.level}`}</span>
      </div>
      
      <div className="detail-row">
        <span className="detail-label">节点ID</span>
        <span className="detail-value" style={{ fontSize: '11px', color: '#666' }}>{node.id}</span>
      </div>

      {node.section && (
        <div className="detail-row">
          <span className="detail-label">章节号</span>
          <span className="detail-value">{node.section}</span>
        </div>
      )}

      <div className="detail-row">
        <span className="detail-label">子节点数</span>
        <span className="detail-value">{childCount}</span>
      </div>

      {childCount > 0 && (
        <div className="child-list">
          <div className="detail-label" style={{ marginBottom: 6 }}>包含：</div>
          {node.children.map(ch => (
            <div key={ch.id} className="child-item">{ch.name}</div>
          ))}
        </div>
      )}
    </div>
  )
}
