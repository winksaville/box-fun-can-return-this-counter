class ref Counter
  var _count: U64 = 0

  fun count(): U64 =>
    _count
    
  fun ref inc(): U64 =>
    _count = _count + 1
    _count

class ref HasCounter
  let _counter: Counter = Counter
  
  // A box function we can use this->Counter
  fun getCounter(): this->Counter =>
    _counter

  // A ref function we can just use Counter
  fun ref getCounterRef(): Counter =>
    _counter

actor Main
  new create(env: Env) =>
    var hasCounter: HasCounter = HasCounter
    env.out.print(hasCounter.getCounter().count().string())
    env.out.print(hasCounter.getCounter().inc().string())
    env.out.print(hasCounter.getCounterRef().inc().string())
