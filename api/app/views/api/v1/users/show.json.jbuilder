json.partial! 'api/v1/users/user', user: @user
json.extract! @user, :image
