require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)

  test 'can generate display name' do
    u = users(:mark)
    assert_equal "#{u.first_name.capitalize} #{u.last_name[0].upcase}.", u.displayName
  end

  test 'can generate full name' do
    u = users(:nancy)
    assert_equal "#{u.first_name.capitalize} #{u.last_name.capitalize}", u.fullname
  end

  test 'can generate token' do
    u = users(:mark)
    assert_equal Digest::SHA1.hexdigest("#{u.id}"), u.token
  end

  test 'should only contains games that belong to user' do
    u = users(:mark)
    assert u.games.all? {|g| g.player1 == u or g.player2 == u }
  end

  test 'should respond to hosted games' do
    u = users(:karen)
    assert_respond_to u, :hosted_games
    assert u.hosted_games.all? {|g| g.player1 == u }
  end

  test 'should respond to joined games' do
    u = users(:karen)
    assert_respond_to u, :joined_games
    assert u.joined_games.all? {|g| g.player2 == u }
  end

end
