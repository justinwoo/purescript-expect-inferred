module ExpectInferred where

import Prelude

import Prim.TypeError as TE
import Type.Prelude (Proxy)

class ExpectInferred expected actual

instance expectInferredAA :: ExpectInferred a a

else instance expectInferredAB ::
  ( TE.Fail
      (TE.Above
         (TE.Text "The expected (first) and actual (second) types did not match:")
          (TE.Beside
            (TE.Text "  ")
            (TE.Above
                (TE.Quote expected)
                (TE.Quote actual))))
  ) => ExpectInferred expected actual

expectInferred
  :: forall expected actual
   . ExpectInferred expected actual
  => Proxy expected
  -> actual
  -> Unit
expectInferred _ _ = unit
