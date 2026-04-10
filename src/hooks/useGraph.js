import { useState, useEffect, useRef, useCallback } from 'react'
import * as d3 from 'd3'
import graphData from '../../public/data/biochem_graph_l1_l2.json'
import { buildGraph } from '../utils/graphBuilder'

export default function useGraph(svgRef) {
  const [expandedNodes, setExpandedNodes] = useState(new Set(['biochem']))
  const [selectedNode, setSelectedNode] = useState(null)
  const [searchTerm, setSearchTerm] = useState('')
  const simulationRef = useRef(null)

  const toggleNode = useCallback((nodeId) => {
    setExpandedNodes(prev => {
      const next = new Set(prev)
      if (next.has(nodeId)) {
        next.delete(nodeId)
      } else {
        next.add(nodeId)
      }
      return next
    })
  }, [])

  useEffect(() => {
    if (!svgRef.current) return

    const svg = d3.select(svgRef.current)
    const width = svgRef.current.parentElement.clientWidth
    const height = svgRef.current.parentElement.clientHeight

    svg.selectAll('*').remove()

    const { nodes, links } = buildGraph(graphData, expandedNodes)

    // 标记搜索匹配
    const matchedIds = new Set()
    if (searchTerm) {
      nodes.forEach(n => {
        if (n.name.toLowerCase().includes(searchTerm.toLowerCase())) {
          matchedIds.add(n.id)
        }
      })
    }

    const g = svg.append('g')

    // 缩放
    const zoom = d3.zoom()
      .scaleExtent([0.3, 4])
      .on('zoom', (event) => {
        g.attr('transform', event.transform)
      })
    svg.call(zoom)

    // 初始居中
    svg.call(zoom.transform, d3.zoomIdentity.translate(width / 2, height / 2))

    // 力模拟
    if (simulationRef.current) simulationRef.current.stop()

    const simulation = d3.forceSimulation(nodes)
      .force('link', d3.forceLink(links).id(d => d.id).distance(d => {
        if (d.source.level === 0) return 160
        return 100
      }))
      .force('charge', d3.forceManyBody().strength(d => {
        if (d.level === 0) return -800
        if (d.level === 1) return -400
        return -150
      }))
      .force('center', d3.forceCenter(0, 0))
      .force('collision', d3.forceCollide().radius(d => d.radius + 8))

    simulationRef.current = simulation

    // 连线
    const link = g.append('g')
      .selectAll('line')
      .data(links)
      .join('line')
      .attr('stroke', '#2a3a4a')
      .attr('stroke-width', d => d.source.level === 0 ? 2 : 1.5)
      .attr('stroke-opacity', 0.6)

    // 节点组
    const node = g.append('g')
      .selectAll('g')
      .data(nodes)
      .join('g')
      .style('cursor', d => d.hasChildren ? 'pointer' : 'default')
      .call(d3.drag()
        .on('start', (event, d) => {
          if (!event.active) simulation.alphaTarget(0.3).restart()
          d.fx = d.x
          d.fy = d.y
        })
        .on('drag', (event, d) => {
          d.fx = event.x
          d.fy = event.y
        })
        .on('end', (event, d) => {
          if (!event.active) simulation.alphaTarget(0)
          d.fx = null
          d.fy = null
        })
      )

    // 节点圆形
    node.append('circle')
      .attr('r', d => d.radius)
      .attr('fill', d => {
        if (searchTerm && matchedIds.has(d.id)) return '#00ff88'
        return d.color
      })
      .attr('fill-opacity', d => {
        if (searchTerm && !matchedIds.has(d.id) && matchedIds.size > 0) return 0.3
        return 0.9
      })
      .attr('stroke', d => {
        if (selectedNode === d.id) return '#fff'
        return 'none'
      })
      .attr('stroke-width', 3)

    // 展开/折叠指示器
    node.filter(d => d.hasChildren)
      .append('text')
      .attr('text-anchor', 'middle')
      .attr('dy', d => d.radius + 14)
      .attr('fill', '#888')
      .attr('font-size', '12px')
      .text(d => d.expanded ? '▼' : '▶')

    // 节点标签
    node.append('text')
      .attr('text-anchor', 'middle')
      .attr('dy', d => d.hasChildren ? d.radius + 28 : d.radius + 16)
      .attr('fill', d => {
        if (searchTerm && matchedIds.has(d.id)) return '#00ff88'
        return '#ccc'
      })
      .attr('font-size', d => d.level === 0 ? '14px' : d.level === 1 ? '11px' : '10px')
      .attr('font-weight', d => d.level === 0 ? 'bold' : 'normal')
      .text(d => {
        const maxLen = d.level === 0 ? 10 : d.level === 1 ? 8 : 6
        return d.name.length > maxLen ? d.name.slice(0, maxLen) + '…' : d.name
      })

    // 点击事件
    node.on('click', (event, d) => {
      event.stopPropagation()
      setSelectedNode(d.id)
      if (d.hasChildren) {
        toggleNode(d.id)
      }
    })

    // Tick
    simulation.on('tick', () => {
      link
        .attr('x1', d => d.source.x)
        .attr('y1', d => d.source.y)
        .attr('x2', d => d.target.x)
        .attr('y2', d => d.target.y)

      node.attr('transform', d => `translate(${d.x},${d.y})`)
    })

    return () => {
      simulation.stop()
    }
  }, [expandedNodes, selectedNode, searchTerm, svgRef])

  // 搜索
  const search = useCallback((term) => {
    setSearchTerm(term)
  }, [])

  // 重置视图
  const resetView = useCallback(() => {
    setExpandedNodes(new Set(['biochem']))
    setSelectedNode(null)
    setSearchTerm('')
  }, [])

  return {
    selectedNode,
    expandedNodes,
    searchTerm,
    search,
    resetView,
    toggleNode,
    graphData,
  }
}
