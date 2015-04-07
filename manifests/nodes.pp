
node 'puppet-lab-03' {
	include simple-deployment
	include nginx
	include ruby

}
