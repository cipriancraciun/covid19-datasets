

begin
	
	import CSV
	import Gadfly
	import Gadfly.px
	import Cairo
	import Colors
	
	using DataFrames
	using Statistics
	using Formatting
	using Printf
	
end




(
	_dataset_path,
	_plot_path,
	_plot_format,
	_dataset_filter,
	_dataset_index,
	_dataset_metric,
) = ARGS

_dataset_filter = Symbol(_dataset_filter)
_dataset_index = Symbol(_dataset_index)
_dataset_metric = Symbol(_dataset_metric)
_plot_format = Symbol(_plot_format)




_dataset = CSV.read(
		_dataset_path,
		header = 1,
		normalizenames = true,
		delim = "\t", quotechar = '\0', escapechar = '\0',
		categorical = true,
		strict = true,
	)




_dataset = filter(
		(_data ->
			(_data[_dataset_index] !== missing) &&
			(_data[_dataset_metric] !== missing) &&
			(_data[_dataset_metric] != 0) &&
			(_data[:province] !== missing) &&
			(_data[:province] == "total")),
		_dataset,
	)




if _dataset_filter == :global
	
	_dataset_countries = [
			"China", "South Korea",
			"Italy", "Spain", "Germany", "France",
			"United States",
		]
	
elseif _dataset_filter == Symbol("europe-major")
	
	_dataset_countries = [
			"China", "South Korea",
			"Italy", "Spain", "Germany", "France",
		]
	
elseif _dataset_filter == Symbol("europe-minor")
	
	_dataset_countries = [
			"South Korea",
			"Italy", "Spain", "Germany", "France",
			"United Kingdom", "Switzerland",
		#	"Netherlands", "Austria", "Belgium",
		#	"Portugal", "Sweden", "Denmark",
		]
	
	_dataset = filter(
			(_data -> _data[_dataset_index] <= 25),
			_dataset,
		)
	
elseif _dataset_filter == :romania
	
	_dataset_countries = [
			"Romania", "Hungaria", "Bulgaria",
			"Italy", "Spain", "Germany", "France",
			"United Kingdom", "Austria",
		]
	
	_dataset = filter(
			(_data -> _data[_dataset_index] <= 15),
			_dataset,
		)
	
elseif _dataset_filter == :continents
	
	_dataset_countries = [
			
			"Asia", "Europe", "Americas",
			"Oceania", "Africa",
			
		]
	
elseif _dataset_filter == :subcontinents
	
	_dataset_countries = [
			"Western Asia", "Central Asia", "Southern Asia", "South-Eastern Asia", "Eastern Asia",
			"Western Europe", "Northern Europe", "Central Europe", "Southern Europe", "Eastern Europe",
			"North America", "Central America", "South America",
			"Western Africa", "Northern Africa", "Middle Africa", "Southern Africa", "Eastern Africa",
			"Australia and New Zealand", "Caribbean", "Melanesia", "Micronesia", "Polynesia",
		]
	
else
	throw(error("[698e83db]"))
end




_dataset = filter(
		(_data -> _data[:country] in _dataset_countries),
		_dataset,
	)

_dataset_countries = unique(_dataset[!, :country])

_dataset_countries = filter(
		(_country -> size(filter((_data -> _data[:country] == _country), _dataset)[!, _dataset_metric])[1] >= 4),
		_dataset_countries,
	)

_dataset = filter(
		(_data -> _data[:country] in _dataset_countries),
		_dataset,
	)

_dataset_smoothing = 0.9




_dataset_min_date = minimum(_dataset[!, :date])
_dataset_max_date = maximum(_dataset[!, :date])
_dataset_max_index = maximum(_dataset[!, _dataset_index])
_dataset_min_metric = minimum(_dataset[!, _dataset_metric])
_dataset_max_metric = maximum(_dataset[!, _dataset_metric])
_dataset_qmin_metric = quantile(_dataset[!, _dataset_metric], 0.01)
_dataset_qmax_metric = quantile(_dataset[!, _dataset_metric], 0.99)

if (abs(_dataset_min_metric - _dataset_qmin_metric) / _dataset_qmin_metric) > 0.25
	_dataset_min_metric = _dataset_qmin_metric
end
if (abs(_dataset_max_metric - _dataset_qmax_metric) / _dataset_qmax_metric) > 0.25
	_dataset_max_metric = _dataset_qmax_metric
end


_dataset_cmin_metric = nothing
_dataset_cmax_metric = nothing

if _dataset_metric in [:relative_recovered, :relative_deaths, :relative_infected]
	_dataset_rstep_metric = maximum([floor((_dataset_max_metric - _dataset_min_metric) / 10), 1])
	_dataset_cmin_metric = 0
	_dataset_cmax_metric = 100
	_dataset_rsuf_metric = "%"
elseif _dataset_metric in [:deltapct_confirmed, :deltapct_recovered, :deltapct_deaths, :deltapct_infected]
	_dataset_rstep_metric = maximum([floor((_dataset_max_metric - _dataset_min_metric) / 10), 1])
	_dataset_rsuf_metric = "%"
else
	_dataset_rstep_metric = 10 ^ maximum([floor(log10(_dataset_max_metric - _dataset_min_metric)), 0])
	_dataset_rsuf_metric = ""
end

_dataset_rmin_metric = floor(_dataset_min_metric / _dataset_rstep_metric) * _dataset_rstep_metric
_dataset_rmax_metric = ceil(_dataset_max_metric / _dataset_rstep_metric) * _dataset_rstep_metric

if _dataset_cmin_metric !== nothing
	_dataset_rmin_metric = maximum([_dataset_rmin_metric, _dataset_cmin_metric])
end
if _dataset_cmax_metric !== nothing
	_dataset_rmax_metric = minimum([_dataset_rmax_metric, _dataset_cmax_metric])
end




Gadfly.push_theme(:dark)


_plot_colors = DataFrame([
		
		"China" Colors.parse(Colors.Colorant, "white");
		"South Korea" nothing;
		"United States" nothing;
		"Iran" nothing;
		
		"Italy" nothing;
		"Spain" nothing;
		"Germany" nothing;
		"France" nothing;
		"United Kingdom" nothing;
		"Switzerland" nothing;
		"Netherlands" nothing;
		"Austria" nothing;
		"Belgium" nothing;
		"Portugal" nothing;
		"Sweden" nothing;
		"Denmark" nothing;
		
		"Romania" nothing;
		"Hungaria" nothing;
		"Bulgaria" nothing;
		
		"Asia" nothing;
		"Europe" nothing;
		"Americas" nothing;
		"Oceania" nothing;
		"Africa" nothing;
		
		"Western Asia" nothing;
		"Central Asia" nothing;
		"Southern Asia" nothing;
		"South-Eastern Asia" nothing;
		"Eastern Asia" nothing;
		
		"Western Europe" nothing;
		"Northern Europe" nothing;
		"Central Europe" nothing;
		"Southern Europe" nothing;
		"Eastern Europe" nothing;
		
		"North America" nothing;
		"Central America" nothing;
		"South America" nothing;
		
		"Western Africa" nothing;
		"Northern Africa" nothing;
		"Middle Africa" nothing;
		"Southern Africa" nothing;
		"Eastern Africa" nothing;
		
		"Australia and New Zealand" nothing;
		"Caribbean" nothing;
		"Melanesia" nothing;
		"Micronesia" nothing;
		"Polynesia" nothing;
		
	])

_plot_colors = filter(
		(_color -> _color[1] in _dataset_countries),
		_plot_colors,
	)

_plot_colors_count = size(_plot_colors)[1]
_plot_colors[:,2] = circshift(Gadfly.Scale.color_discrete().f(_plot_colors_count), 1)


_plot_font_name = "JetBrains Mono"
_plot_font_size = 12px

_plot_style = Gadfly.style(
		point_size = 4px,
		line_width = 2px,
		grid_line_width = 1px,
		highlight_width = 1px,
		major_label_font = _plot_font_name,
		major_label_font_size = _plot_font_size,
		minor_label_font = _plot_font_name,
		minor_label_font_size = _plot_font_size,
		point_label_font = _plot_font_name,
		point_label_font_size = _plot_font_size,
		key_title_font = _plot_font_name,
		key_title_font_size = _plot_font_size * 0,
		key_label_font = _plot_font_name,
		key_label_font_size = _plot_font_size,
		key_position = :right,
		key_max_columns = 16,
		colorkey_swatch_shape = :circle,
		discrete_highlight_color = (_ -> nothing),
		plot_padding = [16px],
	)


_plot = Gadfly.plot(
		Gadfly.layer(
			_dataset,
			x = _dataset_index,
			y = _dataset_metric,
			color = :country,
			Gadfly.Geom.point,
			Gadfly.style(discrete_highlight_color = (_ -> "black")),
		),
		Gadfly.layer(
			_dataset,
			x = _dataset_index,
			y = _dataset_metric,
			color = :country,
			if _dataset_smoothing !== nothing
				Gadfly.Geom.smooth(method = :loess, smoothing = _dataset_smoothing)
			else
				Gadfly.Geom.line
			end,
		),
		Gadfly.Coord.cartesian(xmin = 1, xmax = _dataset_max_index, ymin = _dataset_rmin_metric, ymax = _dataset_rmax_metric),
		Gadfly.Scale.x_continuous(format = :plain, labels = (_value -> @sprintf("%d", _value))),
		Gadfly.Scale.y_continuous(format = :plain, labels = (_value -> format(_value, commas = true) * _dataset_rsuf_metric)),
		Gadfly.Guide.title(@sprintf("JHU CSSE COVID-19 dataset -- `%s` per `%s` (until %s)", _dataset_metric, _dataset_index, _dataset_max_date)),
		Gadfly.Guide.xlabel(nothing),
		Gadfly.Guide.ylabel(nothing),
		Gadfly.Guide.xticks(ticks = [1; 5 : 5 : _dataset_max_index;]),
		Gadfly.Guide.yticks(ticks = [_dataset_rmin_metric : _dataset_rstep_metric : _dataset_rmax_metric;]),
		Gadfly.Scale.color_discrete_manual(_plot_colors[:,2]..., levels = _plot_colors[:,1]),
		_plot_style,
	)




if _plot_format == :pdf
	_plot_output = Gadfly.PDF(_plot_path, 800px, 400px)
else
	throw(error("[14de0af5]"))
end

Gadfly.draw(_plot_output, _plot)

