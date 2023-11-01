using Revise
using UnivariateUnimodalHighestDensityRegion
using Test
using Optimization, OptimizationNLopt

function isapprox_testing(vec1::AbstractVector{<:Real}, vec2::AbstractVector{<:Real})
    return isapprox(vec1, vec2, atol=1e-6)
end

function isapprox_testing(x1::Real, x2::Real)
    return isapprox(x1, x2, atol=0.01*x2)
end

@testset "UnivariateUnimodalHighestDensityRegion.jl" begin

    default_solver = NLopt.LN_BOBYQA()

    @testset "SymmetricDistributionsTest" begin
        
        for d in [Normal(0,1), Normal(10, 4), LogitNormal(0, 0.5), Beta(1.5, 1.5)]
            for region in 0.05:0.05:0.95
                
                interval = quantile(d, [(1.0-region) / 2, 1. - ((1.0-region) / 2.)])
                hdr_interval = univariate_unimodal_HDR(d, region)    
                @test isapprox_testing(interval, hdr_interval)
                hdr_interval = univariate_unimodal_HDR(d, region, 100)
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

        @test_throws DomainError univariate_unimodal_HDR(d, 0.5, -1.0)

        @test isapprox_testing([0.0, 0.0], univariate_unimodal_HDR(d, 0))
        @test isapprox_testing([0.0, 0.0], univariate_unimodal_HDR(d, 0, default_solver))
        @test isapprox_testing([-Inf, Inf], univariate_unimodal_HDR(d, 1))
        @test isapprox_testing([-Inf, Inf], univariate_unimodal_HDR(d, 1, default_solver))
    end

    @testset "AsymmetricDistributionsMethodsConsistent" begin

        for d in [LogNormal(1, 0.5), LogitNormal(-1, 0.6), LogitNormal(2, 0.5), Beta(1.3, 1.5), Beta(1.5, 1.3), Gamma(3,2), Gamma(1,10), Gamma(10,2), Binomial(10, 0.5), Binomial(100,0.7)]
            for region in 0.01:0.01:0.99
                hdr_interval_heuristic = univariate_unimodal_HDR(d, region, 0.00001)
                hdr_interval_stepped = univariate_unimodal_HDR(d, region, 201)
                hdr_interval_optimised = univariate_unimodal_HDR(d, region, default_solver; solve_kwargs=(xtol_abs=0.000001,))

                @test isapprox_testing(hdr_interval_heuristic, hdr_interval_optimised) || isapprox_testing(diff(hdr_interval_heuristic)[1], diff(hdr_interval_optimised)[1])
                if !(isapprox_testing(hdr_interval_heuristic, hdr_interval_optimised) || isapprox_testing(diff(hdr_interval_heuristic)[1], diff(hdr_interval_optimised)[1]))
                    println(d)
                    println(region)
                    println(hdr_interval_heuristic)
                    println(hdr_interval_optimised)
                    println(diff(hdr_interval_heuristic)[1])
                    println(diff(hdr_interval_optimised)[1])
                    println(isapprox_testing(diff(hdr_interval_heuristic)[1], diff(hdr_interval_optimised)[1]))
                end

                @test isapprox_testing(hdr_interval_stepped, hdr_interval_optimised) || isapprox_testing(diff(hdr_interval_stepped)[1], diff(hdr_interval_optimised)[1])
                if !(isapprox_testing(hdr_interval_stepped, hdr_interval_optimised) || isapprox_testing(diff(hdr_interval_stepped)[1], diff(hdr_interval_optimised)[1]))
                    println(d)
                    println(region)
                    println(hdr_interval_stepped)
                    println(hdr_interval_optimised)
                    println(diff(hdr_interval_stepped)[1])
                    println(diff(hdr_interval_optimised)[1])
                    println(isapprox_testing(diff(hdr_interval_heuristic)[1], diff(hdr_interval_optimised)[1]))
                end

            end
        end
    end
end
