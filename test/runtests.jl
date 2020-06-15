using Test, FluxConservative, GeoStats

## TESTING IS QUIT UNSTRUCTURED AND BRUTAL....
###
@testset "RegularGrid" begin

    @testset "Test Helpers" begin
        @test 1 == 1
    end


    @testset "nothing" begin
        ### remapping to the same grids....
        ### Applies a remapping with the same grid as an output
        ### output should be the input since area weights are always 1
        target=:tas
        dims=(36,18)
        spacings=(360/dims[1],180/dims[2])
        onset=(-180,-90).+spacings./2
        data1=rand(dims[1],dims[2])
        SG=RegularGrid(dims,onset,spacings)

        dims=(36,18)
        spacings=(360/dims[1],180/dims[2])
        onset=(-180,-90).+spacings./2
        data1=rand(dims[1],dims[2])
        SD = RegularGridData(OrderedDict(target => data1),onset,spacings)

        problem = EstimationProblem(SD, SG, target)
        solver = FluxConservWeights(target => (order=1,area=AreaEuclidean()))
        solution = solve(problem, solver)
        out=solution[target]

        @test minimum(data1 .≈ out.mean) ## check if minimum = 1

        problem = EstimationProblem(SD, SG, target)
        solver = FluxConservWeights(target => (order=1,area=AreaHaversine()))
        solution = solve(problem, solver)
        out=solution[target]

        @test minimum(data1 .≈ out.mean) ## check if minimum = 1

    end

    @testset "global" begin
        ### Estimate a global mean with Euclidean Area of Regular Grids...
        ### ... output should be an array mean
        target=:tas
        dims=(1,1)
        spacings=(360/dims[1],180/dims[2])
        onset=(-180,-90).+spacings./2
        data1=rand(dims[1],dims[2])
        SG=RegularGrid(dims,onset,spacings)

        dims=(36,18)
        spacings=(360/dims[1],180/dims[2])
        onset=(-180,-90).+spacings./2
        data1=rand(dims[1],dims[2])
        SD = RegularGridData(OrderedDict(target => data1),onset,spacings)

        problem = EstimationProblem(SD, SG, target)
        solver = FluxConservWeights(target => (order=1,area=AreaEuclidean()))
        solution = solve(problem, solver)
        out=solution[target]

        @test mean(data1) ≈ out.mean[1,1]
    end

end ## END REGULAR TESTING
