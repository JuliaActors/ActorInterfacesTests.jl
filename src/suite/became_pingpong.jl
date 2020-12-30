struct BecamePinger
    depth::Int
end

struct BecamePonger
    depth::Int
end

mutable struct TestChecker
    results
    TestChecker() = new([])
end

struct BecamePing end
struct BecamePong end

struct TestFn
    fn::Function
    results_to::Addr
end

@ctx function (me::TestChecker)(msg)
    push!(me.results, msg)
end

@ctx function (me::BecamePinger)(msg::BecamePong)
    depth = me.depth
    if depth > 0
        become(BecamePonger(depth))
        send(self(), BecamePing())
    end
    return nothing
end

@ctx function (me::BecamePonger)(msg::BecamePing)
    depth = me.depth
    if depth > 0
        become(BecamePinger(depth - 1))
        send(self(), BecamePong())
    end
    return nothing
end

@ctx function (me::BecamePinger)(msg::TestFn)
    send(msg.results_to, msg.fn(me))
end

@ctx function (me::BecamePonger)(msg::TestFn)
    send(msg.results_to, msg.fn(me))
end

const PING_COUNT = 50_000

function run_becamepingpong_test(lib::ActorLib)
    return @testset "ActorInterfaceTests/spawner: Spawning children and sending messages to them" begin
        @test ex_actorcount(lib) == 0
        becamer = BecamePinger(PING_COUNT)
        becameraddr = ex_spawn!(lib, becamer)
        checker = TestChecker()
        checkeraddr = ex_spawn!(lib, checker)
        @test ex_actorcount(lib) == 2
        ex_send!(lib, becameraddr, TestFn(me -> me.depth == 0, checkeraddr))
        ex_send!(lib, becameraddr, BecamePong())
        println("Becoming $(PING_COUNT * 2) times to a different type and delivering the same amount of messages")
        ex_runtofinish(lib)
        ex_send!(lib, becameraddr, TestFn(me -> me.depth == 0, checkeraddr))
        ex_runtofinish(lib)
        @test checker.results == [false, true]
    end
end
