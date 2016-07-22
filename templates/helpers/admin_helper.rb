module AdminHelper
  def simple_form_for(record, options = {}, &block)
    if controller.send(:_layout) == 'admin'
      options.reverse_merge!(wrapper: :vertical_form)
    end
    super
  end
end
