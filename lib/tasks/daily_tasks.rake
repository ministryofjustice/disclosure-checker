desc "run daily tasks"
task daily_tasks: :environment do
  log "Starting daily tasks"
  log "Checks count: #{DisclosureReport.count}"

  Rake::Task["purge:checks"].invoke

  log "Checks count: #{DisclosureReport.count}"
  log "Finished daily tasks"
end

namespace :purge do
  desc "purge checks"
  task checks: :environment do
    # incomplete checks
    expire_after = Rails.configuration.x.checks.incomplete_purge_after_days
    log "Purging incomplete checks older than #{expire_after} days"
    purged = DisclosureReport.in_progress.purge!(expire_after.days.ago)
    log "Purged #{purged.size} incomplete checks"

    # complete checks
    expire_after = Rails.configuration.x.checks.complete_purge_after_days
    log "Purging complete checks older than #{expire_after} days"
    purged = DisclosureReport.completed.purge!(expire_after.days.ago)
    log "Purged #{purged.size} complete checks"
  end
end

private

def log(message)
  puts "[#{Time.zone.now}] #{message}"
end
