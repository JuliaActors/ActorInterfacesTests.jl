const test_msgs = [
    (1, "2", 3.0),
    ("1", 2, 3.0, 4, 5, 6, 7, 8),
    (1,),
    ((1,),),
]
function spawner(::Val{:start}; ctx)
    collectoraddr = spawn(testcollector, []; ctx)
    workeraddr = spawn(worker, collectoraddr, 42; ctx)
    send(collectoraddr, Val(:runtests), workeraddr; ctx)
    become(spawner, collectoraddr; ctx)
end

function spawner(collectoraddr, ::Val{:copyresults}, target; ctx)
    send(collectoraddr, Val(:copyresults), target; ctx)
end

function worker(tester::Addr, aq2::Int, msg...; ctx)
    send(tester, Val(:got), aq2, msg...; ctx)
end

function testcollector(results, ::Val{:runtests}, workeraddr; ctx)
    for msg in test_msgs
        send(workeraddr, msg...; ctx)
    end
end

function testcollector(results, ::Val{:got}, restmsg...; ctx)
    become(testcollector, [results..., restmsg]; ctx)
end

function testcollector(results, ::Val{:copyresults}, target; ctx)
    for r in results
        push!(target, r)
    end
end

function run_functional_style_test(lib::ActorLib)
    return @testset "ActorInterfaceTests/functional_style: Aquintances and multi-arg send" begin
        @test ex_actorcount(lib) == 0
        spawneraddr = ex_spawn!(lib, spawner)
        @test ex_actorcount(lib) == 1
        ex_send!(lib, spawneraddr, Val(:start))
        ex_runtofinish(lib)
        sleep(0.1)
        results = []
        ex_send!(lib, spawneraddr, Val(:copyresults), results) 
        ex_runtofinish(lib)
        for (i, msg) in enumerate(test_msgs)
            @test results[i] == (42, msg...)
        end
    end
end
