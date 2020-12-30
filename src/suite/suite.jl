include("spawner.jl")
include("became_pingpong.jl")

function run_suite(libtype::Type{<:ActorLib})
    run_becamepingpong_test(libtype())
    run_spawnertest(libtype())
end
