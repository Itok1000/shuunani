require "test_helper"

class StaticPagesTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  test "top page shows the OGP image and diagnostic link" do
    visit root_path

    assert_selector "img[alt='就なに診断のネオンカラーのOGP画像']"
    click_on "診断スタート"

    assert_current_path new_post_path
  end
end
