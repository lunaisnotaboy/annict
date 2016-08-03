Vue = require "vue"

module.exports = Vue.extend
  props:
    isSpoiler:
      type: Boolean
      default: true
      coerce: (val) ->
        JSON.parse(val)
    activity:
      type: Object

  methods:
    $comment: ->
      $(@$el).parent().find(".a-record-comment")

    remove: ->
      @$comment().removeClass("ann-comment-guard")
      @isSpoiler = false

  ready: ->
    console.log '@isSpoiler: ', @isSpoiler
    @$comment().addClass("ann-comment-guard") if @isSpoiler
