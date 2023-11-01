module UnivariateUnimodalHighestDensityRegionExt

using UnivariateUnimodalHighestDensityRegion
using Optimization

"""
    UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDR(d::UnivariateDistribution, 
        region::Real,
        solve_alg; 
        solve_kwargs::NamedTuple=(xtol_abs = 0.00001,))

This is an optimisation-based approach to find a highest density region (HDR) of a univariate, unimodal distribution. Testing indicates that this approach more robustly finds the HDR than the other approach. Returns the found HDR interval as a vector with length two.

# Arguments
- `d`: a `UnivariateDistribution` defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). 
- `region`: a real number ∈ [0, 1] specifying the proportion of the density of `d` of the highest density region. 
- `solve_alg`: an algorithm to use to solve for the highest density region defined within [Optimization.jl](https://docs.sciml.ai/Optimization/stable/). Requires loading an additional package that contains optimization algorithms, [OptimizationNLopt](https://docs.sciml.ai/Optimization/stable/optimization_packages/nlopt/) may be a good starting point. Good starting methods from NLopt may be `NLopt.LN_BOBYQA()`, `NLopt.LN_NELDERMEAD()` and `NLopt.LD_LBFGS`. Other packages can be used as well - see [Overview of the Optimizers](https://docs.sciml.ai/Optimization/stable/#Overview-of-the-Optimizers).

# Keyword Arguments
- `solve_kwargs`: a `NamedTuple` of keyword arguments used to set solver options like `xtol_abs`. Other arguments can be used, but the default of `(xtol_abs = 0.00001,)` is expected to be sufficient. For a list of common solver arguments see: [Common Solver Options](https://docs.sciml.ai/Optimization/stable/API/solve/#Common-Solver-Options-(Solve-Keyword-Arguments)). Other specific package arguments may also be available. For NLopt see [Methods](https://docs.sciml.ai/Optimization/stable/optimization_packages/nlopt/#Methods).
"""
function UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDR(d::UnivariateDistribution,
        region::Real, 
        solve_alg; 
        solve_kwargs::NamedTuple=(xtol_abs = 0.00001,))

    if region < 0.0 || region > 1.0
        throw(DomainError("region must be ∈ [0.0, 1.0]"))
        return nothing
    end
    if region == 0.0
        mode_d = mode(d)
        return SA[mode_d, mode_d]
    end
    if region == 1.0
        support_d = support(d)
        return SA[support_d.lb, support_d.ub]
    end

    p = (d=d, region=region, interval=zeros(d isa ContinuousUnivariateDistribution ? Float64 : Int, 2))

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

end