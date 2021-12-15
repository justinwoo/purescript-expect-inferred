module ExpectInferred where

import Prelude

import Prim.TypeError as TE
import Type.Prelude (Proxy)

infixr 2 type TE.Beside as +
infixr 1 type TE.Above as ^

class ExpectInferred :: forall a b. a -> b -> Constraint
class ExpectInferred expected actual

instance expectInferredAA :: ExpectInferred a a

else instance expectInferredAB ::
  ( TE.Fail
      ( (TE.Text "The expected (first) and actual (second) types did not match:")
      ^ ( (TE.Text "  ")
        + ( (TE.Quote expected)
          ^ (TE.Quote actual)
          )
        )
      )
  ) => ExpectInferred expected actual

expectInferred
  :: forall expected actual
   . ExpectInferred expected actual
  => Proxy expected
  -> actual
  -> Unit
expectInferred _ _ = unit
