using Test, GeoStats, FluxConservative

## TESTING IS QUIT UNSTRUCTURED AND BRUTAL....

## TEST Definitions....
##

dat=randn(96,48)
dat=ones(96,48)
a,b=size(dat)
lon=(-180+360/a/2:360/a:180-360/a/2)
lat=(-90+180/b/2:180/b:90-180/b/2)
lon_src=reshape(repeat(lon,inner=b),a,b)
lat_src=reshape(repeat(lat,outer=a),a,b)

lon_dst=zeros(1,1)
lat_dst=zeros(1,1)

target = :tas

SG=GeoStats.StructuredGrid(lon_dst,lat_dst)
solver = FluxConservWeights(:tas => ())
SD = StructuredGridData(Dict(target => dat), lon_src, lat_src)
problem = EstimationProblem(SD, SG, target)
solution = solve(problem, solver)
out=solution.mean[target]
@test out[1] ≈ mean(dat)[1]

# RANDOM DATA, BUT WITH CONSTANT WEIGHTING....
dat=randn(96,48)
lat=repeat([0.],b)
lat_src=reshape(repeat(lat,outer=a),a,b)

SG=GeoStats.StructuredGrid(lon_dst,lat_dst)
solver = FluxConservWeights(:tas => ())
SD = StructuredGridData(Dict(target => dat), lon_src, lat_src)
problem = EstimationProblem(SD, SG, target)
solution = solve(problem, solver)
out=solution.mean[target]

@test out[1] ≈ mean(dat)[1]

### TEST WITH POINTS INSTEAD OF STRUCTUREDGRID

a,b=96,48
dat=randn(a*b)
dat=ones(a*b)
c=size(dat)
lon=(-180+360/a/2:360/a:180-360/a/2)
lat=(-90+180/b/2:180/b:90-180/b/2)
lon_src=reshape(repeat(lon,inner=b),a*b)
lat_src=reshape(repeat(lat,outer=a),a*b)
target=:tas
lon_dst=[0.]
lat_dst=[0.]

SG=GeoStats.PointSet(vcat(lon_dst',lat_dst'))
solver = FluxConservWeights(target => ())
SD = PointSetData(Dict(target => dat), vcat(lon_src', lat_src'))
problem = EstimationProblem(SD, SG, target)
solution = solve(problem, solver)
out=solution.mean[target]

@test out[1] ≈ mean(dat)[1]



#### TEST WITH A GIVEN CDO FILE

filename="../data/T63toR96x48.nc"

grid=FluxConservative.readCDOgrid(filename)

a=length(collect(grid["src_grid_center_lon"]))
lon_src=collect(grid["src_grid_center_lon"])
lat_src=collect(grid["src_grid_center_lat"])

dat=repeat([1.],length(lon_src))

target=:tas
lon_dst=collect(grid["dst_grid_center_lon"])
lat_dst=collect(grid["dst_grid_center_lon"])

SG=GeoStats.PointSet(vcat(lon_dst',lat_dst'))
solver = FluxConservWeights(target => (cdogrid = grid,))
SD = PointSetData(Dict(target => dat), vcat(lon_src', lat_src'))
problem = EstimationProblem(SD, SG, target)
solution = solve(problem, solver)
out=solution.mean[target]

@test mean(out)[1] ≈ mean(dat)[1]
