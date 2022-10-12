class Shared::AlertBox < BaseComponent
  enum Severity
    Success
    Failure
    Info
  end

  needs severity : Severity | String | Nil
  needs dismissable : Bool = true
  needs title : String?
  needs classes : String = ""

  def severity : Severity
    severity_ = previous_def

    case severity_
    when Symbol
      Severity.parse severity_.to_s
    when String
      Severity.parse severity_
    when Severity
      severity_
    else
      Severity::Info
    end
  end

  def title : String
    title_ = previous_def

    case title_
    when String
      title_
    else
      severity.to_s
    end
  end

  def render
    # class with-close-button is used to attach the event listener to the close action
    div(
      class: class_list("w-full flex space-x-4 items-start border p-4 mb-4 rounded", style_for_severity(severity), classes),
      data_has_close_button: true,
      flow_id: "flash",
      role: "alert"
    ) do
      div title, class: "font-bold flex-none"

      div class: "flex-1" do
        yield
      end

      if dismissable?
        div class: "flex-none", data_close_button: true do
          tag "svg", role: "button", class: "fill-current h-6 w-6", xmlns: "http://www.w3.org/2000/svg", viewBox:"0 0 20 20" do
            tag "title", "Close"
            tag "path",
              d: <<-SVG
                M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z
              SVG
          end
        end
      end

    end
  end

  private def style_for_severity(severity : Severity)
    case severity
    when Severity::Failure
      "bg-red-100 border-red-400 text-red-700"
    when Severity::Success
      "bg-green-100 border-green-400 text-green-700"
    when Severity::Info
      "bg-blue-100 border-blue-400 text-blue-700"
    else
      ""
    end
  end

  private def flash_close_style(severity)
    case severity
    when Severity::Failure
    when Severity::Success
    when Severity::Info
    end
  end
end

