_             = require 'lodash'
browserify    = require 'browserify'
browserSync   = require 'browser-sync'
bundleLogger  = require '../util/bundleLogger'
config        = require('../config').browserify
gulp          = require 'gulp'
handleErrors  = require '../util/handleErrors'
source        = require 'vinyl-source-stream'
watchify      = require 'watchify'

browserifyTask = (callback, devMode) ->
  bundleQueue = config.bundleConfigs.length

  browserifyThis = (bundleConfig) ->
    if devMode
      _.extend bundleConfig, watchify.args, debug: true
      bundleConfig = _.omit(bundleConfig, [ 'external', 'require' ])
    b = browserify(bundleConfig)

    bundle = ->
      bundleLogger.start bundleConfig.outputName

      b.bundle().on('error', handleErrors)
        .pipe source(bundleConfig.outputName)
        .pipe gulp.dest(bundleConfig.dest).on('end', reportFinished)
        .pipe browserSync.reload(stream: true)

    if devMode
      b = watchify(b)
      b.on 'update', bundle
      bundleLogger.watch bundleConfig.outputName
    else
      if bundleConfig.require
        b.require bundleConfig.require
      if bundleConfig.external
        b.external bundleConfig.external

    reportFinished = ->
      bundleLogger.end bundleConfig.outputName
      if bundleQueue
        bundleQueue--
        if bundleQueue == 0
          callback()

    bundle()

  config.bundleConfigs.forEach browserifyThis

gulp.task 'browserify', browserifyTask
module.exports = browserifyTask
