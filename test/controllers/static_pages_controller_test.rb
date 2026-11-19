require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "top page shows the OGP image and diagnostic link" do
    get root_url

    assert_response :success
    assert_select "img[alt='就なに診断のネオンカラーのOGP画像']"
    assert_select "a[href='#{new_post_path}'] span", text: "診断スタート"
    assert_select "a[href='#{terms_path}']", text: "利用規約"
    assert_select "a[href='#{privacy_path}']", text: "プライバシーポリシー"
  end

  test "legal pages use the site theme and display their content" do
    get terms_url

    assert_response :success
    assert_select "main[class*='bg-[#0a0a0c]']"
    assert_select "h1", text: "利用規約"
    assert_select "p", text: /本規約/

    get privacy_url

    assert_response :success
    assert_select "main[class*='bg-[#0a0a0c]']"
    assert_select "h1", text: "プライバシーポリシー"
    assert_select "h2", text: "お客様から取得する情報"
  end
end
