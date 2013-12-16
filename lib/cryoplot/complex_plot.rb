module Cryoplot # :nodoc:

	# Cryoplot::ComplexPlot represents an individual complex-valued plot.
	class ComplexPlot < ChunkyPNG::Image

		DOMAIN_COLORED_PLOT		= 0x1
		COMPLEX_CONTOUR_PLOT	= 0x2

		# The number of functions on this plot.  Starts at 0, increments each time plot is called.
		attr_reader :size

		# Initializes a new instance of Cryoplot::ComplexPlot
		# @param width [Integer] The width of the plot area, in pixels (excluding margins)
		# @param height [Integer] The height of the plot area, in pixels (excluding margins)
		# @param min_r [Float] Lowest real part of complex numbers in the domain
		# @param max_r [Float] Highest real part of complex numbers in the domain
		# @param min_i [Float] Lowest imaginary part of complex numbers in the domain
		# @param max_i [Float] Highest imaginary part of complex numbers in the domain
		# @param top_margin [Integer] Height of top margin, in pixels
		# @param bottom_margin [Integer] Height of bottom margin, in pixels
		# @param left_margin [Integer] Width of left margin, in pixels
		# @param right_margin [Integer] Width of right margin, in pixels
		# @param bg_color [ChunkyPNG::Color] Default background color.
		def initialize(width, height, min_r, max_r, min_i, max_i,
				top_margin=0, bottom_margin=0, left_margin=0, right_margin=0,
				bg_color = ChunkyPNG::Color::PREDEFINED_COLORS[:whitesmoke])
			super(width+left_margin+right_margin, height+top_margin+bottom_margin, bg_color)
			@size = 0;
		end

		# Draws a plot of a complex-valued function.  Multiple functions may be graphed on one ComplexPlot instance.
		# However, only one domain-colored plot can be drawn and it must come first, or it will draw over other plots.
		# @param type [Integer] A constant reffering to the plot type, either DOMAIN_COLORED_PLOT or COMPLEX_CONTOUR_PLOT
		# @param type color [ChunkyPNG::Color] If contour plot, the color of the contours.  If domain-colored, color of out-of-domain values.
		# :yields: z [Complex] Iterates through the domain of the plot.  The return value of each iteration in the block will be plotted at a pixel.
		def plot(type=DOMAIN_COLORED_PLOT, color=ChunkyPNG::Color::BLACK, &block)
			if type == DOMAIN_COLORED_PLOT and @size > 0
				warn "Warning in #{self.class}::plot: DOMAIN_COLORED_PLOT will overdraw existing #{@size} plots.  Draw 1st for correct behavior."
			end
			case type
				when DOMAIN_COLORED_PLOT then plotDCPlot(color, &block)
				when COMPLEX_CONTOUR_PLOT then plotCCPlot(color, &block)
				else raise RangeError, "Invalid plot type #{type}."
			end
			@size += 1
		end

		# Private Methods below

		# TODO: Make this actually do stuff
		# Like this: http://en.wikipedia.org/wiki/Domain_coloring
		def plotDCPlot(color)
			yield Complex(0,0) # This does nothing, stops from throwing exception.  Remove
		end

		# TODO: Make this actually do stuff
		# Like this: http://en.wikipedia.org/wiki/Conformal_map
		# Described here under "Using conformal maps": http://www.pacifict.com/ComplexFunctions.html
		def plotCCPlot(color)
			yield Complex(0,0) # This does nothing, stops from throwing exception.  Remove
		end

		private :plotDCPlot, :plotCCPlot

	end

end