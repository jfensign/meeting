{endpoint} = require './db'

module.exports = {
  development: {
    schema: { 'migration': {} },
    modelName: 'Migration',
    db: process.env.MONGOHQ_URL or endpoint
  },
  test: {
    schema: { 'migration': {} },
    modelName: 'Migration',
    db: process.env.MONGOHQ_URL or endpoint
  },
  production: {
    schema: { 'migration': {} },
    modelName: 'Migration',
    db: process.env.MONGOHQ_URL or endpoint
  }
}