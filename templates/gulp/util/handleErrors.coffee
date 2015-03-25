module.exports = ->
  args = Array::slice.call(arguments)

  # Send error to notification center with gulp-notify
  #notify.onError(
   # title: 'Compile Error'
    #message: '<%= error %>').apply this, args
  console.log args

  # Keep gulp from hanging on this task
  @emit 'end'
