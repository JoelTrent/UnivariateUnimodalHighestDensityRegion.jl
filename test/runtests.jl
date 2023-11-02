using UnivariateUnimodalHighestDensityRegion
using Test
using Optimization, OptimizationNLopt

function isapprox_testing(vec1::AbstractVector{<:Real}, vec2::AbstractVector{<:Real})
    return isapprox(vec1, vec2, atol=1e-6)
end

function isapprox_testing(x1::Real, x2::Real)
    return isapprox(x1, x2, atol=0.0001*x2)
end

@testset "UnivariateUnimodalHighestDensityRegion.jl" begin
    default_solver = NLopt.LN_BOBYQA()

    @testset "SymmetricDistributionsTest" begin
        for d in [Normal(0,1), Normal(10, 4), LogitNormal(0, 0.5), Beta(1.5, 1.5)]
            for region in 0.01:0.01:0.99
                
                interval = quantile.(d, [(1.0-region) / 2, 1. - ((1.0-region) / 2.)])
                hdr_interval = univariate_unimodal_HDR(d, region)    
                @test isapprox_testing(interval, hdr_interval)

                hdr_interval = univariate_unimodal_HDR(d, region, default_solver; solve_kwargs=(xtol_abs=0.000001,))
                @test isapprox_testing(interval, hdr_interval)
            end
        end
    end

    @testset "ExtremeRegionTest" begin
        d = Normal(0, 1)
        @test_throws DomainError univariate_unimodal_HDR(d,-1)
        @test_throws DomainError univariate_unimodal_HDR(d, 2)
        @test_throws DomainError univariate_unimodal_HDR(d,-1, default_solver)
        @test_throws DomainError univariate_unimodal_HDR(d, 2, default_solver)

        @test isapprox_testing([0.0, 0.0], univariate_unimodal_HDR(d, 0))
        @test isapprox_testing([0.0, 0.0], univariate_unimodal_HDR(d, 0, default_solver))
        @test isapprox_testing([-Inf, Inf], univariate_unimodal_HDR(d, 1))
        @test isapprox_testing([-Inf, Inf], univariate_unimodal_HDR(d, 1, default_solver))
    end

    @testset "AsymmetricContinuousDistributionsMethodsConsistent" begin
        for d in [LogNormal(1, 0.5), LogitNormal(-1, 0.6), LogitNormal(2, 0.5), Beta(1.3, 1.5), 
                Beta(1.5, 1.3), Gamma(3,2), Gamma(1,10), Gamma(10,2)]
            for region in 0.01:0.01:0.99
                hdr_interval_gridded = univariate_unimodal_HDR(d, region, 201)
                hdr_interval_optimised = univariate_unimodal_HDR(d, region, default_solver; solve_kwargs=(xtol_abs=0.000001,))

                symmetric_interval_width = diff(quantile.(d, [(1.0-region)/2., 1.0-(1.0-region)/2.]))[1]

                @test diff(hdr_interval_gridded)[1] ≤ symmetric_interval_width
                @test diff(hdr_interval_optimised)[1] ≤ symmetric_interval_width

                @test isapprox_testing(hdr_interval_gridded, hdr_interval_optimised) || isapprox_testing(diff(hdr_interval_gridded)[1], diff(hdr_interval_optimised)[1])
            end
        end
    end

    @testset "AsymmetricDiscreteDistributionsMethodsConsistent" begin
        for d in [Poisson(4), Poisson(20), Poisson(500), Binomial(10, 0.5), Binomial(100,0.7)]
            for region in 0.01:0.01:0.99
                hdr_interval_gridded = univariate_unimodal_HDR(d, region, 201)
                hdr_interval_optimised = univariate_unimodal_HDR(d, region, default_solver; solve_kwargs=(xtol_abs=0.000001,))

                symmetric_interval_width = diff(quantile.(d, [(1.0-region)/2., 1.0-(1.0-region)/2.]))[1]

                @test diff(hdr_interval_gridded)[1] ≤ symmetric_interval_width
                @test diff(hdr_interval_optimised)[1] ≤ symmetric_interval_width

                @test isapprox_testing(hdr_interval_gridded, hdr_interval_optimised) || abs(diff(hdr_interval_gridded)[1] - diff(hdr_interval_optimised)[1]) in [0,1]
            end
        end
    end    
end
