{-# OPTIONS --type-in-type --without-K #-}

module container.m.hlevel where

open import sum
open import equality.core
open import equality.calculus
open import function.core
open import function.isomorphism
open import function.extensionality
open import sets.unit
open import hott.hlevel
open import hott.univalence
open import container.core
open import container.m.core

private
  -- Given a container with A i ≡ ⊤
  module M-⊤ (I : Set)
             (B : I → Set)
             (r : {i : I} → B i → I) where
    c : Container
    c = record
      { I = I
      ; A = λ _ → ⊤
      ; B = λ {i} _ → B i
      ; r = r }

    open Container c

    -- prove that ⊤ is a terminal coalgebra
    module T where
      M : I → Set
      M _ = ⊤

      out : M ↝ F M
      out tt = tt , λ _ → tt

      module Elim {X : I → Set}
                  (α : X ↝ F X) where
        unfold : X ↝ M
        unfold _ = tt

        unfold-β : {i : I}(x : X i)
                 → out (unfold x) ≡ imap X unfold (α x)
        unfold-β x = refl

        unfold-η : (h : X ↝ M)
                 → (∀ {i} (x : X i) → out (h x) ≡ imap X h (α x))
                 → ∀ {i} (x : X i) → h x ≡ unfold x
        unfold-η h _ x = refl
      open Elim public

    module M = Definition c

    -- so the corresponding M-type is trivial
    m-t-iso : ∀ i → T.M i ≅ M.M i
    m-t-iso i = iso f g (α i) β
      where
        f : ∀ {i} → T.M i → M.M i
        f = M.unfold T.out

        g : ∀ {i} → M.M i → T.M i
        g = T.unfold M.out

        α : ∀ i → (x : T.M i) → g (f {i} x) ≡ x
        α _ tt = refl

        β : ∀ {i} → (x : M.M i) → f (g x) ≡ x
        β x = M.unfold-η M.out (f ∘ g) (λ {(M.inf a f) → refl }) x
            ⊚ M.unfold-id x

    m-contr : ∀ i → contr (M.M i)
    m-contr i = iso-hlevel (m-t-iso i) ⊤-contr

  module Properties {c : Container}
                    (hA : ∀ i → contr (Container.A c i)) where
    abstract
      -- if A is trivial, then the container is equal to the one in M-⊤
      lem-container : (c : Container)
                    → let open Container c in (p : (λ _ → ⊤) ≡ A)
                    → let B₀ = (λ i → B (coerce (ext-inv p i) tt))
                          module M₀ = M-⊤ I B₀ r
                      in M₀.c ≡ c
      lem-container (container I .(λ _ → ⊤) B r) refl = refl

      -- the above equality is the identity on I
      lem-container-I : (c : Container)
                      → let open Container c in (p : (λ _ → ⊤) ≡ A)
                      → let B₀ = (λ i → B (coerce (ext-inv p i) tt))
                            module M₀ = M-⊤ I B₀ r
                            q : M₀.c ≡ c
                            q = lem-container c p
                        in ∀ i → subst Container.I q i ≡ i
      lem-container-I (container I .(λ _ → ⊤) B r) refl i = refl

      -- given equal containers, the corresponding M-types are equal
      apply-M : {c c' : Container}
              → (p : c ≡ c')
              → (i : Container.I c)
              → Definition.M c i ≡ Definition.M c' (subst Container.I p i)
      apply-M {c = c}{c' = .c} refl _ = refl

    open Definition c

    A-eq : (λ _ → ⊤) ≡ A
    A-eq = ext λ i → contr-contr ⊤-contr (hA i)

    B₀ : I → Set
    B₀ i = B (coerce (ext-inv A-eq i) tt)

    module M₀ = M-⊤ I B₀ r

    c-iso : M₀.c ≡ c
    c-iso = lem-container c A-eq

    c-iso-I : ∀ i → subst Container.I c-iso i ≡ i
    c-iso-I i = lem-container-I c A-eq i

    m-iso : ∀ i → M₀.M.M i ≡ M i
    m-iso i = apply-M c-iso i ⊚ cong M (c-iso-I i)

    m-contr : ∀ i → contr (M i)
    m-contr i = subst contr (m-iso i) (M₀.m-contr i)

open Properties public using (m-contr)
