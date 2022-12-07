require 'action_view'

class ActionView::TemplateRenderer

  def render(context, options)
    @details = extract_details(options)
    template = get_template_by_user_agent(context, options)

    prepend_formats(template.format)

    render_template(context, template, options[:layout], options[:locals] || {})
  end

  private

  def get_user_agent(context)
    if context.respond_to?(:user_agent)
      if context.respond_to?(:controller)
        if context.controller.respond_to?(:session)
          context.user_agent
        end
      end
    end
  end

  def get_template_by_user_agent(context, options)
    ret = nil
    option_for_template = options[:template]

    ua = get_user_agent(context)
    if ua
      ua.priorities.each do |priority|
        begin
          options[:template] = option_for_template + '.' + priority
          ret = determine_template(options)
          break
        rescue ActionView::MissingTemplate
        end
      end
    end

    unless ret
      options[:template] = option_for_template
      ret = determine_template(options)
    end

    Rails.logger.debug "UserAgent: #{ua ? ua.name : 'unknown'} => #{ret.identifier}"
    ret
  end
end
