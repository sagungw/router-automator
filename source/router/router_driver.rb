require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'capybara-screenshot'
require 'yaml'

require_relative 'mapper/element_mapper'

class RouterAdminApp
	include Capybara::DSL

	attr_reader :router_config, :element_mapper

	def initialize
		@router_config = get_router_configuration
		@element_mapper = RouterElementMapper.new
		
		Capybara.run_server = false
		Capybara.app_host = "http://#{@router_config['router_admin_url']}"
		Capybara.current_driver = :poltergeist_phantom

   		Capybara.register_driver :poltergeist_phantom do |app|
      		Capybara::Poltergeist::Driver.new(app,
                                        :phantomjs => "D:/Dokumen/Agung/Projects/router-automator/libraries/phantomjs-2.1.1-windows/bin/phantomjs.exe",
                                        :js_errors => false,
                                        :timeout => 60,
                                        :phantomjs_options => %w(--ignore-ssl-errors=true --ssl-protocol=any),
                                        :window_size => [1366, 768])
    	end

    	login
	end

	def login
		visit("http://#{@router_config['router_admin_account']}:#{@router_config['router_admin_password']}@#{router_config['router_admin_url']}/")
	end

	def change_wlan_password(new_password)
		visit("http://#{@router_config['router_admin_url']}/basic/home_wlan.htm")

		wlan_pass_field = @element_mapper.to_element_selector('WLAN Password')
		fill_in(wlan_pass_field.selector, with: new_password)

		save_btn = @element_mapper.to_element_selector('Cancel Button')
		find(save_btn.selector_type, save_btn.selector).click
	end

	def save_screenshot(output_file = './output/screenshots/out.png')
    	page.driver.browser.render(output_file, :full => true)
  	end

	private

	def get_router_configuration
		configuration = YAML.load_file("#{File.dirname(__FILE__)}/router_config.yml")
	end

end
