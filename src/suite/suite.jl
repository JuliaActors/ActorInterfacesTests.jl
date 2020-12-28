include("spawner.jl")

function run_suite(libtype::Type{<:ActorLib})
    run_spawnertest(libtype())
end
