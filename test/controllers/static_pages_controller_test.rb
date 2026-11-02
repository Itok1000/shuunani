require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "top page shows the OGP image and diagnostic link" do
    get root_url

    assert_response :success
    assert_select "img[alt='就なに診断のネオンカラーのOGP画像']"
    assert_select "a[href='#{new_post_path}'] span", text: "診断スタート"
  end
end
