require 'action_view/template/resolver'

ActionView::PathResolver::EXTENSIONS = { locale: ".", variants: ".", formats: ".",  handlers: "." }
ActionView::PathResolver::DEFAULT_PATTERN = ":prefix/:action{.:locale,}{.:variants,}{.:formats,}{.:handlers,}"
