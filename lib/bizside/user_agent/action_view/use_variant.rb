require 'action_view/template/resolver'

ActionView::PathResolver.instance_eval { remove_const :EXTENSIONS }
ActionView::PathResolver.instance_eval { remove_const :DEFAULT_PATTERN }
ActionView::PathResolver::EXTENSIONS = { locale: ".", variants: ".", formats: ".",  handlers: "." }
ActionView::PathResolver::DEFAULT_PATTERN = ":prefix/:action{.:locale,}{.:variants,}{.:formats,}{.:handlers,}"
