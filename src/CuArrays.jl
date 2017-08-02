module CuArrays

using CUDAdrv, CUDAnative

export CuArray

include("array.jl")
include("indexing.jl")
include("slow.jl")
include("broadcast.jl")

end # module