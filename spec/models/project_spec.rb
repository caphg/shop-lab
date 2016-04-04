require 'rails_helper'

RSpec.describe Project, type: :model do
    context "with project" do
        it "creates project with name" do
            project = Project.create!(name: 'test_project')
            expect(Project.all.count).to eq(1)
        end
    end
end
