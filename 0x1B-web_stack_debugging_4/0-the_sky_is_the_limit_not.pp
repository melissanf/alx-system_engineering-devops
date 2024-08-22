# Increases the amount of traffic an Nginx server can handle by increasing the ULIMIT

exec { 'fix-for-nginx':
  command => 'sed -i "s/15/4096/" /etc/default/nginx',
  path    => '/bin:/usr/bin',
}

# Ensure that the file descriptor changes are applied before restarting Nginx
Exec['fix-for-nginx'] -> Exec['nginx-restart']

# Restart Nginx to apply the changes
exec { 'nginx-restart':
  command => '/usr/sbin/nginx -s reload', # Adjust this path if necessary
  path    => '/bin:/usr/bin',
}
