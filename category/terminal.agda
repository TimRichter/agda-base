{-# OPTIONS --type-in-type --without-K #-}
module category.terminal where

open import sum
open import equality.core
open import category.graph
open import category.category
open import category.functor using (Const)
open import category.functor.adjoint
open import category.instances.unit
open import function.isomorphism
open import sets.unit
open import hott.hlevel
open import hott.hlevel.properties

-- X is a terminal object if the functor X : unit → C
-- is a right adjoint of the unique functor C → unit
terminal : (C : Category) → obj C → Set
terminal C X = unit-func C ⊣ Const unit X

private
  module properties {C : Category}
                    (X : obj C)(t : terminal C X) where
    open _⊣_ {D = unit} t
    open as-category C

    term-univ : (Y : obj C) → contr (hom Y X)
    term-univ Y = iso-hlevel (adj Y tt) (h↑ ⊤-contr tt tt)

    ! : (Y : obj C) → hom Y X
    ! Y = proj₁ (term-univ Y)

open properties public
