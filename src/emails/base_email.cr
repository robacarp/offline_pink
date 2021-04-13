abstract class BaseEmail < Carbon::Email
  macro inherited
    from default_from
  end

  def default_from
    Carbon::Address.new("no-reply@app.offline.pink")
  end
end
