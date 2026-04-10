import React, { useRef } from 'react'
import useGraph from '../hooks/useGraph'
import SearchBar from './SearchBar'
import NodeDetail from './NodeDetail'
import Legend from './Legend'
import './App.css'

export default function App() {
  const svgRef = useRef(null)
  const {
    selectedNode,
    expandedNodes,
    searchTerm,
    search,
    resetView,
    graphData,
  } = useGraph(svgRef)

  // 查找选中节点的详细信息
  let detail = null
  if (selectedNode) {
    const root = graphData.nodes[0]
    if (selectedNode === root.id) {
      detail = root
    } else {
      for (const ch of root.children || []) {
        if (ch.id === selectedNode) { detail = ch; break }
        for (const gc of ch.children || []) {
          if (gc.id === selectedNode) { detail = gc; break }
        }
        if (detail) break
      }
    }
  }

  const l1Count = graphData.nodes[0].children?.length || 0
  const l2Count = graphData.nodes[0].children?.reduce((sum, ch) => sum + (ch.children?.length || 0), 0) || 0
  const expandedCount = expandedNodes.size - 1 // 减去根节点

  return (
    <div className="app">
      <header className="header">
        <div className="header-left">
          <h1>🧬 生物化学知识图谱</h1>
          <span className="stats">
            {l1Count}个章节 · {l2Count}个小节 · 已展开 {expandedCount}/{l1Count}
          </span>
        </div>
        <div className="header-right">
          <SearchBar searchTerm={searchTerm} onSearch={search} />
          <button className="btn-reset" onClick={resetView}>重置视图</button>
        </div>
      </header>

      <div className="main">
        <div className="canvas-wrapper">
          <svg ref={svgRef} width="100%" height="100%" />
        </div>
        <NodeDetail node={detail} onClose={() => {}} />
      </div>

      <Legend />
    </div>
  )
}
