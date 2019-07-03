module ResultHelper
  def title_string(object, kind)
    return t('title.no_date', scope: "results/#{kind}") unless object.instance_of?(Date)

    title_type = object < Date.today ? 'past' : 'present'
    t("title.#{title_type}", scope: "results/#{kind}", date: I18n.l(object))
  end

  def statement_string(object, kind)
    return t('statement.no_date', scope: "results/#{kind}") unless object.instance_of?(Date)

    statement_type = object < Date.today ? 'past_html' : 'present_html'
    t("statement.#{statement_type}", scope: "results/#{kind}")
  end
end
