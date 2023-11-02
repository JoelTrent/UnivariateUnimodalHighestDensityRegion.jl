# UnivariateUnimodalHighestDensityRegion

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JoelTrent.github.io/UnivariateUnimodalHighestDensityRegion.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JoelTrent.github.io/UnivariateUnimodalHighestDensityRegion.jl/dev/)
[![Build Status](https://github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JoelTrent/UnivariateUnimodalHighestDensityRegion.jl)

# Description

A simple package for computing the [highest density region](https://doi.org/10.2307/2684423) of a univariate distribution defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). It is only intended for use on unimodal distributions as the package assumes that there is a single, connected, highest density region. Both continuous and discrete distributions are supported. However, the assumptions of the method may break down for discrete distributions; the method of [O'Neill (2022)](https://doi.org/10.1007/s00180-021-01172-6) may be more appropriate. This can be seen in the occasional inconsistency by width 1 between the HDR found by the grid-based and optimization-based approaches. The exported function will not error on bimodal distributions, but it will not identify the correct highest density regions. 

A grid-based approach and optimization-based approach are implemented. The optimisation approach will, in general, require fewer distribution quantile evaluations for the same level of accuracy. However, it requires loading [Optimization.jl](https://docs.sciml.ai/Optimization/stable/) and therefore requires more memory.

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

There is a single exported function, `univariate_unimodal_HDR`, which is used with univariate distributions from [Distributions.jl](https://juliastats.org/Distributions.jl/stable/).

## Examples using the grid-based approach

After loading the package using the previous command we can find the highest density region of univariate distributions. Finding the 95% HDR of a `Normal` distribution will return the 2.5% and 97.5% quantiles; note, the distribution is symmetric so the method is unnecessary.
```@julia
univariate_unimodal_HDR(Normal(0,2), 0.95)

2-element MVector{2, Float64} with indices SOneTo(2):
 -3.919927969080115
  3.919927969080115
```

The function is most valuable for asymmetric distributions such as a `LogNormal` or `Poisson` distribution:
```@julia
univariate_unimodal_HDR(LogNormal(1,0.5), 0.95)
2-element MVector{2, Float64} with indices SOneTo(2):
 0.721779994018427
 6.312112357076725
```
```@julia
univariate_unimodal_HDR(Poisson(4), 0.95)
2-element MVector{2, Int64} with indices SOneTo(2):
 1
 8
```

## Examples using the optimization-based approach

Repeating the previous examples with the optimization approach requires loading [Optimization.jl](https://docs.sciml.ai/Optimization/stable/) and an additional package that contains optimization algorithms. Here we use [OptimizationNLopt.jl](https://docs.sciml.ai/Optimization/stable/optimization_packages/nlopt/). If they have not yet been installed they will also need to be installed using `Pkg.add`.

```julia
using Pkg
Pkg.add(["Optimization", "OptimizationNLopt"])
using Optimization, OptimizationNLopt
solver = NLopt.LN_BOBYQA()
```

`Normal`:
```@julia
univariate_unimodal_HDR(Normal(0,2), 0.95, solver)
2-element MVector{2, Float64} with indices SOneTo(2):
 -3.919927969080115
  3.919927969080115
```

`LogNormal`:
```@julia
univariate_unimodal_HDR(LogNormal(1,0.5), 0.95, solver)
```

`Poisson`:
```@julia
univariate_unimodal_HDR(Poisson(4), 0.95, solver)
```