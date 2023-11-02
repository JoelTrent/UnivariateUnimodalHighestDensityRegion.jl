using UnivariateUnimodalHighestDensityRegion
using Optimization
using OptimizationNLopt
using Documenter

DocMeta.setdocmeta!(UnivariateUnimodalHighestDensityRegion, :DocTestSetup, :(using UnivariateUnimodalHighestDensityRegion); recursive=true)

makedocs(;
    modules=[UnivariateUnimodalHighestDensityRegion,
            isdefined(Base, :get_extension) ? Base.get_extension(UnivariateUnimodalHighestDensityRegion, :UnivariateUnimodalHighestDensityRegionExt) :
            Manifolds.UnivariateUnimodalHighestDensityRegionExt],
    authors="JoelTrent <79883375+JoelTrent@users.noreply.github.com> and contributors",
    sitename="UnivariateUnimodalHighestDensityRegion.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JoelTrent.github.io/UnivariateUnimodalHighestDensityRegion.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "User Interface" => "user_interface.md",
        "Internal API" => "internal_api.md"
    ],
    warnonly=true
)

deploydocs(;
    repo="github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl",
    devbranch="main",
)
