config        = require '../../config'
gulp          = require 'gulp'
revCollector  = require 'gulp-rev-collector'

# Replace asset references in compiled CSS and JS files
gulp.task 'rev', [ 'rev-assets', 'rev-font-workaround' ], ->
  gulp.src([
    config.publicAssets + '/rev-manifest.json'
    config.publicAssets + '/**/*.{css,js}'
  ])
    .pipe revCollector()
    .pipe gulp.dest(config.publicAssets)
