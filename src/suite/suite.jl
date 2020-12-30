include("spawner.jl")
include("become_pingpong.jl")
include("functional_style.jl")

function run_suite(libtype::Type{<:ActorLib})
    run_functional_style_test(libtype())
    run_becomepingpong_test(libtype())
    run_spawnertest(libtype())
end
