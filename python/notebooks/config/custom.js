new Promise(resolve => {
  window.findParent = (node, sel) => {
    while (node !== document.body) {
      if (node.classList.contains(sel)) return node
      node = node.parentElement
    }
  }

  window.shell_initialized = () => {
    document.querySelectorAll('__marked').forEach(clear_cell_classes)
  }

  window.clear_cell_classes = cell => {
    cell.classList.remove('__marked')
    cell.classList.remove('running')
    cell.classList.remove('done')
    cell.classList.remove('success')
    cell.classList.remove('failed')
  }

  window.pre_run_cell = id => {
    const me = document.getElementById('output-' + id)
    const cell = findParent(me, 'jp-Notebook-cell')
    cell.id = 'cell-' + id

    clear_cell_classes(cell)

    cell.classList.add('__marked')
    cell.classList.add('running')
  }

  window.post_run_cell = (id, success) => {
    const cell = document.getElementById('cell-' + id)
    clear_cell_classes(cell)
    cell.classList.add('__marked')
    cell.classList.add('done')
    cell.classList.add(success === 'True' ? 'success' : 'failed')
  }

  resolve()
})
