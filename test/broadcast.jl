@testset "Broadcast" begin

using CuArrays
x = reshape([1:100...], 10, 10)
p = PermutedDimsArray(x,(1,2))
gpu_x = CuArray(x)
gpu_p = CuArray(p) #an example of a CuArrays wrapper that shouldn't fail

@test gpu_x .+ gpu_x == CuArray(reshape([2:2:200...], 10, 10))
@test gpu_x .+ gpu_x .+ gpu_x == CuArray(reshape([3:3:300...], 10, 10))
@test broadcast(+, gpu_x, gpu_x) == CuArray(reshape([2:2:200...], 10, 10))
@test broadcast(+, gpu_x, gpu_x, gpu_x) == CuArray(reshape([3:3:300...], 10, 10))
@test gpu_p .+ gpu_x == CuArray(reshape([2:2:200...], 10, 10))
@test gpu_p .+ gpu_p .+ gpu_x == CuArray(reshape([3:3:300...], 10, 10))

@test_throws ErrorException x .+ gpu_x
@test_throws ErrorException x .+ x .+ x .+ x .+ x .+ gpu_x

@test_throws ErrorException p .+ gpu_x
@test_throws ErrorException p .+ p .+ p .+ p .+ p .+ gpu_x

@test_throws ErrorException gpu_x .+ x
@test_throws ErrorException gpu_x .+ gpu_x .+ gpu_x .+ gpu_x .+ gpu_x .+ x

@test_throws ErrorException gpu_x .+ p
@test_throws ErrorException gpu_x .+ gpu_x .+ gpu_x .+ gpu_x .+ gpu_x .+ p

@test_throws ErrorException broadcast(+, x, gpu_x)
@test_throws ErrorException broadcast(+, x, x, x, x, x, gpu_x)

@test_throws ErrorException broadcast(+, gpu_x, x)
@test_throws ErrorException broadcast(+, gpu_x, gpu_x, gpu_x, gpu_x, gpu_x, x)

@test_throws ErrorException broadcast(+, p, gpu_x)
@test_throws ErrorException broadcast(+, p, p, p, p, p, gpu_x)

@test_throws ErrorException broadcast(+, gpu_x, p)
@test_throws ErrorException broadcast(+, gpu_x, gpu_x, gpu_x, gpu_x, gpu_x, p)

end
