module tests.typecons;

import tern.typecons;

class A
{
    int a;
}
struct B
{
    Nullable!A a;
}
unittest
{
    B b;
    b.a = null;
    assert(b.a == null);  //FAILS
}


debug Nullable!A foo(bool notNull)
{
    if (notNull)
        return nullable!A(new A());
    return nullable!A(null);
}
debug Nullable!(A[]) bar(bool notNull){
    if (notNull){
        A[] aArr = new A[4];
        return nullable(aArr);
    }
    
    return nullable!(A[])(null);
}


unittest
{
    Nullable!uint a;
    assert(a == null);
    a = 2;
    assert(a++ == 2);
    assert(++a == 4);

    Nullable!(uint[]) b;
    b.unnullify();
    b ~= 1;
    assert(b == [1]);

    // evil bug
    b = nullable!(uint[])(null);
    assert(b == null);

    Nullable!A g;
    assert(g == null);
    g = nullable!A(null);
    assert(g == null);

    Nullable!(short*) c = cast(short*)&a;
    assert(c[0] == cast(const(short)) 4);

    assert(foo(true) != null);
    assert(foo(false) == null);

    assert(bar(true) != null);
    assert(bar(false) == null);
}

unittest
{
    auto a = atomic(10);
    a++;
    assert(a == 11);

    auto b = atomic(10);
    b += 1.0;
    assert(b.value == 11);

    auto c = atomic([1, 2, 3]);
    c[0] = c[0] + 1;
    assert(c[0] == 2);
    assert(c[0 .. $] == cast(shared(int[]))[2, 2, 3]);
}

unittest
{
    auto a = blind(10);
    assert(a.numNextOps() > 4);
    a++;
    assert(a == 11);
}
