require 'test/unit'
require 'cryoplot'

class CryoplotTest < Test::Unit::TestCase

	def test_constructor
		plot1 = Cryoplot::ComplexPlot.new(16, 12, -4.0, 4.0, -3.0, 3.0)
		assert_equal plot1.width, 16
		assert_equal plot1.height, 12
	end

end