require 'winrm'

ip_addr = "xxx.xx.xxx.xx"

URL = URI.parse("http://#{ip_addr}:5985/wsman")
COMMAND = 'Get-SCVirtualMachine | select-object VMHost -unique'
USER = 'VMMADMIN\Administrator'
PASSWORD = 'password'

def pwsh_execute_command(url, user, password, command)
  opts = {
    endpoint: url,
    user: user,
    password: password,
    disable_sspi: true
  }

  conn = WinRM::Connection.new(opts)

  arr = []

  conn.shell(:powershell) do |shell|
    output = shell.run(COMMAND) do |stdout, stderr|
      arr.push(stdout)
    end
  end

  arr
end

def get_hosts(arr)
  hosts = []

  3.upto(arr.size-3) do |index|
    hosts.push(arr[index])
  end

  hosts
end

command_result = pwsh_execute_command(URL, USER, PASSWORD, COMMAND)

hosts = get_hosts(command_result)

hosts.each do |item|
  puts item
end
