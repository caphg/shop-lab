class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :project, index: true, foreign_key: true
      t.integer :host_id
      t.integer :invitee_id

      t.timestamps null: false
    end
  end
end
