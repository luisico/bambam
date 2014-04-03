require 'nokogiri'

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  if html.children.size > 0
    node = html.children.first
    if node.type != 'hidden'
      css = node['class'] || ""
      node['class'] = css.split.push("error").uniq.join(' ')
      if node.name != 'label'
        errors = Array(instance.error_message).join(', ')
        node.after %{ <small class="error">&nbsp;#{errors}</small> }
      end
    end
  end
  html.to_html.html_safe
end
