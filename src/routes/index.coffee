config = require '../config'

exports[resource] = require "./#{resource}" for resource in config.app.resources