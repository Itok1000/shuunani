class ImagesController < ApplicationController
  def ogp
    # URLパラメータから id (例: "shuu_nani", "kita_chan") または text を受け取る
    result_type = params[:text] || params[:id]

    title, text = fetch_ogp_text(result_type)

    # MiniMagickで合成した画像バイナリを取得
    # ※ MiniMagick::Imageオブジェクトから直接 to_blob を呼ぶとシンプルです
    image_binary = OgpCreator.build(title, text).to_blob

    # 画像としてレスポンスを返す
    send_data image_binary, type: 'image/png', disposition: 'inline'
  end

  private

  def fetch_ogp_text(result_type)
    case result_type
    when "nioi_nani"
      ["あなたは「臭なに」です", "就なに要素に加え圧倒的な不潔スペック。今すぐお風呂へ！"]
    when "shuu_nani"
      ["あなたは「就なに」です", "高すぎるプライドと情緒不安定の見事なフルスペック。"]
    when "bocchi"
      ["「ぼっちちゃん」の可能性", "対人は苦手だけど不潔でも攻撃的でもありません。"]
    when "kita_chan"
      ["あなたは「喜多ちゃん」です！", "圧倒的陽キャ！衛生面もメンタルも良好です。"]
    when "normal"
      ["特に異常は有りませんでした", "至って標準的な人間です。安心して社会生活を。"]
    else
      # パラメータに直接「おはよう」などが来た場合のデフォルト表示
      ["就なに診断結果", result_type.presence || "あなたは…"]
    end
  end
end
