module FluxConservative

using GeoStats

import GeoStatsBase: solve

include("helper.jl")

export FluxConservWeights


@estimsolver FluxConservWeights begin
        @param order = 1
#        @param distance = Distances.Haversine(6731.)
end

function GeoStatsBase.solve(problem::EstimationProblem, solver::FluxConservWeights)
        pdata=data(problem)

        ### Estimate grid corners....
        dst_bounds=getCorners(problem.sdomain)
        src_bounds=getCorners(problem.sdata.domain)

        areacella=EstCellAreas(dst_bounds,src_bounds)

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
