# Box functions can return this->Counter

I had a function which returned `Counter ref`
```
fun /*ref*/ getCounter: Counter ref =>
  _counter
```
And was getting an error:
```
0.21.3 [release]
compiled with: llvm 3.9.1 -- cc (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609
Error:
main.pony:16:5: function body isn't the result type
    _counter
    ^
    Info:
    main.pony:15:29: function return type: Counter ref
      fun /*ref*/ getCounter(): Counter =>
                                ^
    main.pony:16:5: function body type: this->Counter ref
        _counter
        ^
    main.pony:12:17: Counter box is not a subtype of Counter ref: box is not a subcap of ref
      let _counter: Counter = Counter
```
As Eric and Sean explained in [my question](https://pony.groups.io/g/user/topic/8153517#1563)
to the user list. The problem is that by default a fun needs a receiver that is
a box. So the declaration is really:
```
fun box getCounter: Counter ref =>
  _counter
```
Since box is a read only for the receiver but we're trying to
return a `ref` we get the error. Personally the error is bad
but that's a different problem.

There are at least two solutions, one I found, which is to change
`fun getCounter` to a `ref` like:
```
fun ref getCounter: Counter ref =>
  _counter
```
This seemed odd to me because I wasn't modifying `_counter` but
the problem is Counter Ref is modifiable but box's are `Read Only`
so they are incompatible.

The other solution, from Benoit, is to return `this->Counter ref`:
```
fun getCounter: this->Counter ref =>
  _counter
```
This is documented in the tutorial at
[Arrow Types](https://tutorial.ponylang.org/capabilities/arrow-types.html).

Note: returning `this->Counter` can only be used for `fun box`!
