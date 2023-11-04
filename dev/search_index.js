var documenterSearchIndex = {"docs":
[{"location":"references/#References","page":"References","title":"References","text":"","category":"section"},{"location":"references/","page":"References","title":"References","text":"R. J. Hyndman. Computing and Graphing Highest Density Regions. The American Statistician 50, 120–126 (1996).\n\n\n\nB. O'Neill. Smallest covering regions and highest density regions for discrete distributions. Computational Statistics 37, 1229–1254 (2022).\n\n\n\n","category":"page"},{"location":"user_interface/#User-Interface","page":"User Interface","title":"User Interface","text":"","category":"section"},{"location":"user_interface/","page":"User Interface","title":"User Interface","text":"Pages = [\"user_interface.md\"]","category":"page"},{"location":"user_interface/","page":"User Interface","title":"User Interface","text":"univariate_unimodal_HDR","category":"page"},{"location":"user_interface/#UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDR","page":"User Interface","title":"UnivariateUnimodalHighestDensityRegion.univariate_unimodal_HDR","text":"univariate_unimodal_HDR(d::UnivariateDistribution, \n    region::Real,\n    solve_alg; \n    solve_kwargs::NamedTuple=(reltol = 0.0001,))\n\nThis is an optimization-based approach to find the highest density region (HDR) of a univariate, unimodal distribution. The grid-based approach may be more robust for discrete distributions. Returns the found HDR interval as a vector with length two.\n\nRequires loading Optimization.jl and an additional package that contains optimization algorithms: OptimizationNLopt.jl may be a good starting point.\n\nArguments\n\nd: a UnivariateDistribution defined in Distributions.jl. \nregion: a real number ∈ [0, 1] specifying the proportion of the density of d of the highest density region. \nsolve_alg: an algorithm to use to solve for the highest density region defined within Optimization.jl. Good starting methods from NLopt may be NLopt.LN_BOBYQA(), NLopt.LN_NELDERMEAD() and NLopt.LD_LBFGS. Other packages can be used as well - see Overview of the Optimizers.\n\nKeyword Arguments\n\nsolve_kwargs: a NamedTuple of keyword arguments used to set solver options like reltol. Other arguments can be used, but the default of (reltol = 0.0001,) is expected to be sufficient. For a list of common solver arguments see: Common Solver Options. Other specific package arguments may also be available. For NLopt see Methods.\n\n\n\n\n\nunivariate_unimodal_HDR(d::UnivariateDistribution, region::Real, num_steps::Int)\n\nA grid-based approach to find the highest density region (HDR) of a univariate, unimodal distribution. Returns the found HDR interval as a vector with length two.\n\nArguments\n\nd: a UnivariateDistribution defined in Distributions.jl. \nregion: a real number ∈ [0, 1] specifying the proportion of the density of d of the highest density region. \nnum_steps: the number of steps to linearly space between the left and right of the bracket, inclusive, where l=0.0 and r=1.0-region. The lower and upper quantiles, region apart, at each of these steps is then calculated. The the lower and upper quantile at these steps with the minimum distance between them is estimated to be the HDR. num_steps is enforced to be at least 3 and odd to allow exact accuracy on symmetric distributions.\n\n\n\n\n\n","category":"function"},{"location":"internal_api/#Internal-API","page":"Internal API","title":"Internal API","text":"","category":"section"},{"location":"internal_api/","page":"Internal API","title":"Internal API","text":"Pages = [\"internal_api.md\"]","category":"page"},{"location":"internal_api/","page":"Internal API","title":"Internal API","text":"UnivariateUnimodalHighestDensityRegion.region_handling\nUnivariateUnimodalHighestDensityRegion._univariate_unimodal_HDR ","category":"page"},{"location":"internal_api/#UnivariateUnimodalHighestDensityRegion.region_handling","page":"Internal API","title":"UnivariateUnimodalHighestDensityRegion.region_handling","text":"region_handling(d::UnivariateDistribution, region::Real)\n\nHandles values of region that are not between 0 and 1.\n\nIf region is equal to 0.0, the mode of the distribution will be returned, if defined, else the median will be returned. These are returned as a vector of length 2.\n\nIf region is equal to 1.0, the minimum and maximum of the distribution will be returned.\n\nIf region is less than 0.0 or greater than 1.0, a DomainError will be thrown.\n\n\n\n\n\n","category":"function"},{"location":"internal_api/#UnivariateUnimodalHighestDensityRegion._univariate_unimodal_HDR","page":"Internal API","title":"UnivariateUnimodalHighestDensityRegion._univariate_unimodal_HDR","text":"_univariate_unimodal_HDR(d::DiscreteUnivariateDistribution, \n    region::Real, \n    solve_alg, \n    solve_kwargs::NamedTuple)\n\nOptimization-based approach on discrete distributions.\n\n\n\n\n\n_univariate_unimodal_HDR(d::ContinuousUnivariateDistribution, \n    region::Real, \n    solve_alg, \n    solve_kwargs::NamedTuple)\n\nOptimization-based approach on continuous distributions.\n\n\n\n\n\n","category":"function"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = UnivariateUnimodalHighestDensityRegion","category":"page"},{"location":"#UnivariateUnimodalHighestDensityRegion","page":"Home","title":"UnivariateUnimodalHighestDensityRegion","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A simple package for computing the highest density region [1] of a univariate distribution defined in Distributions.jl. It is only intended for use on unimodal distributions as the package assumes that there is a single, connected, highest density region. Both continuous and discrete distributions are supported. However, the assumptions of the method may break down for discrete distributions; the method of Ben O'Neill [2] may be more appropriate. This can be seen in the occasional inconsistency by width 1 between the HDR found by the grid-based and optimization-based approaches. The exported function will not error on bimodal distributions, but it will not identify the correct highest density regions. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"A grid-based approach and optimization-based approach are implemented. The optimisation approach will, in general, require fewer distribution quantile evaluations for the same level of accuracy. However, it requires loading Optimization.jl and therefore requires more memory.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This is a performant alternative to HighestDensityRegions.jl when the distribution of interest is univariate and unimodal.","category":"page"},{"location":"#Getting-Started:-Installation-And-First-Steps","page":"Home","title":"Getting Started: Installation And First Steps","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install the package, use the following command inside the Julia REPL:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Pkg\nPkg.add(\"UnivariateUnimodalHighestDensityRegion\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"To load the package, use the command:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion","category":"page"},{"location":"","page":"Home","title":"Home","text":"There is a single exported function, univariate_unimodal_HDR, which is used with univariate distributions from Distributions.jl.","category":"page"},{"location":"#Examples-using-the-grid-based-approach","page":"Home","title":"Examples using the grid-based approach","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"After loading the package using the previous command we can find the highest density region of univariate distributions. Finding the 95% HDR of a Normal distribution will return the 2.5% and 97.5% quantiles; note, the distribution is symmetric so the method is unnecessary.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion # hide\nunivariate_unimodal_HDR(Normal(0,2), 0.95)","category":"page"},{"location":"","page":"Home","title":"Home","text":"The function is most valuable for asymmetric distributions such as a LogNormal or Poisson distribution:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion # hide\nunivariate_unimodal_HDR(LogNormal(1,0.5), 0.95)","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion # hide\nunivariate_unimodal_HDR(Poisson(4), 0.95)","category":"page"},{"location":"#Examples-using-the-optimization-based-approach","page":"Home","title":"Examples using the optimization-based approach","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Repeating the previous examples with the optimization approach requires loading Optimization.jl and an additional package that contains optimization algorithms. Here we use OptimizationNLopt.jl. If they have not yet been installed they will also need to be installed using Pkg.add.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Pkg\nPkg.add([\"Optimization\", \"OptimizationNLopt\"])\nusing Optimization, OptimizationNLopt\nsolver = NLopt.LN_BOBYQA()","category":"page"},{"location":"","page":"Home","title":"Home","text":"Normal:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion # hide\nusing Optimization # hide\nusing OptimizationNLopt # hide\nsolver = NLopt.LN_BOBYQA() # hide\nunivariate_unimodal_HDR(Normal(0,2), 0.95, solver)","category":"page"},{"location":"","page":"Home","title":"Home","text":"LogNormal:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion # hide\nusing Optimization # hide\nusing OptimizationNLopt # hide\nsolver = NLopt.LN_BOBYQA() # hide\nunivariate_unimodal_HDR(LogNormal(1,0.5), 0.95, solver)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Poisson:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using UnivariateUnimodalHighestDensityRegion # hide\nusing Optimization # hide\nusing OptimizationNLopt # hide\nsolver = NLopt.LN_BOBYQA() # hide\nunivariate_unimodal_HDR(Poisson(4), 0.95, solver)","category":"page"}]
}
