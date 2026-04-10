import React from 'react'

export default function SearchBar({ searchTerm, onSearch }) {
  return (
    <div className="search-bar">
      <span>🔍</span>
      <input
        type="text"
        placeholder="搜索知识点..."
        value={searchTerm}
        onChange={e => onSearch(e.target.value)}
      />
    </div>
  )
}
