require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest

  test 'can login' do
    visit root_url
    click_link 'Login'
    fill_in 'Email', :with => 'csgeek@me.com'
    fill_in 'Password', :with => 'password1'
    click_button 'Sign in'
    assert_equal root_url, current_url
  end

  test 'can sign up' do
    visit root_url
    click_link 'Sign Up'
    fill_in 'First name', :with => 'Test'
    fill_in 'Last name', :with => 'User'
    fill_in 'Email', :with => 'user1@world.com'
    fill_in 'Password', :with => 'mypassword'
    fill_in 'Password confirmation', :with => 'mypassword'
    click_button 'Sign up'
    assert_equal root_url, current_url
  end
end