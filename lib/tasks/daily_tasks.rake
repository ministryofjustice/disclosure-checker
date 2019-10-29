task daily_tasks: :environment do
  log 'Starting daily tasks'

  #TODO remove once all checks without a check group have been deleted.
  log "Check count: #{DisclosureCheck.where(check_group_id: nil).count }"

  log "Reports count: #{DisclosureReport.count}"

  Rake::Task['purge:checks'].invoke

  #TODO remove once all checks without a check group have been deleted.
  log "Checks count: #{DisclosureCheck.where(check_group_id: nil).count }"

  log "Reports count: #{DisclosureReport.count}"
  log 'Finished daily tasks'
end

namespace :purge do
  task checks: :environment do

    expire_after = Rails.configuration.x.checks.incomplete_purge_after_days

    #TODO remove once all checks without a check group have been deleted.
    # incomplete disclosure checks
    log "Purging incomplete checks without a check group id older than #{expire_after} days"

    byebug
    purged = DisclosureCheck.in_progress.purge!(expire_after.days.ago)
    log "Purged #{purged.size} incomplete checks"

    # incomplete disclosure Reports
    log "Purging incomplete checks older than #{expire_after} days"
    purged = DisclosureReport.in_progress.purge!(expire_after.days.ago)
    log "Purged #{purged.size} incomplete reports"

    #TODO remove once all checks without a check group have been deleted.
    # complete disclosure checks
    expire_after = Rails.configuration.x.checks.complete_purge_after_days
    log "Purging complete checks older than #{expire_after} days"
    purged = DisclosureCheck.completed.purge!(expire_after.days.ago)
    log "Purged #{purged.size} complete checks"

    # complete disclosure Reports
    expire_after = Rails.configuration.x.checks.complete_purge_after_days
    log "Purging complete checks older than #{expire_after} days"
    purged = DisclosureReport.completed.purge!(expire_after.days.ago)
    log "Purged #{purged.size} complete reports"
  end
end

private

def log(message)
  puts "[#{Time.now}] #{message}"
end
