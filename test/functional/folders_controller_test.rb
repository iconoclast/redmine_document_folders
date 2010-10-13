require File.dirname(__FILE__) + '/../test_helper'
require 'folders_controller'

class FoldersControllerTest < ActionController::TestCase
  fixtures :folders

  ## We're not using these directly.  To see folders, use the documents view.
  #test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:folders)
  #end
  #
  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  test "should create folder" do
    project = Project.find 1
    assert_difference('Folder.count') do
      post :create, :folder => {:title => 'new folder'}, :project_id => project
    end

    assert assigns(:folder)
    assert_redirected_to({ :controller => 'documents', :action => 'index',
                           :project_id => project, :folder_id => assigns(:folder).id})
  end

  test "should show folder" do
    get :show, :id => folders(:folders_001).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => folders(:folders_001).to_param
    assert_response :success
  end

  test "should update folder" do
    put :update, :id => folders(:folders_001).to_param, :folder => { }

    assert assigns(:folder)
    assert_redirected_to ({ :controller => 'documents', :action => 'index',
                            :folder_id => 1, :project_id => folders(:folders_002).project })
  end

  test "should destroy folder" do
    assert_difference('Folder.count', -1) do
      delete :destroy, :id => folders(:folders_003).to_param
    end
    
    assert_redirected_to ({ :controller => 'documents', :action => 'index',
                            :project_id => folders(:folders_002).project })
  end

  test "should destroy folder recursively" do
    child_id = folders(:folders_002).children.first.id
    delete :destroy, :id => folders(:folders_002).to_param

    assert_nil Folder.find_by_id(child_id)
  end

## not fully implemented yet  
#  test "should destroy folder preserving contents" do
#    child_id = folders(:folders_002).children.first.id
#    assert_difference 'Folder.count', -1 do
#      delete :destroy, :id => folders(:folders_002).to_param,
#             :reassign_to => folders(:folders_002).parent
#    end
#
#    assert_not_nil Folder.find_by_id(child_id)    
#  end

end
