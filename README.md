<h1>vagrant-centos65-nginx-lucee</h1>
======================

Centos6.5+ minimal, on a Vagrant/VirtualBox VM, provisioned using shell.
Includes individual shell script provisioning for:
<ul>
<li>java</li>
<li>tomcat</li>
<li>lucee</li>
<li>nginx</li>
<li>postfix</li>
<li>mariadb</li>
<li>iptables</li>
</ul>
Single host, intended primarily for development.
Includes "custom" scripts for further customization.

## Usage

``` bash
# Install
git clone https://github.com/mrose/vagrant-centos65-nginx-lucee.git
cd vagrant-centos65-nginx-lucee

# Update Configuration
nano config

# Update Vagrant configuration, comment out unnecessary shell scripts
nano Vagrantfile

# Bring up the VM
vagrant up
```

Single host, intended primarily for development.

##License

Unless stated otherwise all works are:

<ul><li>Copyright &copy; 2015+ Mitchell M. Rose</li></ul>

and licensed under:

<ul><li><a href="http://spdx.org/licenses/MIT.html">MIT License</a></li></ul>

Pull requests welcome!

Thanks to:
<ul>
<li>Mike Sprague   [https://github.com/mikesprague/vagrant-lemtl]</li>
<li>Robert Zehnder [https://kisdigital.wordpress.com/tag/nginx/]</li>
<li>Nando          [http://dnando.github.io/blog/2015/01/05/advantages-of-nginx/]</li>
<li>Dan Skaggs     [https://github.com/dskaggs/vagrant-centos-lucee]</li>
<li>Adam Bellas    [http://www.rendered-dreams.com/blog/2014/3/24/Deep-Dive-Multiple-sites-one-Railo-one-Tomcat]</li>
