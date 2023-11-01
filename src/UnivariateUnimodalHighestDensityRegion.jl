module UnivariateUnimodalHighestDensityRegion

using Reexport
@reexport using Distributions, StaticArrays

export univariate_unimodal_HDR

"""
    univariate_unimodal_HDR(d::UnivariateDistribution, region::Real)
"""
function univariate_unimodal_HDR(d::UnivariateDistribution, region::Real)

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

    while (r - l) > 0.0001
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

if !isdefined(Base, :get_extension)
    using Requires
end

@static if !isdefined(Base, :get_extension)
    function __init__()
        @require Optimization = "7f7a1694-90dd-40f0-9382-eb1efda571ba" include("../ext/UnivariateUnimodalHighestDensityRegionExt.jl")
    end
end

end
