require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Api::InvitationsController, type: :controller do
    context 'ok invitation' do
        let(:project) { Fabricate(:project) }
        let(:user) { Fabricate(:user) }
        let(:second_user) { Fabricate(:user) }
        let!(:invitation) { Fabricate(:invitation, project: project, host_id: second_user.id, invitee_id: user.id) }
        @headers = {}

        before(:each) do
            result = post '/auth/sign_in', {'email' => user.email, 'password' => user.password}
            @headers = result.original_headers
        end

        describe 'GET' do
          it 'fetches invitations' do
            api_get '/invitations', @headers
            expect(response.status).to eq(200)
            expect(json_resp).to eq(
                    {
                        "id"=>invitation.id,
                        "project_id" => project.id,
                        "project_name" => project.name,
                        "user_email" => second_user.email,
                        "created_at" => parse_json_date(invitation.created_at)
                    }
            )
          end
        end

        describe 'POST' do
            it 'accepts invitation' do
                api_post '/invitations/accept', @headers.merge({id: invitation.id})
                expect(response.status).to eq(200)
                expect(user.projects).to include(project)
            end

            it 'declines invitation' do
                api_post '/invitations/decline', @headers.merge({id: invitation.id})
                expect(response.status).to eq(200)
                expect(user.projects).to_not include(project)
                expect(Invitation.count).to eq(0)
            end
        end
    end

    context 'invitation error' do
        let(:project) { Fabricate(:project) }
        let(:user) { Fabricate(:user) }
        let(:second_user) { Fabricate(:user) }
        let!(:invitation) { Fabricate(:invitation, project: project, host_id: second_user.id, invitee_id: user.id) }
        @headers = {}

        before(:each) do
            result = post '/auth/sign_in', {'email' => second_user.email, 'password' => second_user.password}
            @headers = result.original_headers
        end

        describe 'POST' do
            it 'raises error on accepts invitation' do
                api_post '/invitations/accept', @headers.merge({id: invitation.id})
                expect(response.status).to eq(403)
                expect(user.projects).to_not include(project)
            end

            it 'raises error on declines invitation' do
                api_post '/invitations/decline', @headers.merge({id: invitation.id})
                expect(response.status).to eq(403)
                expect(Invitation.count).to eq(1)
            end
        end
    end
end