module FluxConservative

using Distances, GeoStats

import GeoStatsBase: solve

export FluxConservWeights

@estimsolver FluxConservWeights begin
#        @param order = 1
#        @param distance = Distances.Haversine(6731.)
end

#.... This will be useful for extending the FluxConservWeight to non global grids
#function preprocess(problem::EstimationProblem,solver::FluxConservWeights)
#        pdomain = domain(problem)

#        preproc = Dict{Symbol,NamedTuple}()

#        for (var, V) in variables(problem)

#        end
#end

function GeoStatsBase.solve(problem::EstimationProblem, sovler::FluxConservWeights)
## For rectangular, gaussian grids, it is sophisticated to estimate
## spatial area weights by the cosine of latitude
        pdata=data(problem)

        lat=problem.sdata.domain.coords[2,:]
        ## deg2rad
        areacella=cosd.(lat)
        areacella./=sum(areacella)

        areacella = reshape(areacella,size(pdata))

        out=[]
        for (var, V) in variables(problem)
                tmp=sum(areacella.*pdata[var])
                push!(out,var => [tmp])
        end
        out=Dict(out)

        EstimationSolution(domain(problem),out,out)

end

end # module
