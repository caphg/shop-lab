require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Api::InvitationsController, type: :controller do
    context 'projects' do
        let(:project) { Fabricate(:project) }
        let(:user) {project.users.first }
        let(:second_user) {Fabricate(:user) }
        @headers = {}

        before(:each) do
            result = post '/auth/sign_in', {'email' => user.email, 'password' => user.password}
            @headers = result.original_headers
        end

        describe 'GET all projects' do
          it 'creates invitation' do
            # TODO
          end
        end
    end
end