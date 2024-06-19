import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tags"
export default class extends Controller {
  connect() {
    var input = document.querySelector('input[name="review[tag_ids][]"]'),
    tagify = new Tagify(input, {whitelist:[]}),
    controller; // for aborting the call

// listen to any keystrokes which modify tagify's input
tagify.on('input', onInput)

function onInput( e ){
  var value = e.detail.value
  tagify.whitelist = null // reset the whitelist

  // https://developer.mozilla.org/en-US/docs/Web/API/AbortController/abort
  controller && controller.abort()
  controller = new AbortController()

  // show loading animation.
  tagify.loading(true)

  fetch(`/tags/search?query=${value}`, {signal:controller.signal})
    .then(RES => RES.json())
    .then(function(newWhitelist){
      tagify.whitelist = newWhitelist // update whitelist Array in-place
      tagify.loading(false).dropdown.show(value) // render the suggestions dropdown
    })
  }}
}
