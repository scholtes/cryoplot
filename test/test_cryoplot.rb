require 'test/unit'
require 'cryoplot'
require 'cmath'

class CryoplotTest < Test::Unit::TestCase

	TEST_PATH = File.dirname(File.expand_path(__FILE__))

	def test_constructor
		plot1 = Cryoplot::ComplexPlot.new(16, 12, -4.0, 4.0, -3.0, 3.0)
		assert_equal plot1.width, 16
		assert_equal plot1.height, 12
	end

	def test_simple_domain_colored
		plot = Cryoplot::ComplexPlot.new(32, 24, -4.0, 4.0, -3.0, 3.0)
		plot.plot { |z| CMath.sin(z) }
		plot.save(TEST_PATH+'/test_simple_domain_colored.png')
		assert true
	end

	def test_simple_contour_plot
		plot = Cryoplot::ComplexPlot.new(400, 300, -4.0, 4.0, -3.0, 3.0)
		plot.plot(:type => Cryoplot::ComplexPlot::COMPLEX_CONTOUR_PLOT, :horz => 9, :vert => 7) { |z| CMath.sin(z) }
		plot.save(TEST_PATH+'/test_simple_contour_plot.png')
		assert true
	end

end