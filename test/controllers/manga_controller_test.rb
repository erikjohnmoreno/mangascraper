require 'test_helper'

class MangaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manga_index_url
    assert_response :success
  end

end
