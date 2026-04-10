import * as d3 from 'd3'

const LEVEL_COLORS = { 0: '#E74C3C', 1: '#F39C12', 2: '#3498DB' }
const LEVEL_RADIUS = { 0: 40, 1: 22, 2: 12 }

export { LEVEL_COLORS, LEVEL_RADIUS }

export function buildGraph(jsonData, expandedNodes = new Set()) {
  const nodes = []
  const links = []
  const root = jsonData.nodes[0]

  nodes.push({
    id: root.id, name: root.name, level: root.level,
    color: LEVEL_COLORS[root.level], radius: LEVEL_RADIUS[root.level],
    hasChildren: true, expanded: expandedNodes.has(root.id),
  })

  function processChildren(parent, children, parentVisible) {
    if (!children) return
    const isVisible = parentVisible && expandedNodes.has(parent.id)
    children.forEach(child => {
      if (isVisible) {
        nodes.push({
          id: child.id, name: child.name, level: child.level,
          color: LEVEL_COLORS[child.level], radius: LEVEL_RADIUS[child.level],
          hasChildren: !!(child.children && child.children.length > 0),
          expanded: expandedNodes.has(child.id), parentId: parent.id,
        })
        links.push({ source: parent.id, target: child.id, type: 'CONTAINS' })
      }
      if (child.children) processChildren(child, child.children, isVisible)
    })
  }

  if (root.children) processChildren(root, root.children, true)
  return { nodes, links }
}
