 (($) ->
  $.fn.present = (selector, options, callback) ->
    if typeof callback is "undefined"
      callback = options
      options = {}
    @arrive(selector, options, callback)
    # possible race condition: an element may be created between calls to @arrive() and @find()
    callback.call(element) for element in @find(selector)
)(jQuery)

