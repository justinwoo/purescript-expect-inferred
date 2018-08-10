module ExpectInferred where

import Prelude

import Prim.TypeError as TE
import Type.IsEqual (class IsEqual)
import Type.Prelude (False, Proxy, True, kind Boolean)

class ExpectInferred expected actual

instance expectInferredInstance ::
  ( IsEqual a b test
  , HandleResult a b test
  ) => ExpectInferred a b

class HandleResult a b (test :: Boolean) | test -> a b

instance handleResultTrue :: HandleResult a a True

instance handleResultFalse ::
  ( TE.Fail
      (TE.Above
         (TE.Text "The expected (first) and actual (second) types did not match:")
          (TE.Beside
            (TE.Text "  ")
            (TE.Above
                (TE.Quote expected)
                (TE.Quote actual))))
  ) => HandleResult expected actual False

expectInferred
  :: forall expected actual
   . ExpectInferred expected actual
  => Proxy expected
  -> actual
  -> Unit
expectInferred _ _ = unit
