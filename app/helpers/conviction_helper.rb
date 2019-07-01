module ConvictionHelper
  def conviction_title_string(object)
    return t('conviction_title.never', scope: 'results/conviction') unless object.instance_of?(Date)

    statement_type = object < Date.today ? 'past' : 'present'
    statement = t("conviction_title.#{statement_type}", scope: 'results/conviction')

    "#{statement} #{I18n.l(object)}"
  end

  def conviction_statement_string(object)
    return t('conviction_statement.never', scope: 'results/conviction') unless object.instance_of?(Date)

    statement_type = object < Date.today ? 'past_html' : 'present_html'
    t("conviction_statement.#{statement_type}", scope: 'results/conviction')
  end
end
