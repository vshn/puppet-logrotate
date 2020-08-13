# logrotate config
class logrotate::config {
  assert_private()

  file { $logrotate::rules_configdir:
    ensure  => directory,
    owner   => $logrotate::root_user,
    group   => $logrotate::root_group,
    purge   => $logrotate::purge_configdir,
    recurse => $logrotate::purge_configdir,
    mode    => $logrotate::rules_configdir_mode,
  }

  if $logrotate::manage_cron_daily {
    logrotate::cron { 'daily':
      ensure => $logrotate::ensure_cron_daily,
    }
  }

  if $logrotate::config {
    logrotate::conf { $logrotate::logrotate_conf:
      * => $logrotate::config,
    }
  }
}
