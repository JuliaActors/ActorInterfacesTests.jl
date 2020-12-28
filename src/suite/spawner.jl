using ActorInterfaces.Classic
using Test

struct Spawner end

struct SpawnTree
    childcount::UInt8
    depth::UInt8
end

@ctx function Classic.onmessage(me::Spawner, msg::SpawnTree)
    if msg.depth > 0
        for i = 1:msg.childcount
            child = spawn(Spawner())
            send(child, SpawnTree(msg.childcount, msg.depth - 1))
        end
    end
    return nothing
end

const TREE_HEIGHT = 15
const TREE_SIZE = 2^(TREE_HEIGHT + 1) - 1

function run_spawnertest(lib::ActorLib)    
    return @testset "ActorInterfaceTests/spawner: Spawning children and sending messages to them" begin
        @test ex_actorcount(lib) == 0
        root = Spawner()
        rootaddr = ex_spawn!(lib, root)
        @test ex_actorcount(lib) == 1
        ex_send!(lib, rootaddr, SpawnTree(2, TREE_HEIGHT))
        println("Building a tree of $TREE_SIZE actors and delivering the same amount of messages")
        ex_runtofinish(lib)
        @test ex_actorcount(lib) == TREE_SIZE
    end
end

