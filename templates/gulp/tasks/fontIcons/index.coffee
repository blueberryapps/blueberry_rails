gulp              = require 'gulp'
iconfont          = require 'gulp-iconfont'
config            = require('../../config').fontIcons
generateIconSass  = require './generateIconSass'

gulp.task 'fontIcons', ->
  gulp.src(config.src)
    .pipe iconfont(config.options).on('codepoints', generateIconSass)
    .pipe gulp.dest(config.dest)
