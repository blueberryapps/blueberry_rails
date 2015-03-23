browserSync   = require 'browser-sync'
gulp          = require 'gulp'
config        = require('../config').browserSync

gulp.task 'browserSync', ->
  browserSync config
