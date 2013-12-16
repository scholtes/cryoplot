Gem::Specification.new { |s|
	s.name			= 'cryoplot'
	s.version		= '0.0.1.pre'
	s.date			= '2013-12-15'
	s.summary 		= "cryoplot - A complex-valued function plotting API for Ruby"
	s.description	= <<-EOF
cryoplot is a pure Ruby tool for generating plots for complex-valued functions.
See the rdoc <<url>> and git repository <<url>> for more details.
 EOF
	s.authors		= ["Garrett Scholtes"]
	s.email			= 'scholtes.garrett@gmail.com'
	s.files			= ["lib/cryoplot.rb", "lib/cryoplot/complex_plot.rb"]
	s.add_runtime_dependency "chunky_png",
		[">= 1.2.9"]
	s.homepage		= 'http://rubygems.org/gems/cryoplot'
	s.license		= 'MIT'
}