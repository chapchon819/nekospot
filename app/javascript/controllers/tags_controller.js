import { Controller } from "@hotwired/stimulus"
import Tagify from '@yaireo/tagify'

// Connects to data-controller="tags"
export default class extends Controller {
  connect() {
    var input = document.querySelector('input[name="review[tag_ids][]"]');

    // initialize Tagify on the above input node reference
    new Tagify(input)
  }
}
