// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import Dropdown from '@stimulus-components/dropdown'
application.register('dropdown', Dropdown)

import AccordionController from "./accordion_controller"
application.register("accordion", AccordionController)

import DiagnosticController from "./diagnostic_controller"
application.register("diagnostic", DiagnosticController)

import DrawerController from "./drawer_controller"
application.register("drawer", DrawerController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import ImageModalController from "./image_modal_controller"
application.register("image-modal", ImageModalController)

import LoginModalController from "./login_modal_controller"
application.register("login-modal", LoginModalController)

import RadioTagsController from "./radio_tags_controller"
application.register("radio-tags", RadioTagsController)

import ReviewModalController from "./review_modal_controller"
application.register("review-modal", ReviewModalController)

import SearchAccordionController from "./search_accordion_controller"
application.register("search-accordion", SearchAccordionController)

import SidebarController from "./sidebar_controller"
application.register("sidebar", SidebarController)

import SortController from "./sort_controller"
application.register("sort", SortController)

import TagsController from "./tags_controller"
application.register("tags", TagsController)

import UploadController from "./upload_controller"
application.register("upload", UploadController)
