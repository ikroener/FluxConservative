## helper.jl

"""
    getCorners(X)

"""
function getCorners(X::RegularGrid)
    cds=GeoStats.coordinates(X)
    spacing=X.spacing./2
    corners=[]

    idx=[-1  1 1 -1
         -1 -1 1 1] # search for a parametric way to express corners in R^N

    sides=collect(spacing) .* idx

    corners=map(x -> PointSet(x.+ sides),eachcol(cds))
    (coords=GeoStats.coordinates(X)',bounds=corners)
end

function getCorners(X::StructuredGrid)

end


"""
    doOverlap

check if rectangles overlap....
"""
function doOverlap(X::PointSet,Y::PointSet)
        x=GeoStats.coordinates(X)
        y=GeoStats.coordinates(Y)
        # is one rectangle on left of the other ?
        a=x[1,4] >= y[1,2] || y[1,4] >= x[1,2]
        # is one rectangle on top of the other ?
        b=x[2,4] <= y[2,2] || y[2,4] <= x[2,2]

        !any([a,b])
end


function EstCellAreas(X,Y,area)
        # X is getCorners object of target grid
        # Y is getCorners object of source grid
        areacella=[]

        for (xnum,x) in enumerate(X.bounds)
                srcidx=[]
                cellarea=[]
                for (ynum,y) in enumerate(Y.bounds)
                        if doOverlap(x,y)
                                push!(cellarea,area(x,y))
                                push!(srcidx,ynum)
                        end
                end
                cellarea/=sum(cellarea)
                push!(areacella,(xnum,srcidx,cellarea))
        end
        return areacella
end

"""
    Conv2SetPoint(X::PointSet)

convert a PointSet type to a set of Points in Array{Array{Point}} format for polygon triangulation
"""
function Conv2SetPoint(X::PointSet)
        x=GeoStats.coordinates(X)
        T=typeof(x[1,1])
        out=Array{Point2{T}}(undef,0)
        [push!(out,Point2(xcol[1],xcol[2])) for xcol in eachcol(x)]
        return out
end
