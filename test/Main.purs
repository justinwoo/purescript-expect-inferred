module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import ExpectInferred (expectInferred)
import Type.Prelude (Proxy(..))

class SimpleClass a b | a -> b where
  simpleMethod :: Proxy a -> b

instance simpleInstance1 :: SimpleClass Int String where
  simpleMethod _ = "hello"

instance simpleInstance2 :: SimpleClass String Unit where
  simpleMethod _ = unit

simpleValueInferred :: String
simpleValueInferred = simpleMethod (Proxy :: Proxy Int)

test1 :: Unit
test1 =
  let
    expectedP = Proxy :: Proxy String
    simpleValue = simpleMethod (Proxy :: Proxy Int)
  in
    expectInferred expectedP simpleValue

test2 :: Unit
test2 =
  let
    -- this will error correctly:
    -- expectedP = Proxy :: Proxy String
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

    fixedExpectedP = Proxy :: Proxy Unit
    simpleValue = simpleMethod (Proxy :: Proxy String)
  in
    -- expectInferred expectedP simpleValue
    expectInferred fixedExpectedP simpleValue

-- invalidTest2 :: Unit
-- invalidTest2 =
--   expectInferred
--     (Proxy :: Proxy String)
--     -- doesn't work because type hasn't actually been figured out for the application of simpleMethod
--     (simpleMethod (Proxy :: Proxy Int))

main :: Effect Unit
main = do
  log "Tests finished"
