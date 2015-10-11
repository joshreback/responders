# Writing DRY Controllers with Responders

### Understanding Responders

- There are 3 variables that affect how controllers respond:

1. Request Type - Navigational (HTML) or API (JSON)
2. HTTP Verb - GET, DELETE, POST, PUT
3. Resource Status - The result of the operation


### Exploring ActionController::Responder

- Anything that responds to `call()` and accepts 3 arguments can be a responder
- The three arguments are: the current controller, the resource (or array of resources), and a hash of options
- Inside `ActionController::Responder` the responder tries to invoke the `default_render` method before falling back to the
  API or Navigational behavior (default case depending on request type)

_Code path for Navigation Requests_
- For a GET request, it raises a missing-template error
- For other HTTP verbs, it redirects to the resource if there are no errors
- If there are errors, it renders a default action

_Code path for API Requests_
- It merges the options given to repond_with and adds a format
- Important to note that responders do not call `resource.to_<format>`
  - That behavior is delegated to the render method

- We can also customize responders by passing a block (in the `respond_to` style)
- We can change how all controllers respond by setting the responder (either at the application level or the controller level)

### Creating our own responder

- Goal: Create a way to change default flash messages
  - Will use the i18n framework to set flash messages in YAML files, configure default values, and make it possible to translate such messages in the future.

### HTTP Cache Responder

Caching mechanism works as folllows:
- Server returns a Last-Modified header to the response
- Client adds an If-Modified-Since header with timestamp equal to the Last-Modified header
- When server processes the subsequent request, if the resource has not changed it returns `304 Not Modified`

### Writing A Scaffold Controller Generator to use respond_with

- The source path for a generator looks in the `lib/templates` directory before using the one Rails provides.
  - Specifically, this should be available at: `lib/templates/rails/scaffold_controller/controller.rb`, Rails will use that file instead.
(Skipped this section)

- Rails also provides an abstraction called `orm_class` and `orm_instance` (inside Rails::Generators::ActiveModel) that tells the Rails scaffold generator how to interact with the underlying ORM
- Any ORM can provide its own implementation of this class which is defined in the ORM generator namespace
- Specifically, the class would be defined as
'''
module DataMapper
  module Generators
    class ActiveModel < ::Rails::Generators::ActiveModel
      ...
    end
  end
end
'''
- Thus, the Rails scaffold generators are agnostic about the underlying ORM

















