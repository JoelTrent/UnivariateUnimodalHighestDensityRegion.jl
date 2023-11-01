# UnivariateUnimodalHighestDensityRegion

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JoelTrent.github.io/UnivariateUnimodalHighestDensityRegion.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JoelTrent.github.io/UnivariateUnimodalHighestDensityRegion.jl/dev/)
[![Build Status](https://github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl)

# Description

A lightweight package for computing the highest density region of a univariate distribution defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). It is only intended for use on unimodal distributions as the package assumes that there is a single, connected, highest density region. Both continuous and discrete distributions work as expected. The two exported functions will not error on bimodal distributions, but they will not identify the correct highest density regions. 

This is a performant alternative to [HighestDensityRegions.jl](https://github.com/tpapp/HighestDensityRegions.jl) when the distribution of interest is univariate and unimodal.

## Getting Started: Installation And First Steps

To install the package, use the following command inside the Julia REPL:

```julia
using Pkg
Pkg.add("UnivariateUnimodalHighestDensityRegion")
```

To load the package, use the command:

```julia
using UnivariateUnimodalHighestDensityRegion
```
