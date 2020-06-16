push!(LOAD_PATH,"../src/")

using Documenter, FluxConservative

makedocs(sitename="FluxConservative",
    format = Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        prettyurls = !("local" in ARGS),
        canonical = "https://ikroener.github.io/FluxConservative/stable/",
        #assets = ["assets/favicon.ico"],
        #analytics = "UA-136089579-2",
        #highlights = ["yaml"],
    ),
    clean = false,
    authors = "Igor Kroener",
    linkcheck = !("skiplinks" in ARGS),
    linkcheck_ignore = [
        # timelessrepo.com seems to 404 on any CURL request...
        "http://timelessrepo.com/json-isnt-a-javascript-subset",
        # We'll ignore links that point to GitHub's edit pages, as they redirect to the
        # login screen and cause a warning:
        r"https://github.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/edit(.*)",
    ] ∪ (get(ENV, "GITHUB_ACTIONS", nothing)  == "true" ? [
        # Extra ones we ignore only on CI.
        #
        # It seems that CTAN blocks GitHub Actions?
        "https://ctan.org/pkg/minted",
    ] : []),
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
#            "Guide" => "man/guide.md",
            "man/examples.md"
#            "man/syntax.md",
#            "man/doctests.md",
#            "man/latex.md",
#            hide("man/hosting.md", [
#                "man/hosting/walkthrough.md"
#            ]),
#            "man/other-formats.md",
        ],
#        "showcase.md",
        "Library" => Any[
            "Public" => "lib/public.md",
            "Internals" => "lib/internals.md"
            #"Internals" => map(
            #    s -> "lib/internals/$(s)",
            #    sort(readdir(joinpath(@__DIR__, "src/lib/internals")))
            #),
        ],
#        "contributing.md",
    ],
    strict = !("strict=false" in ARGS),
    doctest = ("doctest=only" in ARGS) ? :only : true,
)

deploydocs(deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/ikroener/FluxConservative.git")
