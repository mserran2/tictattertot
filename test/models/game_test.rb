require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  should validate_presence_of(:player1)
  should validate_presence_of(:grid)
  should validate_presence_of(:state)
  should validate_presence_of(:status)

  test 'should generate display name' do
    g = games(:one)
    assert_equal "#{g.player1.displayName} vs. #{g.player2.displayName}", g.displayName
  end


end
