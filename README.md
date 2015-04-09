# A Simple Deployment Puppet Lab

This small project lab demonstrates the ability (and my understanding of how) to deploy a simple Ruby Sinatra application using Puppet and Git. 

Using the publicly available Sinatra application found at https://github.com/tnh/simple-sinatra-app, a **Ubuntu 14.10** virtual machine running under **Microsoft Azure**, I have been able to fully construct the following solution.

## Pre-requisites
### Hosting machine
Now any machine could be used to demonstrate this, but a nice clean machine image is always a nice starting point to fully know that there are no conflicts that could prove more difficult to diagnose if using say your development machine that is tailored to your specific requirements, not necessarily those of the application. In my instance I have used a virtual machine running Ubuntu 14.10 hosted at Microsoft Azure web hosting service. Why, because I could and I have a current free MSDN subscription courtesy of work.

As part of the virtual machine configuration, make sure that you enable an end point to the ```HTTP``` port ```80``` and map to port ```80``` for ease sake, so you can see your deployed application remotely.

### Packages
Once you have your virtual machine up and running, some software to get things started will need to be installed.

Firstly start by updating the base machine image with any pending updates

```bash
sudo apt-get update && sudo apt-get upgrade -y
```

Next we need to get install the key software packages we will need to get everything started.

```bash
sudo apt-get install -y git puppet
```

This will install the two key packages ```git``` and ```puppet```.

## Our Puppet configuration
### The Git repository
Next we can start by putting together our Puppet configuration files which will be stored in Git, using the web service **GitHub**.

To me, the first thing was to create my GitHub respository for saving my files. If you already have a GitHub account, great. If not, start by joining up here - https://github.com/join. 

Next, create a new repository by selecting one of the option on your landing page when you log in. In the create repository page enter in a name for your repository (```puppet-lab``` shall do for this), a description, the scope type of public or private if you have paid for a subscription and a couple of initialisation option including a ```README``` file, an gitignore file structure and a licence type.  Once that is done, you can now clone this to your development machine to start working.

On the command line;

```bash
clone https://github.com/<github_name>/puppet-lab.git
cd puppt-lab
```

You may want to set your user details at this point before you start committing any changes. Simple run the following commands replacing the user name and email values.

```bash
git config --add user.name <user_name>
git config --add user.email <email_address>
git config --list

user.name=<user_name>
user.email=<email_address>
core.symlinks=false
core.repositoryformatversion=0
core.filemode=true
core.logallrefupdates=true
remote.origin.url=https://github.com/<github_name>/puppet-lab.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.master.remote=origin
branch.master.merge=refs/heads/master
```

All the other key value pairs are from when the repository was cloned.

#### Saving changes
With any changes made, it always pay to commit your changes as often as possible. With Git, this is no different. With Git you would *add*, then *commit*, then *push* your changes back up the the source, which in this case is our GitHub repository. As this is just a simple repository, I am only working of the *master* branch.

Now all of this can be done from the command line, but if you are a GUI type of user, then for your Linux desktop, I have found CollabNet's GitEye one of the better tools around, even though it may be a bit bloated running in the Java based Eclipse IDE.

###Puppet files
Now that we have a project (working) folder called ```puppet-lab```. Next we need to start by creating our initial folder structure. There are two main folders we require here called ``` manifests``` and ```modules```.

In the modules folder we need to create further folders to break up our required  packages, services and files. The folders we need are ```git```, ```nginx```, ```ruby``` and ```simple-deployment```. In each of these create their own ```manifests``` folder. Lastly a sub-folder under ```./modules/simple-deployment``` called ```templates```. We should have a folder structure that looks like the following.

```
.
├── .git
├── manifests
└── modules
    ├── git
    │   └── manifests
    ├── nginx
    │   └── manifests
    ├── ruby
    │   └── manifests
    └── simple-deployment
        ├── manifests
        └── templates
```

For each module, the manifest folder will need to contain an ```init.pp``` that Puppet will use as the definition of each of the modules.  Here is a high level overview of what each module manifest does.

#### Module: git
The manifest for the ```git``` module is largely thanks to Pindi Albert at http://www.pindi.us/blog/getting-started-puppet.

<table border=1 cellpadding=2 cellspacing=0 bordercolor=darkgray width=100%>
	<tr>
		<th>Name</th>
		<th>Type</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>git</td>
		<td>Class</td>
		<td>The **git** manifest main class</td>
	</tr>
	<tr>
		<td>git</td>
		<td>Package</td>
		<td>Ensures that the package is installed</td>
	</tr>
	<tr>
		<td>git::clone</td>
		<td>Definition</td>
		<td>Helps perform the actual clone of a Git repository</td>
	</tr>
</table>

#### Module: nginx
For help provide a abstraction layer to the actual application, I used ```nginx``` to act as my proxy forwarding server.

<table border=1 cellpadding=2 cellspacing=0 bordercolor=darkgray width=100%>
	<tr>
		<th>Name</th>
		<th>Type</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>nginx</td>
		<td>Class</td>
		<td>The **nginx** manifest main class</td>
	</tr>
	<tr>
		<td>apache2.2-common</td>
		<td>Package</td>
		<td>Ensures that the package is NOT installed as this can cause conflicts with nginx</td>
	</tr>
	<tr>
		<td>nginx</td>
		<td>Package</td>
		<td>Ensures that the **nginx** package is installed</td>
	</tr>
	<tr>
		<td>nginx</td>
		<td>Service</td>
		<td>Ensures that the service is installed and running</td>
	</tr>
	<tr>
		<td>/etc/nginx/sites-enabled/default</td>
		<td>File</td>
		<td>We do not want the default site configuration linked too to disable it</td>
	</tr>
	<tr>
		<td>/var/www</td>
		<td>File</td>
		<td>Initial default location of web site files</td>
	</tr>
</table>

#### Module: ruby
The **ruby** manifest helps establish some core packages that will be required by the ***simple-deployment*** module.

<table border=1 cellpadding=2 cellspacing=0 bordercolor=darkgray width=100%>
	<tr>
		<th>Name</th>
		<th>Type</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>ruby</td>
		<td>Class</td>
		<td>The <b>ruby</b> manifest main class</td>
	</tr>
	<tr>
		<td>ruby2.0</td>
		<td>Package</td>
		<td>Ensures that the core package for Ruby is installed.</td>
	</tr>
	<tr>
		<td>bundler</td>
		<td>Package</td>
		<td>Ensures that the Ruby gem **bundler** is installed using the gem provider</td>
	</tr>
</table>


#### Module: simple-deployment
The **simple-deployment** manifest is the main module for deploying the application.

<table border=1 cellpadding=2 cellspacing=0 bordercolor=darkgray width=100%>
	<tr>
		<th>Name</th>
		<th>Type</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>$site_name</td>
		<td>Variable</td>
		<td>Variable containing the common name of the application</td>
	</tr>
	<tr>
		<td>$site_domain</td>
		<td>Variable</td>
		<td>Variable containing the site address name</td>
	</tr>
	<tr>
		<td>git::clone 'https://github.com/tnh/simple-sinatra-app'</td>
		<td>Definition Call</td>
		<td>Call to the git::clone definition to clone the Sinatra appliaction from GitHub. By doing it this way, we can seperate the application code from the deployment configuration code it this was the desired source stored model.</td>
	</tr>
	<tr>
		<td>simpledeployd</td>
		<td>Service</td>
		<td>Ensures that the service to start and stop the application is installed and running</td>
	</tr>
	<tr>
		<td>site-install</td>
		<td>Exec</td>
		<td>Executes a bundle install from the cloned application</td>
	</tr>
	<tr>
		<td>/etc/init.d/simpledeployd</td>
		<td>File</td>
		<td>Upstart shell script</td>
	</tr>
	<tr>
		<td>/etc/nginx/sites-available/${site_name}</td>
		<td>File</td>
		<td>Configuration file for the nginx web site</td>
	</tr>
	<tr>
		<td>/etc/nginx/sites-enabled/${site_name}</td>
		<td>File</td>
		<td>Creates the symbolic link to the available site configuration file for the application</td>
	</tr>
	<tr>
		<td>/usr/bin/${site_name}</td>
		<td>File</td>
		<td>Shell script that is called by the <b>simpledeployd</b> Upstart service</td>
	</tr>
</table>

As well as the **simple-deployment** manifest, there are three template files that are deployed.

<table border=1 cellpadding=2 cellspacing=0 bordercolor=darkgray width=100%>
	<tr>
		<th>Name</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>exec-simple-deployment</td>
		<td>Shell script that is used for the File[/usr/bin/${site_name}]</td>
	</tr>
	<tr>
		<td>nginx-site.conf.erb</td>
		<td>The configuration file used for the File[/etc/nginx/sites-available/${site_name}]</td>
	</tr>
	<tr>
		<td>simple-deployment-daemon</td>
		<td>Shell script that is used for the File[/etc/init.d/simpledeployd]</td>
	</tr>
</table>

## Site deployment manifests
Now that we have all our required modules, we need to now define where we are going to deploy this to and what modules to include in the deployment

### Manifest: nodes.pp
For the lab, the file contains a single node reference the includes the modules required for this deployment, primarily being **nginx**, **ruby** & **simple-deployment**.

### Manifest: sites.pp
This file imports the *node.pp* file for processing.

## Automating the process
To help automate this solution as a one command process there are two scripts that can called, with one that can be used to execute that configuration file update and execute the puppet deployment.

### Script: apply
This shell script performs the actual Puppet apply command. This has been create if a refresh of the configuration files is not required.

### Script: pull-updates
This shell script performs a ```git pull``` to update the Puppet configuration files, then calls the ***apply*** script to initiate the Puppet apply. 

## Final file structure
In the end with have a file structure that looks something like that follows.

```
.
├── .git
│   └── ...
├── manifests
│   ├── nodes.pp
│   └── sites.pp
├── modules
│   ├── git
│   │   └── manifests
│   │       └── init.pp
│   ├── nginx
│   │   └── manifests
│   │       └── init.pp
│   ├── ruby
│   │   └── manifests
│   │       └── init.pp
│   └── simple-deployment
│       ├── manifests
│       │   └── init.pp
│       └── templates
│           ├── exec-simple-deployment
│           ├── nginx-site.conf.erb
│           └── simple-deployment-daemon
├── apply
├── .gitignore
├── LICENSE
├── pull-updates
└── README.md
```
## Notes
As a real novice to the ways in which **Ruby** works with *Bundler* and the *Rack* gem, I did find this quite a challenge understanding how *Bundler* and the ```rackup``` command worked. In the end it was a simple matter of having the ```rackup``` command create a process ID file which can then be used by the Upstart service **simpledeployd** and the **/usr/bin/simple-deployment** script to control the starting and stopping of the application.

With the service **simpledeployd** script, please note that the *status* code has been slightly modified to check for the process ID file instead of the daemon or service name.

As for the controlling of the application, this is done in the shell script **/usr/bin/simple-deployment** where it uses the process ID to kill the application running process. One other thing that tripped me up here was the fact that I need to return the actual status code to tell Upstart if the application shutdown actually worked. Without this, the service stop would just fail. Check out the references for the solution I implemented.

## References
I must acknowledge the sources of information used while attempting to construct this lab.

**General**
- http://www.puppetcookbook.com
- https://docs.puppetlabs.com/references/latest/type.html
- https://docs.puppetlabs.com/puppet/2.7/reference/lang_resources.html

**Setting use of Git in Puppet**
- http://www.pindi.us/blog/getting-started-puppet

**How to deploy Ruby rack with nginx**
- http://stackoverflow.com/questions/13030149/how-to-deploy-ruby-rack-app-with-nginx

**Why Puppet cannot handle bundle exec**
- http://stackoverflow.com/questions/18309990/why-my-puppet-can-not-handle-bundle-exec
- http://serverfault.com/questions/597219/net-ads-join-fails-in-puppet-exec-but-runs-ok-directly-from-command-line

**Bundle install reference**
- https://github.com/mayflower/puppet-bundler/blob/mayflower/manifests/install.pp

**Service script exit return issue in Ubuntu**
- https://projects.puppetlabs.com/issues/12773