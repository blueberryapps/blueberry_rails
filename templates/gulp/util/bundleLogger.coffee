### bundleLogger
  Provides gulp style logs to the bundle method in browserify.js
###

gutil         = require 'gulp-util'
prettyHrtime  = require 'pretty-hrtime'
startTime     = undefined

module.exports =
  start: (filepath) ->
    startTime = process.hrtime()
    gutil.log 'Bundling', gutil.colors.green(filepath) + '...'

  watch: (bundleName) ->
    gutil.log 'Watching files required by', gutil.colors.yellow(bundleName)

  end: (filepath) ->
    taskTime = process.hrtime(startTime)
    prettyTime = prettyHrtime(taskTime)
    gutil.log 'Bundled',
              gutil.colors.green(filepath),
              'in',
              gutil.colors.magenta(prettyTime)
