using Test, GeoStats, FluxConservative

## TESTING IS QUIT UNSTRUCTURED AND BRUTAL....

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
