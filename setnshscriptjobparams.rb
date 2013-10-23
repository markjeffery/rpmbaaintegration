###
#
# job_folder:
#   name: Job Folder
#   position: A1:F1
#   type: in-text
# job_name:
#   name: Job Name
#   type: in-text
#   position: A2:F2
# param_0:
#   name: Param 0
#   type: in-text
#   position: A3:F3
# param_1:
#   name: Param 1
#   type: in-text
#   position: A4:F4
# param_2:
#   name: Param 2
#   type: in-text
#   position: A5:F5
# param_3:
#   name: Param 3
#   type: in-text
#   position: A6:F6
# param_4:
#   name: Param 4
#   type: in-text
#   position: A7:F7
# param_5:
#   name: Param 5
#   type: in-text
#   position: A8:F8
###


#=== BMC Application Automation Integration Server: BAA ===#
# [integration_id=2]
SS_integration_dns = "https://bl-appserver:9843"
SS_integration_username = "BLAdmin"
SS_integration_password = "-private-"
SS_integration_details = "role: BLAdmins
authentication_mode: SRP
WAS_RootFolder: BRPM Actions/WebSphere
ExecutionFolder: BRPM Executions"
SS_integration_password_enc = "__SS__Cj1RbWN2ZDNjekZHYw=="
#=== End ===#


require 'json'
require 'rest-client'
require 'uri'
require 'savon'
require 'base64'
require 'yaml'
require 'lib/script_support/baa_utilities'

params["direct_execute"] = true

baa_config = YAML.load(SS_integration_details)

BAA_USERNAME = SS_integration_username
BAA_PASSWORD = decrypt_string_with_prefix(SS_integration_password_enc)
BAA_ROLE = baa_config["role"]
BAA_BASE_URL = SS_integration_dns

begin
  job_name = params["job_name"]
  job_folder = params["job_folder"]

  param = Array.new
  param[0] = params["param_0"];
  param[1] = params["param_1"];
  param[2] = params["param_2"];
  param[3] = params["param_3"];
  param[4] = params["param_4"];
  param[5] = params["param_5"];

  session_id = BaaUtilities.baa_soap_login(BAA_BASE_URL, BAA_USERNAME, BAA_PASSWORD)
  raise "Could not login to BAA Cli Tunnel Service" if session_id.nil?

  BaaUtilities.baa_soap_assume_role(BAA_BASE_URL, BAA_ROLE, session_id)

# clear params first
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "clearNSHScriptParameterValuesByGroupAndName", [job_folder, job_name])
# set params
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName", [job_folder, job_name, 0, params["param_0"]])
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName", [job_folder, job_name, 1, params["param_1"]])
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName", [job_folder, job_name, 2, params["param_2"]])
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName", [job_folder, job_name, 3, params["param_3"]])
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName", [job_folder, job_name, 4, params["param_4"]])
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName", [job_folder, job_name, 5, params["param_5"]])

end