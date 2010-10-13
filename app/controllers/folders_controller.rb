class FoldersController < ApplicationController
  model_object  Folder
  before_filter :find_model_object, :except => [:index, :new, :create]
  before_filter :find_project, :only => [:index, :new, :create]
  before_filter :find_project_from_association, :except => [:index, :new, :create] 
  
  # GET /folders
  # GET /folders.xml
  def index
    @folders = Folder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @folders }
    end
  end

  # GET /folders/1
  # GET /folders/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    @folder = Folder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/1/edit
  def edit
    @current_folder = @folder
  end

  # POST /folders
  # POST /folders.xml
  def create
    @folder = Folder.new(params[:folder])
    @folder.project = @project

    respond_to do |format|
      if @folder.save
        flash[:notice] = 'Folder was successfully created.'
        format.html { redirect_to(:controller => 'documents', :action => 'index', :project_id => @project, :folder_id => @folder.id) }
        format.xml  { render :xml => @folder, :status => :created, :location => @folder }
      else
        flash[:error] = "Errors encountered while attempting to create folder."
        format.html { redirect_to(:controller => 'documents', :action => 'index', :project_id => @project, :folder_id => @folder.id) }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /folders/1
  # PUT /folders/1.xml
  def update
    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        flash[:notice] = 'Folder was successfully updated.'
        format.html { redirect_to(:controller => 'documents', :action => 'index',
                                  :project_id => @folder.project, :folder_id => @folder.id) }
        format.xml  { head :ok }
      else
        flash[:error] = "Errors encountered while attempting to update folder."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.xml
  def destroy
    @folder.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => 'documents', :action => 'index',
                                :project_id => @folder.project) }
      format.xml  { head :ok }
    end
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
