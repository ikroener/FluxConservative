struct AreaEuclidean{T}
    weights::T
end

AreaEuclidean() = AreaEuclidean(0.)

function (area::AreaEuclidean)(X::PointSet,Y::PointSet)
    x=GeoStats.coordinates(X)
    y=GeoStats.coordinates(Y)

    #bottom_left
    x1=max(x[1,1],y[1,1])
    y1=max(x[2,1],y[2,1])

    #top_right
    x2=min(x[1,3],y[1,3])
    y2=min(x[2,3],y[2,3])

    A = max(0,abs(abs(x2)-abs(x1))) * max(0,abs(abs(y2)-abs(y1)))
end
