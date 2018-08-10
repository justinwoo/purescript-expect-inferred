# purescript-expect-inferred

[![Build Status](https://travis-ci.org/justinwoo/purescript-expect-inferred.svg?branch=master)](https://travis-ci.org/justinwoo/purescript-expect-inferred)

Library for when you want to expect that something is inferred correctly. This library is not commonly useful.

## How this works

```purs
class ExpectInferred expected actual
```

No fundeps, so both have to be determined to match anything, which means that in PureScript, you have to let-bind your intermediate actual results.

```purs
expectInferred
  :: forall expected actual
   . ExpectInferred expected actual
  => Proxy expected
  -> actual
  -> Unit
expectInferred _ _ = unit
```

## Usage

Given some class and some of its methods:

```purs
class SimpleClass a b | a -> b where
  simpleMethod :: Proxy a -> b

instance simpleInstance1 :: SimpleClass Int String where
  simpleMethod _ = "hello"

instance simpleInstance2 :: SimpleClass String Unit where
  simpleMethod _ = unit
```

We can see usage as expected:

```purs
test1 :: Unit
test1 =
  let
    expectedP = Proxy :: Proxy String
    simpleValue = simpleMethod (Proxy :: Proxy Int)
  in
    expectInferred expectedP simpleValue
```

Then, when we put the wrong thing in:

```purs
test2 :: Unit
test2 =
  let
    -- this will error correctly:
    expectedP = Proxy :: Proxy String
    -- A custom type error occurred while solving type class constraints:
    --
    --   The expected (first) and actual (second) types did not match:
    --     String
    --     Unit
    --
    -- while applying a function expectInferred
    --   of type ExpectInferred t0 t1 => Proxy t0 -> t1 -> Unit
    --   to argument expectedP
    -- while inferring the type of expectInferred expectedP
    -- in value declaration test2

    simpleValue = simpleMethod (Proxy :: Proxy String)
  in
    expectInferred expectedP simpleValue
```
