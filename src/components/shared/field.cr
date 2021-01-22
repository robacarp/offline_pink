class Shared::Field(T) < BaseComponent
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?
  needs button : NamedTuple(text: String)?

  def render
    classes = ["field"]
    unless attribute.valid?
      classes << "error"
    end

    div class: classes.join(' ') do
      label_for attribute, label_text

      tag_defaults field: attribute do |input_builder|
        yield input_builder
      end

      render_button
      mount Shared::FieldErrors, attribute
    end
  end

  def render_button
    return unless config = button
    submit config[:text], class: "inline-button"
  end
end
