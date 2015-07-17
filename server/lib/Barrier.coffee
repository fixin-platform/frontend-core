class Barrier
  constructor: ->
    @futures = []
  add: (func) ->
    @push(func.future()())
  push: (future) ->
    @futures.push(future)
  resolver: ->
    future = new Future
    @push(future)
    future.resolver()
  wait: ->
    @get()
    # using @get() instead of code below, because otherwise the first future to throw an exception will halt execution
    # however, the code calling this function (@wait()) should be inherently parallel, so the execution should only be halted after every parallel process has been finished
    # future.detach() for future in @futures # futures will throw exceptions into current execution context
    # Future.wait(@futures)
  get: ->
    Future.wait(@futures)
    future.get() for future in @futures


