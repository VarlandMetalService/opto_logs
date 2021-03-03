module OptoHelper

  def format_for_email(text)
    substitutions = [["<code>", "<code style=\"color: #e83e8c !important; font-family: SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace !important; font-size: 0.875rem !important; font-weight: 700 !important;\">"]]
    substitutions.each do |sub|
      text.gsub!(sub[0], sub[1])
    end
    return text
  end

  def format_for_plain_text(text)
    substitutions = [["<br>", "\n"],
                     ["<br />", "\n"]]
    substitutions.each do |sub|
      text.gsub!(sub[0], sub[1])
    end
    return strip_tags(text)
  end

end