nexec.rb
--------

nexec.rb is a script to allow the execution of scripts on remote server using BladeLogic nsh

The automation should be created using "Direct Execution"

parameters required are:

* server: name of server containing remote script
* directory: directory containing remote script (forward slashes should be used, even on Windows servers)
* command: command to be executed, properties will be substituted when enclosed in rpm{prop_name}
* success: a string to check for success in the output.

createnshscriptjobwithparams.rb
-------------------------------

Create NSH Script Job With params.rb is a script that allows the execution of an NSH Script Job in BladeLogic with parameters.

The automation should be created using BAA integration.

parameters requires are:

* depot_object_type: only "NSH Script" is available. This parameter was left because it wasn't clear if the resource automation would still work.
* depot_object: resource automation to specify location of NSH Script
* target_mode: specification of Target Mode. Targets to components will not work with NSH Script Jobs.
* targets: specification of targets
* execute_immediately: yes/no to start execution immediately.
* job_folder: specification of output job folder
* param_0 to param_5: parameters, properties will be substituted when enclosed in rpm{prop_name}
