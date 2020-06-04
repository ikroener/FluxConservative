using Test, GeoStats, FluxConservative

## TESTING IS QUIT UNSTRUCTURED AND BRUTAL....

target=:tas
dims=(36,18)
spacing=(360/dims[1],180/dims[2])
onset=(-180,-90).+spacing./2
data1=rand(dims[1],dims[2])
SG=RegularGrid(dims,onset,spacing)

dims=(36,18)
spacing=(360/dims[1],180/dims[2])
onset=(-180,-90).+spacing./2
data1=rand(dims[1],dims[2])
SD = RegularGridData(OrderedDict(target => data1),onset,spacing)

problem = EstimationProblem(SD, SG, target)

solver = FluxConservWeights(target => ())
solution = solve(problem, solver)
out=solution[target]

@test data1 ≈ out.mean
