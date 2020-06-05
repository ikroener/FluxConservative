struct AreaHaversine{T}
    radius::T
end

AreaHaversine() = AreaHaversine(6731.)

function (area::AreaHaversine)(X::PointSet,Y::PointSet)
    ## To estimate a spherical quadrilateral we can split it into two spherical triangles....
    ## but first we have to get the 4 coordinates of the overlap
    x=coordinates(X)
    y=coordinates(Y)

    #bottom_left
    x1=max(x[1,1],y[1,1])
    y1=max(x[2,1],y[2,1])

    #top_right
    x3=min(x[1,3],y[1,3])
    y3=min(x[2,3],y[2,3])

    #bottom_right
    x2=x3
    y2=y1

    #top_left
    x4=x1
    y4=y3

    Z=PointSet([x1 x2 x3 x4;y1 y2 y3 y4])
    z=coordinates(Z)
    A = 0.

    for sel in ([1,2,3],[1,3,4])

        a=haversine(z[:,sel[1]],z[:,sel[2]],1)
        b=haversine(z[:,sel[2]],z[:,sel[3]],1)
        c=haversine(z[:,sel[3]],z[:,sel[1]],1)

        s=(a+b+c)/2
        tanE=sqrt(tan(s/2)*tan((s-a)/2) * tan((s-b)/2) * tan((s-c)/2))
        E=atan(tanE)*4

        A += π * E / 180
    end
    return A
end
