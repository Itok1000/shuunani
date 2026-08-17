# app/controllers/concerns/ogp_creator.rb
require 'mini_magick'

class OgpCreator
  # 画面のサイズ定義（X/TwitterのOGP推奨サイズ 1200x630）
  BASE_IMAGE_PATH = Rails.root.join('app/assets/images/ogp_bg.png')
  FONT_PATH = Rails.root.join('app/assets/fonts/DotGothic16-Regular.ttf') # 配置したフォント

  def self.build(result_title, result_text)
    # ベース画像を読み込み
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)

    image.combine_options do |config|
      # フォントと文字色の設定
      config.font FONT_PATH.to_s
      config.fill '#FFFFFF' # 文字色（白）
      config.gravity 'Center' # 中央揃え

      # 1. 診断結果タイトル（「あなたは『臭なに』です」など）の刻印
      config.pointsize '55'
      # 少し上に配置 (x=0, y=-60)
      config.draw "text 0,-60 '#{escape_text(result_title)}'"

      # 2. 補足テキスト/説明文の刻印
      config.pointsize '28'
      config.fill '#E0E0E0' # 少し薄い文字色
      # 少し下に配置 (x=0, y=+60)
      # ※長すぎる文字列は改行を入れておくと綺麗に収まります
      config.draw "text 0,60 '#{escape_text(insert_newlines(result_text, 20))}'"
    end

    # 合成後の画像を一時ファイル（またはバイナリ）として出力
    image
  end

  private

  # シングルクォートなどのエスケープ処理
  def self.escape_text(text)
    text.to_s.gsub("'", "\\\\'")
  end

  # 一定文字数で改行を入れる補助メソッド（折り返し対応）
  def self.insert_newlines(text, line_length = 20)
    text.to_s.scan(/.{1,#{line_length}}/).join("\n")
  end
end