class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :items, dependent: :destroy

  validates :name, presence: true

end
