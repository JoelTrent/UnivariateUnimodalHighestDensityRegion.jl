module UnivariateUnimodalHighestDensityRegion

using Reexport
@reexport using Distributions, StaticArrays

export univariate_unimodal_HDR

"""
    univariate_unimodal_HDR(d::UnivariateDistribution, region::Real, lr_atol::Float64=0.0001)

This is a bisection-esque heuristic to find the highest density region (HDR) of a univariate, unimodal distribution. For guarantees that the true HDR is found, use the optimisation based version of this function. For discrete distributions, the step-wise version may be more appropriate. Returns the found HDR interval as a vector with length two.

# Arguments
- `d`: a `UnivariateDistribution` defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). 
- `region`: a real number ∈ [0, 1] specifying the proportion of the density of `d` of the highest density region. 
- `lr_atol`: the absolute tolerance between the quantile of the left and right side of the bracket used to determine algorithm convergence. Default is `0.0001`.
"""
function univariate_unimodal_HDR(d::UnivariateDistribution, region::Real, lr_atol::Float64=0.0001)

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
    lr_atol > 0.0 || throw(DomainError("lr_atol must be strictly positive"))

    # bisection-esque approach
    l = 0.0
    r = 1.0 - region
    c = (r - l) / 2.0

    l_interval = SA[quantile(d, l), quantile(d, l + region)]
    r_interval = SA[quantile(d, r), quantile(d, 0.999999999999)]
    l_width = l_interval[2] - l_interval[1]
    r_width = r_interval[2] - r_interval[1]

    if l_width < r_width
        current_best = l * 1.0
        current_width = l_width * 1.0
        current_interval = l_interval .* 1
        explore_left = true
    else
        current_best = r * 1.0
        current_width = r_width * 1.0
        current_interval = r_interval .* 1
        explore_left = false
    end

    while (r - l) > lr_atol
        c_interval = SA[quantile(d, c), quantile(d, c + region)]
        c_width = c_interval[2] - c_interval[1]

        if c_width < current_width
            current_interval = c_interval
            current_width = c_width
            current_best = c * 1.0
        end

        if explore_left
            r = c * 1.0
            r_width = c_width
            if l_width < r_width
                explore_left = true
            else
                explore_left = false
            end
        else
            l = c * 1.0
            l_width = c_width
            if l_width < r_width
                explore_left = true
            else
                explore_left = false
            end
        end
        c = ((r - l) / 2.0) + l
    end

    return current_interval
end

"""
    univariate_unimodal_HDR(d::UnivariateDistribution, region::Real, num_steps::Int)

A step-wise approach to find the highest density region (HDR) of a univariate, unimodal distribution. Returns the found HDR interval as a vector with length two.

# Arguments
- `d`: a `UnivariateDistribution` defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). 
- `region`: a real number ∈ [0, 1] specifying the proportion of the density of `d` of the highest density region. 
- `num_steps`: the number of steps to linearly space between the left and right of the bracket, inclusive, where `l=0.0` and `r=1.0-region`. The lower and upper quantiles, `region` apart, at each of these steps is then calculated, with the minimum distance between the lower and upper quantile across all steps used to determine the step with an interval estimated to be the HDR. Is enforced to be at least 3 and odd.
"""
function univariate_unimodal_HDR(d::UnivariateDistribution, region::Real, num_steps::Int)

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
    num_steps = max(3, num_steps)
    if iseven(num_steps); num_steps+=1 end

    l = 0.0
    r = 1.0 - region

    steps_lower = LinRange(l, r, num_steps)
    steps_upper = LinRange(1.0-r, 1.0, num_steps)
    
    lower_vals = quantile(d, steps_lower)
    upper_vals = quantile(d, steps_upper)

    i = argmin(upper_vals .- lower_vals)

    return SA[lower_vals[i], upper_vals[i]]
end

if !isdefined(Base, :get_extension)
    using Requires
end

@static if !isdefined(Base, :get_extension)
    function __init__()
        @require Optimization = "7f7a1694-90dd-40f0-9382-eb1efda571ba" include("../ext/UnivariateUnimodalHighestDensityRegionExt.jl")
    end
end

end
