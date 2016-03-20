module ApplicationHelper
  def t(_, options = {})
    translation = super
    return translation unless translation.is_a?(Array)

    translations = translation.map do |str|
      content_tag(options[:each_wrapper] || :span, str.html_safe)
    end

    translation = translations.join.html_safe

    if options[:wrapper]
      content_tag(options[:wrapper], translation)
    else
      translation
    end
  end

  def meta_robots_tag
    content = Rails.env.production? ? 'index,follow' : 'noindex,nofollow'
    content_tag(:meta, nil, name: 'robots', content: content)
  end
end
