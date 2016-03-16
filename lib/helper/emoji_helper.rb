require_relative './emoji_regex'

module RailsEmojiPicker
  def content_with_emoji(body)
    post = find_emoji(body)
    emojify(post, 'emoji-show')
  end

  private

  def emojify(content, css_class = 'emoji')
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias(Regexp.last_match(1))
        %(<img alt="#{Regexp.last_match(1)}" src="#{image_path("emoji/#{emoji.image_filename}")}" class="#{css_class}"/>)
      else
        match
      end
    end.html_safe if content.present?
  end

  def find_emoji(text)
    chars = text.split('')
    chars.each do |c|
      emoji     = c.scan(regex).join('')
      emoji_obj = Emoji.find_by_unicode(emoji) if emoji.present?
      c.gsub!(regex, emoji_name(emoji_obj.name)) if emoji_obj.present?
    end
    chars.join('')
  end

  def emoji_name(emoji)
    ":#{emoji}:"
  end

  def regex
    RailsEmojiPicker::EmojiRegex.regex
  end
end
