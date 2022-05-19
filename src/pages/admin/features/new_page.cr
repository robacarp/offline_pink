class Admin::Features::NewPage < AuthLayout
  needs save : SaveFeature

  def content
    small_frame do
      header_and_links "Create a new Feature Flag"

      shrink_to_fit do
        form_for Admin::Features::Create do
          mount Shared::Field, attribute: save.name, label_text: "Feature Name", &.text_input(autofocus: true)
          submit "Create"
        end
      end
    end
  end
end
