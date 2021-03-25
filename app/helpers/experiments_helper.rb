module ExperimentsHelper
  def multiples_enabled?
    # As part of a simple rollout of multiples to the live site
    # we are just returning true, so that the multiples journey can be enabled
    # without changing the rest of the logic
    # This is to simplify a rollback
    # TODO: remove feature flag and all logic once we are ready.
    # cookies[:multiples_enabled].present?
    true
  end
end
