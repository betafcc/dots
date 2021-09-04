module.exports = {
  plugins: [
    ['@babel/plugin-proposal-pipeline-operator', {
      proposal: 'hack',
      topicToken: '#',
    }],
    [
      'module-resolver',
      {
        root: [__dirname + '/node_modules']
      }
    ]
  ]
}
