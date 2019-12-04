"""
    readCDOgrid(filename::String)

Reads a given cdo grid file and returns its information. This function is
mainly to identify the needs of a remapping scheme.
"""
function readCDOgrid(filename::String)
    out=[]

    ncid=NetCDF.open(filename,mode=0x0000) # 0x0000 equals NOWRITE

    data=ncid.vars

end
