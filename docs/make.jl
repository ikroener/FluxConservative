push!(LOAD_PATH,"../src/")

using Documenter, FluxConservative

makedocs(sitename="FluxConservative.jl Documentation",
    format = Documenter.HTML(prettyurls = false))

deploydocs(deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/ikroener/FluxConservative.git")
