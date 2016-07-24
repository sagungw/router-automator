require_relative 'password/password_manager'
require_relative 'router/router_driver'

time_difference_threshold = 2592000 # +-a month in seconds

change_password = false

if PasswordHistoryManager.get_password_history == "" 
	change_password = true
else
	change_password = true if (Time.now - PasswordHistoryManager.get_last_update_time).abs >= time_difference_threshold
end

if change_password
	driver = RouterAdminApp.new
	new_password = PasswordHistoryManager.generate_password
	driver.change_wlan_password(new_password)
	PasswordHistoryManager.store_password(new_password)
	puts "WLAN password has been changed to #{PasswordHistoryManager.get_last_password}"
else
	puts "WLAN password was not changed"
end
