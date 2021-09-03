json.success true
json.data do
  json.array! @user_works, partial: 'api/v1/works/work', as: :work
end
