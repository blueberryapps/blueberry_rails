# 2) Font rev workaround
_       = require 'lodash'
config  = require '../../config'
fs      = require 'fs'
gulp    = require 'gulp'
merge   = require 'merge-stream'
rename  = require 'gulp-rename'
rev     = require 'gulp-rev'

# .ttf fonts have an embedded timestamp, which cause the contents
# of the file to change ever-so-slightly. This was a problem for
# file reving, which generates a hash based on the contents of the file.
# This meant that even if source files had not changed, the hash would
# change with every recompile, as well as .eot, and .woff files, which
# are derived from a source svg font
# The solution is to only hash svg font files, then append the
# generated hash to the ttf, eot, and woff files (instead of
# leting each file generate its own hash)

gulp.task 'rev-font-workaround', [ 'rev-assets' ], ->
  manifest = require('../../.' + config.publicAssets + '/rev-manifest.json')
  fontList = []

  _.each manifest, (reference, key) ->
    fontPath = config.fontIcons.dest.split(config.publicAssets)[1].substr(1)

    if key.match(fontPath + '/' + config.fontIcons.options.fontName)
      path = key.split('.svg')[0]
      hash = reference.split(path)[1].split('.svg')[0]

      fontList.push
        path: path
        hash: hash

  # Add hash to non-svg font files
  streams = fontList.map((file) ->
    # Add references in manifest
    [ '.eot', '.woff', '.ttf' ].forEach (ext) ->
      manifest[file.path + ext] = file.path + file.hash + ext

    gulp.src(config.publicAssets + '/' + file.path + '*.!(svg)')
      .pipe rename(suffix: file.hash)
      .pipe gulp.dest(config.fontIcons.dest)
  )

  # Re-write rev-manifest.json to disk
  fs.writeFile config.publicAssets + '/rev-manifest.json',
               JSON.stringify(manifest, null, 2)
  merge.apply this, streams
