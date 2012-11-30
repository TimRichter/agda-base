
{-# OPTIONS --without-K  #-}

module base_types.unit where

data ⊤ : Set where
  tt : ⊤

⊤-elim : (P : ⊤ → Set) → P tt → (x : ⊤) → P x
⊤-elim P ptt tt = ptt
