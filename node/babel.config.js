module.exports = {
  plugins: [
    ['@babel/plugin-proposal-pipeline-operator', { proposal: 'smart' }],
    [
      'module-resolver',
      {
        root: [__dirname + '/node_modules']
      }
    ]
  ]
}
