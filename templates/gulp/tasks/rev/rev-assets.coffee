config  = require '../../config'
gulp    = require 'gulp'
rev     = require 'gulp-rev'

# Add md5 hashes to assets
gulp.task 'rev-assets', ->
  gulp.src(config.publicAssets + '/**/**.!(css|js|eot|woff|ttf)')
    .pipe rev()
    .pipe gulp.dest(config.publicAssets)
    .pipe rev.manifest()
    .pipe gulp.dest(config.publicAssets)
