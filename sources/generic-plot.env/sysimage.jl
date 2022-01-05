

_packages = [
		
		:DataFrames,
		:Statistics,
		:CSV,
		:Gadfly,
		:Cairo,
		:Colors,
		:Formatting,
		:Printf,
		:Dates,
		
	#!	:Fontconfig,
		
		:PackageCompiler,
		
	]


_packages_nocompile = [
		
		:PackageCompiler,
		
	]


_packages_compile = filter((_package -> ! (_package in _packages_nocompile)), _packages)




(_project_path, _sysimage_path, _precompile_path) = ARGS

_baseimage_path = if Base.isfile(_sysimage_path) _sysimage_path end


begin
	
	import Pkg
	
	Pkg.activate(_project_path)
	
	Pkg.add(map(String, _packages))
end


begin
	
	import PackageCompiler
	
	PackageCompiler.create_sysimage(
			_packages_compile,
			project = _project_path,
			sysimage_path = _sysimage_path,
			base_sysimage = _baseimage_path,
			precompile_statements_file = _precompile_path,
			incremental = true,
		)
end

