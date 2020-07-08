struct AreaHaversine{T}
    radius::T
end

AreaHaversine() = AreaHaversine(6731.)

function (area::AreaHaversine)(X::PointSet,Y::PointSet)
    ## To estimate a spherical quadrilateral we can split it into spherical triangles....
    ## And use spherical geometry to estimate the area
    ## but first we have to get the coordinates of the overlap polygon

    Zpoints=@suppress estOverlap(X,Y)
    triangles=EarCut.triangulate([Point2.(Zpoints)])
    A = 0.
    z=Zpoints

    for sel in triangles

        a=haversine(z[sel[1]],z[sel[2]],1)
        b=haversine(z[sel[2]],z[sel[3]],1)
        c=haversine(z[sel[3]],z[sel[1]],1)

        s=(a+b+c)/2
        tanE=sqrt(tan(s/2)*tan((s-a)/2) * tan((s-b)/2) * tan((s-c)/2))
        E=atan(tanE)*4

        A += π * E / 180
    end
    return A
end
