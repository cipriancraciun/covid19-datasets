

begin
	
	import CSV
	import Gadfly
	import Gadfly.px
	import Cairo
	
	using Statistics
	using Formatting
	using Printf
	
end




(
	_dataset_path,
	_plot_path,
	_plot_format,
	_dataset_index,
	_dataset_metric,
) = ARGS

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
			(_data[:province] !== missing) &&
			(_data[:province] == "total")),
		_dataset,
	)

_dataset = filter(
		(_data -> _data[:country] in [
				"China",
				"Italy", "Spain", "Germany", "France",
				"US", "Iran",
		]),
		_dataset,
	)




_dataset_min_date = minimum(_dataset[!, :date])
_dataset_max_date = maximum(_dataset[!, :date])
_dataset_max_index = maximum(_dataset[!, _dataset_index])
_dataset_min_metric = minimum(_dataset[!, _dataset_metric])
_dataset_max_metric = maximum(_dataset[!, _dataset_metric])
_dataset_q99_metric = quantile(_dataset[!, _dataset_metric], 0.99)

if _dataset_max_metric > _dataset_q99_metric * 2
	_dataset_max_metric = _dataset_q99_metric
end

_dataset_rstep_metric = 10 ^ maximum([floor(log10(_dataset_max_metric - _dataset_min_metric)), 1])
_dataset_rmin_metric = floor(_dataset_min_metric / _dataset_rstep_metric) * _dataset_rstep_metric
_dataset_rmax_metric = ceil(_dataset_max_metric / _dataset_rstep_metric) * _dataset_rstep_metric




Gadfly.push_theme(:dark)

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
			Gadfly.Geom.smooth(method = :loess, smoothing = 0.75),
		),
		Gadfly.Coord.cartesian(xmin = 1, xmax = _dataset_max_index, ymin = _dataset_rmin_metric, ymax = _dataset_rmax_metric),
		Gadfly.Scale.x_continuous(format = :plain, labels = (_value -> @sprintf("%d", _value))),
		Gadfly.Scale.y_continuous(format = :plain, labels = (_value -> format(_value, commas = true))),
		Gadfly.Guide.title(@sprintf("JHU CSSE COVID-19 dataset -- `%s` per `%s` (until %s)", _dataset_metric, _dataset_index, _dataset_max_date)),
		Gadfly.Guide.xlabel(nothing),
		Gadfly.Guide.ylabel(nothing),
		Gadfly.Guide.xticks(ticks = [1; 5 : 5 : _dataset_max_index;]),
		Gadfly.Guide.yticks(ticks = [_dataset_rmin_metric : _dataset_rstep_metric : _dataset_rmax_metric;]),
		_plot_style,
	)




if _plot_format == :pdf
	_plot_output = Gadfly.PDF(_plot_path, 800px, 400px)
else
	throw(error("[14de0af5]"))
end

Gadfly.draw(_plot_output, _plot)

