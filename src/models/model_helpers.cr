module ModelHelpers
  def find!(id)
    if model = find id
      model
    else
      raise "Record Not Found"
    end
  end
end
