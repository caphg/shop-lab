require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Api::ProjectsController, type: :controller do
    context 'projects' do
        let(:project) { Fabricate(:project) }
        let(:user) {project.users.first }
        @headers = {}

        before(:each) do
            result = post '/auth/sign_in', {'email' => user.email, 'password' => user.password}
            @headers = result.original_headers
        end

        describe 'GET all projects' do
          it 'returns all projects for user' do
            expect(user.projects).to eq([project])
            api_get '/projects', @headers
            expect(response.status).to eq(200)
            expect(json_resp).to eq(
                [
                    {
                        "id"=>project.id,
                        "name"=>project.name,
                        "created_at"=>parse_json_date(project.created_at) ,
                        "users"=>
                        [
                            {
                                "id"=>user.id,
                                "provider"=>"email",
                                "uid"=>user.uid,
                                "name"=>user.name,
                                "nickname"=>user.nickname,
                                "image"=>user.image,
                                "email"=>user.email,
                                "created_at"=> parse_json_date(user.created_at),
                                "updated_at"=> json_resp[0]["users"][0]["updated_at"]
                            }
                        ]
                    }
                ]
            )
          end
        end
    end
end