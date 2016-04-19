Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  confirmed_at { "2016-04-04 12:06:29" }
  confirmation_token { "12345" }
  confirmation_sent_at { "2016-04-04 12:06:13" }
end
