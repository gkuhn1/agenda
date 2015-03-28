module NavHelper
  def nav_link(page, &link_text)
    class_name = request.env['PATH_INFO'].end_with?(page) ? 'active' : nil

    content_tag(:li, class: class_name) do
      link_to page do
        link_text.call
      end
    end
  end

  def admin_link(link="#", text="Novo", klass="fa fa-angle-double-right")
    return nav_link link do
      "<i class='#{klass}'></i> #{text}".html_safe
    end
  end

  def treeview_link(text, &links)
    content = link_to('#') do
      content_tag(:span, text) <<
      content_tag(:i, '', class: "fa pull-right fa-angle-left")
    end

    links_html = capture_haml do
      links.call
    end
    active = breadrumb_to_menus.select {|path| path.in?(links_html) }.any?

    content << content_tag(:ul, class: "treeview-menu") do
      links_html
    end

    content_tag :li, class: "treeview #{active ? 'active' : ''}" do
      content
    end
  end
end