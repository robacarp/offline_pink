class Shared::OwnershipDropdown(T) < BaseComponent
  include Lucky::CatchUnpermittedAttribute

  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String = "Owner"
  needs possible_owners : Array(NamedValue)

  def render
    classes = ["field"]
    unless attribute.valid?
      classes << "error"
    end

    div class: classes.join(' ') do
      label_for attribute, label_text

      select_input attribute do
        options_for_select(
          attribute,
          possible_owners.map(&.to_tuple)
        )
      end

      mount Shared::FieldErrors, attribute
    end
  end
end
