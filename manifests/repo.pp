class newrelic::repo {
  case $operatingsystem {
    /Debian|Ubuntu/: {
      include apt
      apt::key {"548C16BF":
        source => "http://download.newrelic.com/548C16BF.gpg",
      }
      apt::sources_list {"newrelic":
        ensure  => "present",
        content => "deb http://apt.newrelic.com/debian/ newrelic non-free",
        notify => Exec["apt-get_update"],
        require => Apt::Key["548C16BF"],
      }  
    }
    default: { 
      file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-NewRelic":
          owner   => root,
          group   => root,
          mode    => 0644,
          source  => "puppet:///newrelic/RPM-GPG-KEY-NewRelic";
      }

      yumrepo { "newrelic":
          baseurl     => "http://yum.newrelic.com/pub/newrelic/el5/\$basearch", 
          enabled     => "1",
          gpgcheck    => "1",
          gpgkey      => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NewRelic";
      }
    }
  }
}
