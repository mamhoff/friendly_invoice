# Configure js-routes to use a format compatible with the Rails asset pipeline
# By default, js-routes 2.3+ uses ES6 modules which require type="module"
# Setting module_type to nil with a namespace makes it expose Routes as a global variable
JsRoutes.setup do |config|
  config.module_type = nil
  config.namespace = 'Routes'
  config.exclude = []
  config.compact = false
end
