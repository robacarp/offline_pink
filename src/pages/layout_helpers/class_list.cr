module ClassList
  def class_list(*args) : String
    args.map do |arg|
      case arg
      when Array
        class_list *arg
      when String
        arg
      end
    end.join ' '
  end
end
