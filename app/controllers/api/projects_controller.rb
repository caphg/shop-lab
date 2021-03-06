class Api::ProjectsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: current_user.projects.map { |project| ProjectSerializer.new(project, root: false) }.to_json
  end

  def create
    new_project = Project.new new_project_params
    new_project.users << current_user

    if new_project.save
      render json: ProjectSerializer.new(new_project, root: false)
    else
      render json: { errors: new_project.errors }
    end
  end

  def update
    if project.update_attributes(update_project_params)
      render json: ProjectSerializer.new(project, root: false)
    else
      render json: { errors: project.errors }
    end
  end

  def destroy
    if project.destroy
      render json: {}
    else
      render json: {errors: project.errors}
    end
  end

  private

  def project
    Project.includes(:users).where(projects: {id: params[:id]}, users: {id: current_user.id}).first or raise Exception.new("Project not found")
  end

  def new_project_params
    params.permit(
      :name
    )
  end

  def update_project_params
    params.permit(:name)
  end
end
