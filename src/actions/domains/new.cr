class Domains::New < BrowserAction
  get "/my/domains/new" do
    authorize_operation(->SaveDomain.new) do |authorized_operation|
      html NewPage, save: authorized_operation
    end
  end
end
