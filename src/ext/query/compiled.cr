class Query::Compiled(T)
  getter table
  getter where
  getter limit
  getter order

  getter data

  @table : String
  @primary_key : String

  def initialize(@builder : Builder(T))
    @primary_key = builder.model.primary_name
    @table = builder.model.table_name
    @where = ""
    @limit = ""
    @order = ""
    @data  = [] of Builder::FieldData
    @fields = [] of Builder::FieldName

    build_where
    build_limit
    build_order
  end

  private def build_where
    parameter_count = 0
    @where, fields, data = @builder.build_where(0)
    parameter_count += data.size
    @fields += fields
    @data += data

    # Something like a visitor...
    # builder = @builder
    # while builder.next_clause?
    #   @where, fields = builder.next_clause
    #   @data += fields
    #   if builder.next_clause?
    #     builder = builder.next_clause
    #   else
    #     break
    #   end
    # end
  end

  def field_list
    [@primary_key, @fields].flatten.join ", "
  end

  def where?
    ! @where.blank?
  end

  private def build_limit
  end

  def limit?
    ! @limit.blank?
  end

  private def build_order
  end

  def order?
    ! @order.blank?
  end

  def where
    if where?
      @where
    else
      "true"
    end
  end
end
