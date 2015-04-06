$site_name = 'simple-deployment'
$site_domain = 'simple-deployment.com'

node 'puppet-lab' {
	include simple-deployment
	include nginx
	include ruby

}
