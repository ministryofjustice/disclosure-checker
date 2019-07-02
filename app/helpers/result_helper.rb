module ResultHelper
  def title_string(object, kind)
    invalid_date = kind == 'conviction' ? 'never' : 'caution_result'
    return t("#{kind}_title.#{invalid_date}", scope: "results/#{kind}") unless object.instance_of?(Date)

    title_type = object < Date.today ? 'past' : 'present'
    t("#{kind}_title.#{title_type}", scope: "results/#{kind}", date: I18n.l(object))
  end

  def statement_string(object, kind)
    invalid_date = kind == 'conviction' ? 'never' : 'caution_result_html'
    return t("#{kind}_statement.#{invalid_date}", scope: "results/#{kind}") unless object.instance_of?(Date)

    statement_type = object < Date.today ? 'past_html' : 'present_html'
    t("#{kind}_statement.#{statement_type}", scope: "results/#{kind}")
  end
end
