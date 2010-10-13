module FoldersHelper
include ApplicationHelper
  # wrap tree hierarchy with html list tags
  def tree_list_tags(folder)
    s = ''

    # add edit and delete links next to the current folder
    if folder==@current_folder
      s << '<div class="contextual">'
      s << (link_to_if_authorized(l(:button_edit),
                                   { :controller => 'folders',
                                     :action => 'edit',
                                     :id => folder,
                                     :project_id => @project },
                                   :class => 'icon icon-edit',
                                   :accesskey => accesskey(:edit)) || '')
      s << (link_to_if_authorized(l(:button_delete),
                                   { :controller => 'folders',
                                     :action => 'destroy',
                                     :id => folder,
                                     :project_id => @project },
                                   :confirm => l(:text_are_you_sure),
                                   :method => :post,
                                   :class => 'icon icon-del') || '') unless folder.root?
      s << '</div>'
    end

    s << "<li><span class='folder#{folder==@current_folder ? ' current' : nil}'>"
    s << link_to(h(folder.title), { :controller => 'documents',
                                    :action => 'index',
                                    :folder_id => folder,
                                    :project_id => @project},
                                    {:title => "#{folder.description}"})
    s << "</span>"

    unless folder.leaf?
      s << "\n<ul>\n"
      s << folder.children.map{ |child| tree_list_tags(child) }.to_s
      s << "\n</ul>\n"
    end

    s << "</li>\n"
  end
end
