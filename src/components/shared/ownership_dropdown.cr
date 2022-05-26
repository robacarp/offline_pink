class Shared::OwnershipDropdown(T) < BaseComponent
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String = "Owner"
  needs possible_owners : Array(NamedValue)

  def render
    classes = ["mb-4"]
    unless attribute.valid?
      classes << "error"
    end

    div class: classes.join(' ') do
      label_for attribute, label_text, class: "block text-sm font-bold mb-2"

      select_input attribute, class: "shadow appearance-none border rounded py-2 px-3 text-gray-700 mb-3 leading-tight" do
        options_for_select(
          attribute,
          possible_owners.map(&.to_tuple)
        )
      end

      mount Shared::FieldErrors, attribute
    end
  end
end
