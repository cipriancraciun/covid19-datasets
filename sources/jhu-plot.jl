

begin
	
	import CSV
	import Gadfly
	import Gadfly.px
	import Cairo
	
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
			"China", "Korea, South",
			"Italy", "Spain", "Germany", "France",
			"US",
		]
	
	_dataset = filter(
			(_data -> _data[:country] in _dataset_countries),
			_dataset,
		)
	
	_dataset_smoothing = if (_dataset_metric in [
			:delta_recovered,
			:deltapct_recovered,
		]) nothing else 0.9 end
	
elseif _dataset_filter == :romania
	
	_dataset_countries = [
			"Romania",
		#	"Bulgaria", "Hungaria",
			"Italy", "Spain", "Germany", "France",
			"Austria", "Switzerland", "United Kingdom",
			"US",
		]
	
	_dataset = filter(
			(_data -> _data[:country] in _dataset_countries),
			_dataset,
		)
	
	_dataset = filter(
			(_data -> _data[_dataset_index] <= 10),
			_dataset,
		)
	
	_dataset_smoothing = if (_dataset_metric in [
			:delta_deaths, :delta_recovered,
			:deltapct_deaths, :deltapct_recovered,
		]) nothing else 0.9 end
	
else
	throw(error("[698e83db]"))
end




_dataset_min_date = minimum(_dataset[!, :date])
_dataset_max_date = maximum(_dataset[!, :date])
_dataset_max_index = maximum(_dataset[!, _dataset_index])
_dataset_min_metric = minimum(_dataset[!, _dataset_metric])
_dataset_max_metric = maximum(_dataset[!, _dataset_metric])
_dataset_q99_metric = quantile(_dataset[!, _dataset_metric], 0.99)

if _dataset_max_metric > _dataset_q99_metric * 2
	_dataset_max_metric = _dataset_q99_metric
end


_dataset_cmin_metric = nothing
_dataset_cmax_metric = nothing

if _dataset_metric in [:relative_recovered, :relative_deaths, :relative_infected]
	_dataset_rstep_metric = maximum([floor((_dataset_max_metric - _dataset_min_metric) / 10), 1])
	_dataset_cmin_metric = 0
	_dataset_cmax_metric = 100
	_dataset_rsuf_metric = "%"
else
	_dataset_rstep_metric = 10 ^ maximum([floor(log10(_dataset_max_metric - _dataset_min_metric)), 1])
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


_plot_palette = Gadfly.Scale.color_discrete().f(14)

_plot_colors = DataFrame([
		"Romania" _plot_palette[1];
		"China" _plot_palette[2];
		"Italy" _plot_palette[3];
		"Spain" _plot_palette[4];
		"Germany" _plot_palette[5];
		"France" _plot_palette[6];
		"Austria" _plot_palette[7];
		"Switzerland" _plot_palette[8];
		"United Kingdom" _plot_palette[9];
		"US" _plot_palette[10];
		"Korea, South" _plot_palette[11];
		"Iran" _plot_palette[12];
		"Bulgaria" _plot_palette[13];
		"Hungaria" _plot_palette[14];
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
		highlight_width = 2px,
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

