using Documenter, ActorInterfacesTests

makedocs(
    modules = [ActorInterfacesTests],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Schaffer Krisztian",
    sitename = "ActorInterfacesTests.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/tisztamo/ActorInterfacesTests.jl.git",
    push_preview = true
)
