# Fix request limit at nginx
exec { 'fix-for-nginx':
    command => '/bin/sed -i "s/15/4096/" /etc/default/nginx',
}
# Restart nginx
