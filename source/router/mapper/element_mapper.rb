require 'yaml'

class RouterElementMapper

	attr_reader :element_selectors, :element_selectors_file_name

	def initialize
		@element_selectors_file_name = 'router_elements.yml'
		@element_selectors = YAML.load_file("#{File.dirname(__FILE__)}/#{@element_selectors_file_name}")
	end

	def to_element_selector(element_name)
		element_selector = @element_selectors["#{element_name}"]
		raise "Unable to find selector for element named '#{element_name}'. Make sure the element name exists in #{@element_selectors_file_name}." if element_selector == nil || element_selector == {}
		Struct.new(:selector, :selector_type).new(element_selector['selector'], element_selector['selector_type'].to_sym)
	end

end
