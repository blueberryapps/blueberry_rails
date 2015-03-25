gulp          = require 'gulp'
gulpSequence  = require 'gulp-sequence'

gulp.task 'build', (cb) ->
  tasks = [
    'clean'
    [ 'fontIcons', 'images' ]
    [ 'sass:production', 'browserify' ]
  ]

  if process.env.RAILS_ENV == 'production'
    tasks.push 'rev'

  tasks.push cb
  gulpSequence.apply this, tasks

gulp.task 'development', (cb) ->
  tasks = [
    'clean'
    [ 'fontIcons', 'images' ]
    [ 'sass', 'browserify' ]
  ]

  tasks.push cb
  gulpSequence.apply this, tasks
