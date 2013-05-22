{-# OPTIONS --without-K --type-in-type #-}

module category.functor.builder where

open import level
open import equality.core
open import function.core
open import category.graph.core
open import category.category.core

record FunctorBuilder (C D : Category) : Set where
  open as-category C
  open as-category D

  field
    apply : obj C → obj D
    map : {x y : obj C} → hom x y → hom (apply x) (apply y)
    map-id : (x : obj C) → map (id {X = x}) ≡ id
    map-hom : {x y z : obj C}
            → (f : hom y z)
            → (g : hom x y)
            → map (f ∘ g) ≡ map f ∘ map g
