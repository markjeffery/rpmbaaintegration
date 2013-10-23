nexec.rb

nexec.rb is a script to allow the execution of scripts on remote server using BladeLogic nsh

The automation should be created using "Direct Execution"

parameters provided are:

server: name of server containing remote script
directory: directory containing remote script (forward slashes should be used, even on Windows servers)
command: command to be executed, properties will be substituted when enclosed in rpm{prop_name}
success: a string to check for success in the output.
