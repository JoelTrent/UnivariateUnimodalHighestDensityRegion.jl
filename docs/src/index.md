```@meta
CurrentModule = UnivariateUnimodalHighestDensityRegion
```

# UnivariateUnimodalHighestDensityRegion

```@index
```

A simple package for computing the highest density region of a univariate distribution defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). It is only intended for use on unimodal distributions as the package assumes that there is a single, connected, highest density region. Both continuous and discrete distributions work as expected. The exported function will not error on bimodal distributions, but it will not identify the correct highest density regions. 

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

There is a single exported function, [`univariate_unimodal_HDR`](@ref), which is used with univariate distributions from [Distributions.jl](https://juliastats.org/Distributions.jl/stable/).

## Examples using the grid-based approach

After loading the package using the previous command we can find the highest density region of univariate distributions. Finding the 95% HDR of a `Normal` distribution will return the 2.5% and 97.5% quantiles; note, the distribution is symmetric so the method is unnecessary.
```@example
using UnivariateUnimodalHighestDensityRegion # hide
univariate_unimodal_HDR(Normal(0,2), 0.95)
```

The function is most valuable for asymmetric distributions such as a `LogNormal` or `Poisson` distribution:
```@example
using UnivariateUnimodalHighestDensityRegion # hide
univariate_unimodal_HDR(LogNormal(1,0.5), 0.95)
```
```@example
using UnivariateUnimodalHighestDensityRegion # hide
univariate_unimodal_HDR(Poisson(4), 0.95)
```

## Examples using the optimization-based approach

Repeating the previous examples with the optimization approach requires loading [Optimization.jl](https://docs.sciml.ai/Optimization/stable/) and an additional package that contains optimization algorithms. Here we use [OptimizationNLopt.jl](https://docs.sciml.ai/Optimization/stable/optimization_packages/nlopt/). If they have not yet been installed they will also need to be installed using `Pkg.add`.

```julia
using Pkg
Pkg.add(["Optimization", "OptimizationNLopt"])
using Optimization, OptimizationNLopt
solver = NLopt.LN_BOBYQA()
```

```@example
using UnivariateUnimodalHighestDensityRegion # hide
using Optimization # hide
using OptimizationNLopt # hide
solver = NLopt.LN_BOBYQA() # hide
univariate_unimodal_HDR(Normal(0,2), 0.95, solver)
```

The function is most valuable for asymmetric distributions such as a `LogNormal` or `Poisson` distribution:
```@example
using UnivariateUnimodalHighestDensityRegion # hide
using Optimization # hide
using OptimizationNLopt # hide
solver = NLopt.LN_BOBYQA() # hide
univariate_unimodal_HDR(LogNormal(1,0.5), 0.95, solver)
```

```@example
using UnivariateUnimodalHighestDensityRegion # hide
using Optimization # hide
using OptimizationNLopt # hide
solver = NLopt.LN_BOBYQA() # hide
univariate_unimodal_HDR(Poisson(4), 0.95, solver)
```