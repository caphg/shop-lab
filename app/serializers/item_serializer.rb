class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :done, :created_at, :owner

  def owner
    User.where(id: object.owner_id).try(:first).try(:email) or "Anonymous"
  end
end