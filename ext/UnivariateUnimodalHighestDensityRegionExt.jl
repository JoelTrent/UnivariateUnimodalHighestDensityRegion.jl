module UnivariateUnimodalHighestDensityRegionExt

using UnivariateUnimodalHighestDensityRegion
using Distributions, StaticArrays
using Optimization

"""
    UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDRs(d::UnivariateDistribution, 
        region::Real,
        alg::SciMLBase.AbstractOptimizationAlgorithm; 
        solve_kwargs::NamedTuple=(xtol_abs = 0.00001,))
"""
function UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDR(d::UnivariateDistribution,
        region::Real, 
        alg::SciMLBase.AbstractOptimizationAlgorithm; 
        solve_kwargs::NamedTuple=(xtol_abs = 0.00001,))

    if region < 0.0 || region > 1.0
        throw(ArgumentError("region must be ∈ [0.0, 1.0]"))
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
    sol = solve(prob, alg)

    fun(sol.u, p)
    return p.interval
end

end