class Api::ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: project.items.map { |item| ItemSerializer.new(item, root: false) }.to_json
  end

  def create
    new_item = Item.new new_item_params
    new_item.project = project
    new_item.owner_id = current_user.id

    if new_item.save
      render json: ItemSerializer.new(new_item, root: false)
    else
      render json: { errors: new_item.errors }
    end
  end

  def update
    if item.update_attributes(update_item_params)
      render json: ItemSerializer.new(item, root: false)
    else
      render json: { errors: item.errors }
    end
  end

  private

  def item
    Item.find(params[:id]) or raise Exception.new("Item not found")
  end

  def project
    Project.includes(:users).where(projects: {id: params[:project_id]}, users: {id: current_user.id}).first or raise Exception.new("Project not found")
  end

  def new_item_params
    params.permit(
      :name
    )
  end

  def update_item_params
    params.permit(:name, :done)
  end
end
