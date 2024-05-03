import { Application } from "@hotwired/stimulus"

const application = Application.start()

import { Tabs } from "tailwindcss-stimulus-components"
application.register('tabs', Tabs)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
