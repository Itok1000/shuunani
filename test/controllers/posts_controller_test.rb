require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "show renders metadata with an OGP image URL for a result type" do
    get post_path("kita_chan")

    assert_response :success
    assert_includes response.body, "images/ogp.png"
  end
end
