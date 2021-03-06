require 'spec_helper'

feature "User confirms photo", vcr: true do
  # As a user
  # I want others to see an accurate picture of me
  #
  # - Require confirmed picture
  # - Accept URL or uploaded picture

  scenario "Student must confirm their photo" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    visit root_path
    page.should have_content "You must confirm your profile image in order to continue."
    page.should have_content "You must use a photo of your face"
  end

  scenario "Student with confirmed photo doesn't need to confirm" do
    student = Fabricate(:student, github_username: "joe")
    signin_as student
    visit root_path
    page.should_not have_content "You must use a photo of your face"
  end

  scenario "Student confirms photo" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    visit root_path
    check "This is a picture of me."
    click_button "Save Changes"
    page.should have_content "Your profile has been updated."
    visit root_path
    page.should_not have_content "You must use a photo of your face"
  end

  scenario "Student changes photo by url (http)" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    page.find('img.profile_photo')['src'].should =~ /12345.jpeg/
    fill_in "Web address for your photo", with: "http://example.com/image.png"
    click_button "Save Changes"
    page.should have_content "Your profile has been updated."
    visit root_path
    page.find('img.profile_photo')['src'].should =~ /image.png/
  end

  scenario "Student changes photo by url (https)" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    page.find('img.profile_photo')['src'].should =~ /12345.jpeg/
    fill_in "Web address for your photo", with: "https://example.com/image.png"
    click_button "Save Changes"
    page.should have_content "Your profile has been updated."
    visit root_path
    page.find('img.profile_photo')['src'].should =~ /image.png/
  end

  scenario "Student changes photo by upload" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    page.find('img.profile_photo')['src'].should =~ /12345.jpeg/
    attach_file("user_photo", File.join(Rails.root, "/spec/support/files/github.png"))
    click_button "Save Changes"
    page.should have_content "Your profile has been updated."
    visit root_path
    page.find('img.profile_photo')['src'].should =~ /github.png/
  end

  scenario "Student changes photo by upload and url" do
    sign_into_github_as "joe"
    visit root_path
    click_link "Sign In with Github"
    visit root_path
    page.find('img.profile_photo')['src'].should =~ /12345.jpeg/
    attach_file("user_photo", File.join(Rails.root, "/spec/support/files/github.png"))
    fill_in "Web address for your photo", with: "https://example.com/image.png"
    click_button "Save Changes"
    page.should have_content "Your profile has been updated."
    visit root_path
    page.find('img.profile_photo')['src'].should =~ /github.png/
  end
end
