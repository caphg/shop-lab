Fabricator(:project) do
  name { Faker::Name.name }
  users(count: 1)
end
