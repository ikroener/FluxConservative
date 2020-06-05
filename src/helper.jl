## helper.jl

"""
    getCorners(X)

"""
function getCorners(X::RegularGrid)
    cds=coordinates(X)
    spacing=X.spacing./2
    corners=[]

    idx=[-1  1 1 -1
         -1 -1 1 1] # search for a parametric way to express corners in R^N

    sides=collect(spacing) .* idx

    corners=map(x -> PointSet(x.+ sides),eachcol(cds))
    (coords=coordinates(X)',bounds=corners)
end


"""
    doOverlap

check if rectangles overlap....
"""
function doOverlap(X::PointSet,Y::PointSet)
        x=coordinates(X)
        y=coordinates(Y)
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
