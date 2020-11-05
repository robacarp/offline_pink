abstract class GuestLayout < AuthLayout
  needs current_user : User?

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title, context: context

      body do
        mount Shared::FlashMessages, context.flash
        content
      end
    end
  end
end
