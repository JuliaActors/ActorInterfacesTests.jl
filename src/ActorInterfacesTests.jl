"""
    module ActorInterfacesTests

Test suite for ActorInterfaces.

To test if an actor library is compatible with ActorInterfaces.jl, you have to provide a proxy type,
subtype of ActorLib, that implements functions defined in this suite (prefixed with ex_) to allow
external manipulating of the actor library, namely spawning, sending messages, counting actors and
running until no messages remain to process.

The proxy type must have a default constructor that creates an empty instance of the actor system.
It is allowed to reuse the same instance after cleaning if there is only a single global instance.
No more than one test will be running at a time.

To run the suite, call `run_suite()`` with the proxy type.
"""
module ActorInterfacesTests

export ActorLib, run_suite

abstract type ActorLib end

"""
    function ex_spawn!(lib, bhv, args...) end

Spawn a new actor with the given behavior and args, and return its address.
"""
function ex_spawn!(lib, bhv, args...) end

"""
    function ex_send!(lib, addr, msg...) end

Send a message to the given addr.
"""
function ex_send!(lib, addr, msg...) end

"""
    function ex_actorcount(lib) end

Return the number of spawned actors in the actor system `lib`, not counting errored ones.
"""
function ex_actorcount(lib) end

"""
    function ex_runtofinish(lib) end

Block and run the actor system until all the messages get processed.
"""
function ex_runtofinish(lib) end

include("suite/suite.jl")

end # module
