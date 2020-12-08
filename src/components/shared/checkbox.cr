class Shared::Checkbox(T) < BaseComponent
  # Raises a helpful error if component receives an unpermitted attribute
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?

  def render
    classes = ["field checkbox"]
    unless attribute.valid?
      classes << "error"
    end

    div class: classes.join(' ') do
      tag_defaults field: attribute do |input_builder|
        yield input_builder
      end

      label_for attribute, label_text

      mount Shared::FieldErrors, attribute
    end
  end
end
