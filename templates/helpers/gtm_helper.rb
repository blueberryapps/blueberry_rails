module GtmHelper
  def addEvent(options = {})
    args = map_options options

    content_for :javascript do
      javascript_tag("dataLayer.push({ #{args} });")
    end
  end

  def renderEvent(options = {})
    args = map_options options
    javascript_tag("dataLayer.push({ #{args} });")
  end

  def renderJsEvent(options = {})
    args = map_options options
    raw "dataLayer.push({ #{args} });"
  end

  private

  def map_options(options)
    default_options = { 'event': 'GAevent' }
    merged_options = default_options.merge(options)
    mappings = { 'category': 'eventCategory', 'action': 'eventAction', 'label': 'eventLabel', 'value': 'eventValue', 'event': 'event' }

    args = merged_options.map { |key, value| [mappings[key], value] }
                  .map { |a| "'#{a[0]}': '#{a[1]}'" }.join(', ')
  end
end
