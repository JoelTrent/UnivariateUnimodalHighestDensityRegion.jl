module UnivariateUnimodalHighestDensityRegion

using Reexport
@reexport using Distributions, StaticArrays

export univariate_unimodal_HDR

"""
    region_handling(d::UnivariateDistribution, region::Real)

Handles values of `region` that are not between 0 and 1.

If region is equal to 0.0, the mode of the distribution will be returned, if defined, else the median will be returned. These are returned as a vector of length 2.

If region is equal to 1.0, the minimum and maximum of the distribution will be returned.

If region is less than 0.0 or greater than 1.0, a `DomainError` will be thrown.
"""
function region_handling(d::UnivariateDistribution, region::Real)
    if region == 0.0
        try
            mode_d = mode(d)
            return SA[mode_d, mode_d]
        catch
            med_d = median(d)
            return SA[med_d, med_d]
        end
    end
    if region == 1.0
        return SA[minimum(d), maximum(d)]
    end

    throw(DomainError("region must be ∈ [0.0, 1.0]"))
    return nothing
end

"""
    univariate_unimodal_HDR(d::UnivariateDistribution, region::Real, num_steps::Int)

A grid-based approach to find the highest density region (HDR) of a univariate, unimodal distribution. Returns the found HDR interval as a vector with length two.

# Arguments
- `d`: a `UnivariateDistribution` defined in [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). 
- `region`: a real number ∈ [0, 1] specifying the proportion of the density of `d` of the highest density region. 
- `num_steps`: the number of steps to linearly space between the left and right of the bracket, inclusive, where `l=0.0` and `r=1.0-region`. The lower and upper quantiles, `region` apart, at each of these steps is then calculated. The the lower and upper quantile at these steps with the minimum distance between them is estimated to be the HDR. `num_steps` is enforced to be at least 3 and odd to allow exact accuracy on symmetric distributions.
"""
function univariate_unimodal_HDR(d::UnivariateDistribution, region::Real, num_steps::Int=51)

    if !(0.0 < region && region < 1.0)
        return region_handling(d, region)
    end

    num_steps = max(3, num_steps)
    if iseven(num_steps); num_steps+=1 end

    l = 0.0
    r = 1.0-region

    steps_lower = LinRange(l, r, num_steps)
    steps_upper = LinRange(1.0-r, 1.0, num_steps)

    best_width=Inf
    best_interval=@MVector zeros(ifelse(d isa ContinuousUnivariateDistribution, Float64, Int), 2)
    lower, upper, width = 0.0, 0.0, 0.0

    if isinf(maximum(d)) && d isa DiscreteUnivariateDistribution
        for i in eachindex(steps_lower)
            lower = quantile(d, steps_lower[i])
            if steps_upper[i] == 1.0
                upper = typemax(Int)
            else
                upper = quantile(d, steps_upper[i])
            end
            width = upper - lower

            if width < best_width
                best_width = width
                best_interval .= lower, upper
            end
        end
        return best_interval
    end

    for i in eachindex(steps_lower)
        lower = quantile(d, steps_lower[i])
        upper = quantile(d, steps_upper[i])
        width = upper-lower

        if width < best_width
            best_width=width
            best_interval .= lower, upper
        end
    end
    
    return best_interval
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
