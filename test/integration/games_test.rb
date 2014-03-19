require 'test_helper'

class GamesTest < ActionDispatch::IntegrationTest
  test 'Anyone can view dashboard' do
    visit games_url
    assert_equal games_url, current_url
    has_selector?('#open_games')
    has_no_selector?('#my_games')
  end

  test 'Can view my games when logged in' do
    login_as 'csgeek@me.com', 'password1'
    visit games_url
    has_selector? '#my_games'
  end

  test 'Cannot join game if not logged in' do
    visit join_game_url(games(:five))
    assert_equal new_user_session_url, current_url
  end

  test 'Can join game if logged in' do
    login_as 'csgeek@me.com', 'password1'
    visit join_game_url(games(:five))
    assert_equal edit_game_url(games(:five)), current_url
  end

  test 'Cannot join active game' do
    login_as 'csgeek@me.com', 'password1'
    visit join_game_url(games(:four))
    assert_equal games_url, current_url
  end
end