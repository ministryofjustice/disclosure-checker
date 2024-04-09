class MarkupNormaliser
  attr_reader :markup1, :markup2

  def initialize(markup1, markup2)
    @markup1 = markup1
    @markup2 = markup2

    normalise!
  end

private

  def normalise!
    @markup1 = remove_blank_children(
      Nokogiri::HTML.fragment(markup1),
    ).to_html

    @markup2 = remove_blank_children(
      Nokogiri::HTML.fragment(markup2),
    ).to_html
  end

  def remove_blank_children(element)
    element.children.each do |child|
      if child.children.any?
        remove_blank_children(child)
      elsif child.blank?
        # Remove empty elements, like `#(Text "\n  ")`
        child.remove
      end
    end

    element
  end
end
