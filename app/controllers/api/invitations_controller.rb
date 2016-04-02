class Api::InvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    invitation = Invitation.where(invitee_id: current_user.id).first
    render json: InvitationSerializer.new(invitation, root: false).to_json
  end

  def create
    project = Project.includes(:users).where(projects: {id: params[:project_id]}, users: {id: current_user.id}).first  or raise Exception.new("Project not found")
    user = User.where(email: params[:email]).first or raise Exception.new("User not found")
    invitation = Invitation.first_or_create(
      project: project,
      host_id: current_user.id,
      invitee_id: user.id
    )
    if invitation.save
      render json: {}
    else
      render json: {errors: project.errors}
    end
  end

  def accept
    invitation = Invitation.find(params[:id])
    return render json: {}, :status => 403 unless invitation.invitee_id == current_user.id
    project = invitation.project
    return render json: {}, :status => 400 if User.includes(:projects).where(users: {id: current_user.id}, projects: {id: project.id}).count > 0
    current_user.projects << project
    invitation.destroy!
    render json: {}
  end

  def decline
    invitation = Invitation.find(params[:id])
    return render json: {}, :status => 403 unless invitation.invitee_id == current_user.id
    project = invitation.project
    invitation.destroy!
    render json: {}
  end
end