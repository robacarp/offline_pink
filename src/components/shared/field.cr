class Shared::Field(T) < BaseComponent
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?
  needs button : NamedTuple(text: String)?

  def render
    classes = %w|field mb-4|
    unless attribute.valid?
      classes << "text-red-500"
    end

    div class: classes.join(' ') do
      label_for attribute, label_text, class: "block text-sm font-bold mb-2"

      tag_classes = %w|shadow appearance-none border rounded py-2 px-3 text-gray-700 mb-3 leading-tight|
      tag_classes << "border-red-500" unless attribute.valid?

      tag_defaults field: attribute, class: class_list(tag_classes) do |input_builder|
        yield input_builder
      end

      render_button
      mount Shared::FieldErrors, attribute
    end
  end

  def render_button
    return unless config = button
    submit config[:text], class: "ml-2"
  end
end
