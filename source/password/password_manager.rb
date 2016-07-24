class PasswordHistoryManager

	class << self

		@@time_and_password_splitter = ' => '

		def store_password(password)
			File.open("#{File.dirname(__FILE__)}/password_history.txt", 'a') do |file|
				file.puts(to_history_line(password))
			end
		end

		def get_password_history
			File.read("#{File.dirname(__FILE__)}/password_history.txt")
		end

		def get_last_password
			get_password_history.split("\n").last.split(@@time_and_password_splitter).last unless get_password_history == ""
		end

		def get_last_update_time
			Time.parse(get_password_history.split("\n").last.split(@@time_and_password_splitter).first) unless get_password_history == ""
		end

		def generate_password
			SecureRandom.hex(4)
		end

		private

		def to_history_line(password)
			"#{Time.now.strftime("%-d %B %Y %H:%M")}#{@@time_and_password_splitter}#{password}"
		end

	end

end