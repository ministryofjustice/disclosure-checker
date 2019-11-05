module ExperimentsHelper
  def motoring_enabled?
    cookies[:motoring_enabled].present?
  end

  def multiples_enabled?
    cookies[:multiples_enabled].present?
  end
end
