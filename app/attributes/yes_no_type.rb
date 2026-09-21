class YesNoType < ActiveModel::Type::Value
  def cast(value)
    case value
    when String, Symbol
      GenericYesNo.new(value)
    when GenericYesNo
      value
    end
  end
end
