# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def new
    # 診断フォーム表示
  end

  def create
    # 送信された回答（q1〜q10）の合計と衛生スコアを計算
    answers = params[:answers] || {}
    total_score = answers.values.map(&:to_i).sum
    hygiene_score = (1..3).sum { |i| answers["q#{i}"].to_i }

    # 判定ロジック
    result_type = calculate_result(total_score, hygiene_score)

    # 本来はDB保存ですが、仮にセッションやURLパラメータで結果画面へ引き継ぐ例
    redirect_to post_path(result_type)
  end

  def show
    @result_type = params[:id] # 例: "shuu_nani", "kita_chan" など

    set_meta_tags description: "わたしは「 #{@result_type} 」です",
                  og: {
                    title: '診断結果',
                    description: "わたしは「 #{@result_type} 」です",
                    image: ogp_image_url(@result_type), # 動的に生成されたOGP画像のURL
                    url: request.original_url
                  },
                  twitter: {
                    card: 'summary_large_image',
                    image: ogp_image_url(@result_type)
                  }
  end

  private

  def ogp_image_url(result_type)
    images_ogp_url(text: result_type, host: request.host_with_port)
  end

  def calculate_result(total, hygiene)
    if total >= 40
      hygiene >= 12 ? "nioi_nani" : "shuu_nani"
    elsif total >= 25
      "normal"
    elsif total >= 15
      "bocchi"
    else
      "kita_chan"
    end
  end
end
