Given(/^I am signed in as (.*)$/) do |name|
  if name == "an instructor"
    user = Fabricate(:instructor)
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "a student in that course"
    user = Fabricate(:student)
    @course.users << user
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "a student"
    user = Fabricate(:student)
    sign_into_github_as(user.github_username, user.github_uid)
  else
    user = User.where(name: name).first
    sign_into_github_as(user.github_username, user.github_uid)
  end
  visit '/users/auth/github'
  @user = User.find_by_github_username(user.github_username)
end

Given(/^I am signed in to Github as "(.*?)"$/) do |username|
  sign_into_github_as(username)

end

Given(/^I have a photo$/) do
  @user.avatar_url = "www.path.to/image.jpg"
  @user.save
end

Given(/^my photo is confirmed$/) do
  @user.avatar_confirmed = true
  @user.save
end

def sign_into_github_as(username, uid = nil)
  if uid.nil?
    user = User.find_by_github_username(username)
    uid = user.try(:github_uid) || '12345'
  end
  OmniAuth.config.add_mock(:github, {
    uid: uid,
    credentials: {
      token: "d141ef15f79ca4c6f43a8c688e0434648f277f20",
    },
    info: {
      nickname: username,
      email: "#{username}smith@example.com",
      name: "#{username.capitalize} Smith",
      image: "http://avatars.github.com/#{username}",
    },
    extra: {
      raw_info: {
        location: 'San Francisco',
        gravatar_id: '123456789'
      }
    }
  })
end
