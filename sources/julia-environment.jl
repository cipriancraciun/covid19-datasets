

(_project_path, _sysimage_path, _precompile_path) = ARGS

if Base.isfile(_sysimage_path)
	_baseimage_path = _sysimage_path
else
	_baseimage_path = nothing
end


begin
	
	import Pkg
	
	Pkg.activate(_project_path)
	
	Pkg.add("DataFrames")
	Pkg.add("CSV")
	
	Pkg.add("Gadfly")
	Pkg.add("Cairo")
	Pkg.add("Fontconfig")
	
	Pkg.add("Printf")
	Pkg.add("Formatting")
	
	Pkg.status()
end


begin
	
	Pkg.develop("PackageCompiler")
	using PackageCompiler
	
	PackageCompiler.create_sysimage(
			[
				:DataFrames,
				:CSV,
				:Gadfly,
				:Cairo,
				:Fontconfig,
				:Printf,
				:Formatting,
			],
			project = _project_path,
			sysimage_path = _sysimage_path,
			base_sysimage = _baseimage_path,
			incremental = true,
			precompile_statements_file = _precompile_path,
		)
end

