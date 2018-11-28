require 'test_helper'

class DecksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decks_index_url
    assert_response :success
  end

  test "should get new" do
    get decks_new_url
    assert_response :success
  end

  test "should get show" do
    get decks_show_url
    assert_response :success
  end

  test "should get edit" do
    get decks_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get decks_destroy_url
    assert_response :success
  end

end
