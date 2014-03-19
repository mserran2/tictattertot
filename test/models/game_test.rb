require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should generate display name' do
    g = games(:one)
    assert_equal "#{g.player1.displayName} vs. #{g.player2.displayName}", g.displayName
  end

  test 'should return color as binary value' do
    assert
  end
end
