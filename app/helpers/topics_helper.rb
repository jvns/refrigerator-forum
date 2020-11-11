module TopicsHelper
  def post_box(post)
    words = JSON.parse(post.text)
    min_h = words.map {|x| x['top']}.min
    words = words.map{|w| {
      top: w['top'] - min_h,
      left: w['left'],
      text: w['text'],
    }}

    max_h = words.map {|x| x[:top]}.max
    height = [max_h + 30, 300].min
    {
      height: height,
      words: words,
    }
  end
end
