json.partial! 'api/v1/creators/creator', creator: @creator
json.families do
  json.array! @creator_families do |family|
    json.user_id family.user.id
    json.user_name family.user.name
    json.relation family.relation.value
    json.remove_family_permission family.remove_family_permission_check(@family)
  end
end
