
module RedmineDocumentFolders
  module Patches

    module DocumentsControllerPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable          
          before_filter :find_folder, :only => [:index, :new, :show]
          helper :folders

          alias_method_chain :index, :folder_filter
          alias_method_chain :show, :attachment_limit
          alias_method_chain :new, :folder_id
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def find_folder
          folder_id = params[:folder_id]
          folder_id ||= @document.folder_id if @document
          @current_folder = Folder.find_by_id_and_project_id(folder_id, @project.id) if folder_id
          @current_folder ||= Folder.project_root(@project)    
        end

        def index_with_folder_filter
          @flat ||= false
          
          @sort_by = %w(category date title author).include?(params[:sort_by]) ? params[:sort_by] : 'category'
          
          strainer = @flat ? @project : @current_folder
          documents = strainer.documents.find :all, :include => [:attachments, :category]
          
          case @sort_by
          when 'date'
            @grouped = documents.group_by {|d| d.updated_on.to_date }
          when 'title'
            @grouped = documents.group_by {|d| d.title.first.upcase}
          when 'author'
            @grouped = documents.select{|d| d.attachments.any?}.group_by {|d| d.attachments.last.author}
          else
            @grouped = documents.group_by(&:category)
          end
          @folder = @project.folders.build
          @folder.parent_folder = @current_folder
          @document = @project.documents.build :folder => @current_folder
          render :layout => false if request.xhr?
        end

        def show_with_attachment_limit
          @attach_only_one = true 
          show_without_attachment_limit
        end

        def new_with_folder_id
          new_without_folder_id
          if @performed_redirect
            @performed_redirect = false # to avoid the dreaded double-redirect error
            redirect_to :action => 'index', :project_id => @project, :folder_id => @document.folder_id
          end
        end
        
      end

    end
  end
end
