Fabricator(:project) do
  name { Faker::Name.name }
  user { Fabricate(:user) }
end
