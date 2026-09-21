Rails.application.config.to_prepare do
  ActiveModel::Type.register(:multi_param_date, MultiParamDateType)
  ActiveModel::Type.register(:yes_no, YesNoType)
end
