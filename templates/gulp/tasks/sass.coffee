gulp          = require 'gulp'
browserSync   = require 'browser-sync'
sass          = require 'gulp-sass'
sourcemaps    = require 'gulp-sourcemaps'
minifyCSS     = require 'gulp-minify-css'
handleErrors  = require '../util/handleErrors'
config        = require('../config').sass
autoprefixer  = require 'gulp-autoprefixer'

gulp.task 'sass', ->
  gulp.src(config.src)
    .pipe sourcemaps.init()
    .pipe sass(config.settings).on('error', handleErrors)
    .pipe autoprefixer(browsers: [ 'last 2 version' ])
    .pipe sourcemaps.write()
    .pipe gulp.dest(config.dest)
    .pipe browserSync.reload(stream: true)

gulp.task 'sass:production', ->
  gulp.src(config.src)
    .pipe sass(config.settings).on('error', handleErrors)
    .pipe autoprefixer(browsers: [ 'last 2 version' ])
    .pipe minifyCSS()
    .pipe gulp.dest(config.dest)
