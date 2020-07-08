# Examples

## Regular Grid to Regular Grid

Definitions of rectangular Lon-Lat Grids
```julia
    # Input Grid with data
    target=:tas
    dims=(36,18)
    spacings=(360/dims[1],180/dims[2])
    onset=(-180,-90).+spacings./2
    data1=rand(dims[1],dims[2])
    RD = RegularGridData(OrderedDict(target => data1),onset,spacings)

    # Output Grid
    dims=(18,9)
    spacings=(360/dims[1],180/dims[2])
    onset=(-180,-90).+spacings./2
    data1=rand(dims[1],dims[2])
    RG=RegularGrid(dims,onset,spacings)
```
using Euclidean distances to estimate areas
```julia
    problem = EstimationProblem(RD, RG, target)
    solver = FluxConservWeights(target => (order=1,area=AreaEuclidean()))
    solution = solve(problem, solver)
    out=solution[target]
```

using Haversine distances to estimate areas
```julia
    problem = EstimationProblem(RD, RG, target)
    solver = FluxConservWeights(target => (order=1,area=AreaHaversine()))
    solution = solve(problem, solver)
    out=solution[target]
```
