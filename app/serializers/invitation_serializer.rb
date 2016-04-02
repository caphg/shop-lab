class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :project_name, :user_email, :created_at

  def project_name
    Project.find(object.project_id).name
  end

  def user_email
    User.find(object.host_id).email
  end
end