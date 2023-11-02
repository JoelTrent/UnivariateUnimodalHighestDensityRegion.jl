module UnivariateUnimodalHighestDensityRegionExt

using UnivariateUnimodalHighestDensityRegion
using Optimization

"""
    _univariate_unimodal_HDR(d::DiscreteUnivariateDistribution, 
        region::Real, 
        solve_alg, 
        solve_kwargs::NamedTuple)

Optimization-based approach on discrete distributions.
"""
function UnivariateUnimodalHighestDensityRegion._univariate_unimodal_HDR(d::DiscreteUnivariateDistribution,
        region::Real, 
        solve_alg, 
        solve_kwargs::NamedTuple)

    p = (d=d, region=region, interval=@MVector zeros(Int, 2))

    function fun(l, p)
        if isapprox(1.0, min(1.0, l[1] + p.region), atol=1e-8) && isinf(maximum(d))
            p.interval .= quantile(p.d, l[1]), typemax(p.interval[2])
            return p.interval[2] - p.interval[1]
        end

        p.interval .= quantile(p.d, l[1]), quantile(p.d, min(1.0, l[1] + p.region))
        return p.interval[2] - p.interval[1]
    end

    fopt = OptimizationFunction(fun)
    prob = OptimizationProblem(fopt, [(1.0 - region) / 2.0], p; lb=[0.0], ub=[1.0 - region], solve_kwargs...)
    sol = solve(prob, solve_alg)

    fun(sol.u, p)
    return p.interval
end

"""
    _univariate_unimodal_HDR(d::ContinuousUnivariateDistribution, 
        region::Real, 
        solve_alg, 
        solve_kwargs::NamedTuple)

Optimization-based approach on continuous distributions.
"""
function UnivariateUnimodalHighestDensityRegion._univariate_unimodal_HDR(d::ContinuousUnivariateDistribution,
        region::Real, 
        solve_alg, 
        solve_kwargs::NamedTuple)

    p = (d=d, region=region, interval=@MVector zeros(2))

    function fun(l, p)
        p.interval .= quantile(p.d, l[1]), quantile(p.d, min(1.0, l[1] + p.region))
        if any(isinf.(p.interval))
            return 1e100
        end
        return p.interval[2] - p.interval[1]
    end

    fopt = OptimizationFunction(fun)
    prob = OptimizationProblem(fopt, [(1.0 - region) / 2.0], p; lb=[0.0], ub=[1.0 - region], solve_kwargs...)
    sol = solve(prob, solve_alg)

    fun(sol.u, p)
    return p.interval
end

"""
    univariate_unimodal_HDR(d::UnivariateDistribution, 
        region::Real,
        solve_alg; 
        solve_kwargs::NamedTuple=(reltol = 0.0001,))

This is an optimization-based approach to find the highest density region (HDR) of a univariate, unimodal distribution. The grid-based approach may be more robust for discrete distributions. Returns the found HDR interval as a vector with length two.

Requires loading [Optimization.jl](https://docs.sciml.ai/Optimization/stable/) and an additional package that contains optimization algorithms: [OptimizationNLopt.jl](https://docs.sciml.ai/Optimization/stable/optimization_packages/nlopt/) may be a good starting point.

# Arguments
- `d`: a `UnivariateDistribution` defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). 
- `region`: a real number ∈ [0, 1] specifying the proportion of the density of `d` of the highest density region. 
- `solve_alg`: an algorithm to use to solve for the highest density region defined within [Optimization.jl](https://docs.sciml.ai/Optimization/stable/). Good starting methods from `NLopt` may be `NLopt.LN_BOBYQA()`, `NLopt.LN_NELDERMEAD()` and `NLopt.LD_LBFGS`. Other packages can be used as well - see [Overview of the Optimizers](https://docs.sciml.ai/Optimization/stable/#Overview-of-the-Optimizers).

# Keyword Arguments
- `solve_kwargs`: a `NamedTuple` of keyword arguments used to set solver options like `reltol`. Other arguments can be used, but the default of `(reltol = 0.0001,)` is expected to be sufficient. For a list of common solver arguments see: [Common Solver Options](https://docs.sciml.ai/Optimization/stable/API/solve/#Common-Solver-Options-(Solve-Keyword-Arguments)). Other specific package arguments may also be available. For NLopt see [Methods](https://docs.sciml.ai/Optimization/stable/optimization_packages/nlopt/#Methods).
"""
function UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDR(d::UnivariateDistribution,
        region::Real, 
        solve_alg; 
        solve_kwargs::NamedTuple=(reltol = 0.00001,))

    if !(0.0 < region && region < 1.0)
        return UnivariateUnimodalHighestDensityRegion.region_handling(d, region)
    end
    return UnivariateUnimodalHighestDensityRegion._univariate_unimodal_HDR(d, region, solve_alg, solve_kwargs)
end

end