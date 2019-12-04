module FluxConservative

using Distances, GeoStats, NetCDF

import GeoStatsBase: solve

export FluxConservWeights

include("./readCDOgrid.jl")

@estimsolver FluxConservWeights begin
        @param order = 1
        @param cdogrid = 0
#        @param distance = Distances.Haversine(6731.)
end

#.... This will be useful for extending the FluxConservWeight to non global grids
#function preprocess(problem::EstimationProblem,solver::FluxConservWeights)
#        pdomain = domain(problem)

#        preproc = Dict{Symbol,NamedTuple}()

#        for (var, V) in variables(problem)

#        end
#end

function GeoStatsBase.solve(problem::EstimationProblem, solver::FluxConservWeights)
## For rectangular, gaussian grids, it is sophisticated to estimate
## spatial area weights by the cosine of latitude
        pdata=data(problem)

        out=[]
        for (var, V) in variables(problem)

                varparams=solver.params[var]

                if varparams.cdogrid == 0
                        # IF no CDOgrid is given we want to derive this
                        # information, store it, and ideally update the solver
                        # the update could be helpful for multiple runs
                        # e.g. over different time steps, but with constant
                        # input points...

                        ## FOR THE MOMENT....
                        ## IF NO CDO GRID IS GIVEN A GLOBALMEAN WITH
                        ## LATITUDINAL WEIGHTS WILL BE ESTIMATED...
                        lat=problem.sdata.domain.coords[2,:]
                        ## This could be problematic, find an other way

                        ## rad2deg!
                        areacella=cosd.(lat)
                        areacella./=sum(areacella)

                        tmp=sum(areacella[1:end].*pdata[var][1:end])
                        push!(out,var => [tmp])
                else
                        @info "Still experimental... and slow"
                        vdata=pdata[var]
                        #dst,src,remapmat,dst_lon,dst_lat
                        dst=copy(varparams.cdogrid["dst_address"])
                        src=copy(varparams.cdogrid["src_address"])
                        remapmat=copy(varparams.cdogrid["remap_matrix"])

                        tmp=zeros(npoints(domain(problem))).+0.0

                        ## Here happens the actual remapping
                        for i in unique(dst)
                                sel=findall(dst .== i)
                                tmp[i]=remapmat[1,sel]' * vdata[src[sel]]
                        end
                        push!(out,var => tmp)
                end
        end
        out=Dict(out)

        EstimationSolution(domain(problem),out,out)

end

end # module
