// app/javascript/controllers/index.js
import { application } from "./application"
import HelloController from "./hello_controller"

application.register("hello", HelloController)
