### Notes:
   - gulp/tasks/browserify.js handles js recompiling with watchify
   - gulp/tasks/browserSync.js watches and reloads compiled files
###

gulp    = require 'gulp'
config  = require '../config'
watch   = require 'gulp-watch'

gulp.task 'watch', [ 'watchify', 'browserSync' ], (callback) ->
  watch config.sass.src, ->
    gulp.start 'sass'
  watch config.images.src, ->
    gulp.start 'images'
