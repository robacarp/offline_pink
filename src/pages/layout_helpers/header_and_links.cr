module HeaderAndLinks
  def middot_sep
    raw "&nbsp;&middot;&nbsp;"
  end

  def page_header(header_text : String)
    h3 header_text, class: "mb-0"
  end

  def page_header(header_text : Array(String))
    h3 class: "mb-0" do
      first = true
      header_text.each do |text_component|
        middot_sep unless first
        first = false
        text text_component
      end
    end
  end

  def header_and_links
    div class: "md:flex md:justify-between md:items-end" do
      yield
    end

    hr class: "my-4"
  end

  def header_and_links(header_text : String | Array(String))
    header_and_links do
      page_header header_text

      div do
        yield
      end
    end
  end

  def header_and_links(header_text : String | Array(String))
    header_and_links do
      page_header header_text
    end
  end
end
