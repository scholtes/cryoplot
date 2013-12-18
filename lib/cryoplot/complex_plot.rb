require 'cmath'

module Cryoplot # :nodoc:

	# Cryoplot::ComplexPlot represents an individual complex-valued plot.
	class ComplexPlot < ChunkyPNG::Image

		DOMAIN_COLORED_PLOT		= 0x1
		COMPLEX_CONTOUR_PLOT	= 0x2

		# The number of functions on this plot.  Starts at 0, increments each time plot is called.
		attr_reader :size

		# The width and height of the graph portion of the plot, in pixels, but not necessarily of the 
		# entire plot, if margins are non-zero.
		attr_reader :width, :height

		# The real and imaginary bounds of the graph.
		attr_reader :min_r, :max_r, :min_i, :max_i

		# Size of margins, in pixels, around the graph.
		attr_reader :top_margin, :bottom_margin, :left_margin, :right_margin

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
			@width, @height = width, height
			@min_r, @max_r = min_r, max_r
			@min_i, @max_i = min_i, max_i
			@top_margin, @bottom_margin = top_margin, bottom_margin
			@left_margin, @right_margin = left_margin, right_margin
			@bg_color = bg_color
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

		#--
		# Private Methods below

		# TODO: Finish other private methods
		# Like this: http://en.wikipedia.org/wiki/Domain_coloring
		def plotDCPlot(color)
			for pixel_x in @left_margin..(@width+@left_margin-1)
				for pixel_y in @top_margin..(@top_margin+@height-1)
					z = pixelToComplex(pixel_x, pixel_y)
					begin
						fz = yield(z)
					rescue
						fz = Complex(0.0, 0.0)
					end
					self[pixel_x, pixel_y] = complexToColor(fz)
				end
			end 
		end

		# TODO: Make this actually do stuff
		# Like this: http://en.wikipedia.org/wiki/Conformal_map
		# Described here under "Using conformal maps": http://www.pacifict.com/ComplexFunctions.html
		def plotCCPlot(color)
			yield Complex(0,0) # This does nothing, stops from throwing exception.  Remove
		end

		def pixelToComplex(px, py)
			Complex((px-@left_margin)*(@max_r-@min_r)/@width.to_f+@min_r,
					(py-@top_margin)*(@min_i-@max_i)/@height.to_f+@max_i)
		end

		def complexToColor(z)
			hue = z.angle * 180.0/CMath::PI
			r = CMath.log(1.0 + z.magnitude)
			sat = (1.0 + CMath.sin(2*CMath::PI*r))*0.25 + 0.5
			val = (1.0 + CMath.cos(2*CMath::PI*r))*0.25 + 0.5
			# HSV to RGB
			hue = hue % 360.0
			col = sat * val
			hp = hue/60.0
			xcol = col * (1.0 - (hp%2.0 - 1.0).abs)
			if 0<=hp and hp<1
				r,g,b = col, xcol, 0.0
			elsif 1<=hp and hp<2
				r,g,b = xcol, col, 0.0
			elsif 2<=hp and hp<3
				r,g,b = 0.0, col, xcol
			elsif 3<=hp and hp<4
				r,g,b = 0.0, xcol, col
			elsif 4<=hp and hp<5
				r,g,b = xcol, 0.0, col
			elsif 5<=hp and hp<=6
				r,g,b = col, 0.0, xcol
			else
				r,g,b = 0.0, 0.0, 0.0
			end
			m = val - col
			r += m
			g += m
			b += m
			return ChunkyPNG::Color.rgb((255*r).to_i, (255*g).to_i, (255*b).to_i)
		end

		private :plotDCPlot, :plotCCPlot, :pixelToComplex, :complexToColor

	end

end