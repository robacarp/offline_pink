module ClassList
  def class_list(*args) : String
    args.to_a.map do |arg|
      case arg
      when Array
        arg.map {|a| class_list a}
      when String
        arg
      end
    end.flatten.join ' '
  end
end
