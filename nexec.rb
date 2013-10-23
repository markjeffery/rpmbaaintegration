###
# server:
#   name: Server Name
#   type: in-text
#   position: A1:B1
#   required: yes
# directory:
#   name: Server Directory
#   type: in-text
#   position: A2:F2
#   required: yes
# command:
#   name: Name of command
#   type: in-text
#   position: A3:F3
#   required: yes
# success:
#   name: Term or Phrase to indicate success
#   type: in-text
#   position: A4:F4
#   required: yes
###
# Flag the script for direct execution
params["direct_execute"] = true

#==============  User Portion of Script ==================

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

server_name = params["server"]
directory = params["directory"]
command = sub_tokens(params,params["command"])
full_directory = "//#{server_name}#{directory}"
full_command = "nsh -D \"#{full_directory}\" -c \"#{command}\""
write_to "Command to be executed #{full_command}\n"
# Run the command directly on the localhost
result = run_command(params, full_command, '')

params["success"] = params["success"] || ""

# Apply success or failure criteria
if result.index(params["success"]).nil?
  write_to "Command_Failed - term not found: [#{params["success"]}]\n"
else
  write_to "Success - found term: #{params["success"]}\n"
end