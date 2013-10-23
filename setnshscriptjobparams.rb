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

# This job sets 6 parameters for an NSH Script job to values provided.
# The values can be string literals, or they can have portions substituted for property names.
# e.g. if param_0 needed to contain the Application name, the value would be rpm{SS_application}

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

def sub_tokens(script_params,var_string)
  write_to("Entered sub_tokens:" + var_string)
  prop_val = var_string.match('rpm{[^{}]*}')
  while ! prop_val.nil? do
    var_string = var_string.sub(prop_val[0],script_params[prop_val[0][4..-2]])
    prop_val = var_string.match('rpm{[^{}]*}')
  end
  write_to("returning: " + var_string)
  return var_string
end

begin
  job_name = params["job_name"]
  job_folder = params["job_folder"]

  session_id = BaaUtilities.baa_soap_login(BAA_BASE_URL, BAA_USERNAME, BAA_PASSWORD)
  raise "Could not login to BAA Cli Tunnel Service" if session_id.nil?

  BaaUtilities.baa_soap_assume_role(BAA_BASE_URL, BAA_ROLE, session_id)

# clear params first
  BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id, "NSHScriptJob", "clearNSHScriptParameterValuesByGroupAndName", [job_folder, job_name])

# set params
  params.each do |key, value|
    if /param_(?<pnum>\d+)/ =~ key
      BaaUtilities.baa_soap_execute_cli_command_by_param_list(BAA_BASE_URL, session_id,
        "NSHScriptJob", "addNSHScriptParameterValueByGroupAndName",
        [job_folder, job_name, pnum, sub_tokens(params, value)])
    end
  end
end