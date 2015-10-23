To install this configuration:

  apt-get install cfengine3 # with Ubuntu 14.04 LTS
  cp *.cf /var/lib/cfengine3/inputs/

Now test via

  sudo cf-promises

And make it apply via

  sudo cf-agent
