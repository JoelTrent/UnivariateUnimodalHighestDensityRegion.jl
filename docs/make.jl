using UnivariateUnimodalHighestDensityRegion
using Optimization
using Documenter

DocMeta.setdocmeta!(UnivariateUnimodalHighestDensityRegion, :DocTestSetup, :(using UnivariateUnimodalHighestDensityRegion); recursive=true)

makedocs(;
    modules=[UnivariateUnimodalHighestDensityRegion],
    authors="JoelTrent <79883375+JoelTrent@users.noreply.github.com> and contributors",
    repo="https://github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/blob/{commit}{path}#{line}",
    sitename="UnivariateUnimodalHighestDensityRegion.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JoelTrent.github.io/UnivariateUnimodalHighestDensityRegion.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl",
    devbranch="main",
)
