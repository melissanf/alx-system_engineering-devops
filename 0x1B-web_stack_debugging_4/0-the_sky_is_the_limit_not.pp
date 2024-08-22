# Increases the amount of traffic an Nginx server can handle.

# Increase the ULIMIT of the default file
exec { 'increase-ulimit':
  command => 'sed -i "s/15/4096/" /etc/default/nginx',
  path    => ['/bin', '/usr/bin'], # Correct paths for sed
  unless  => 'grep -q "4096" /etc/default/nginx', # Avoid unnecessary changes
}

# Ensure system-wide file descriptor limits are increased
file { '/etc/security/limits.conf':
  ensure  => file,
  content => "nginx soft nofile 4096\nnginx hard nofile 4096\n",
  mode    => '0644',
}

# Restart Nginx service to apply changes
exec { 'nginx-restart':
  command     => '/usr/sbin/nginx -s reload', # Use the reload command for a graceful restart
  path        => ['/bin', '/usr/bin', '/usr/sbin'], # Ensure paths include /usr/sbin
  refreshonly => true, # Only run when notified
  notify      => Exec['increase-ulimit'], # Notify this exec to run after the ulimit change
}
