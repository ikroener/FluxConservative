module FluxConservative

using GeoStats
using Distances
using GeometryBasics
using EarCut

import GeoStatsBase: solve

include("helper.jl")
include("areas/euclidean.jl")
include("areas/haversine.jl")

export FluxConservWeights
export AreaEuclidean
export AreaHaversine

@estimsolver FluxConservWeights begin
        @param order = 1
        @param area = AreaHaversine()
end

function GeoStatsBase.solve(problem::EstimationProblem, solver::FluxConservWeights)
        @assert isa(problem.sdomain,RegularGrid) "For the moment only RegularGrids are supported \n Please check your input"
        @assert isa(problem.sdata.domain,RegularGrid) "For the moment only RegularGrids are supported \n Please check your input"

        pdata=data(problem)

        ### Estimate grid corners....
        dst_bounds=getCorners(problem.sdomain)
        src_bounds=getCorners(problem.sdata.domain)

        areacella=EstCellAreas(dst_bounds,src_bounds,solver.vparams[solver.varnames[1]].area)

        out=[]
        for (var, V) in variables(problem)

                varparams=solver.vparams[var]
                outdata=zeros(npoints(problem.sdomain))

                for i in areacella
                        outdata[i[1]]=sum(pdata[var][i[2]] .* i[3])
                end
                push!(out,var => outdata)
        end
        out=Dict(out)

        EstimationSolution(domain(problem),out,out)

end

end # module
