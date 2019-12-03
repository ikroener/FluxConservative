using Test, GeoStats, FluxConservative

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
solver = FluxConservWeights()
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
solver = FluxConservWeights()
SD = StructuredGridData(Dict(target => dat), lon_src, lat_src)
problem = EstimationProblem(SD, SG, target)
solution = solve(problem, solver)
out=solution.mean[target]

@test out[1] ≈ mean(dat)[1]
