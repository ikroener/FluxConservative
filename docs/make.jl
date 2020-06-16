push!(LOAD_PATH,"../src/")

using Documenter, FluxConservative

makedocs(sitename="FluxConservative.jl Documentation",
    format = Documenter.HTML(prettyurls = false))

deploydocs(repo = "github.com/ikroener/FluxConservative.git",
    julia  = "1.4.1",
    osname = "osx")
