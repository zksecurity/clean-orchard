# Clean Orchard

A source-conformant port of the Zcash Orchard action circuit (Halo2) into [Clean](https://github.com/Verified-zkEVM/clean), with formal soundness and completeness proofs across the entire stack.

Gadgets are ported against:

- `orchard@orchard-0.14.0`
- `halo2@halo2_gadgets-0.5.0`

The modeling conventions are described in [orchard-clean-plan.md](orchard-clean-plan.md). Source-to-Clean coverage is tracked in [Orchard/orchard-conformance-map.md](Orchard/orchard-conformance-map.md).

## Status — MVP complete

The top-level Orchard action circuit (`Circuit::synthesize`) is fully assembled and proven over its entire dependency stack:

- **ECC** — `witness_point`, `witness_point_non_id`, `add_incomplete`, `add`, variable-base `mul`, and fixed-base `mul` / `mul_base_field` / `mul_short`.
- **Utilities** — conditional swap / point mux, add-chip, running-sum range checks, lookup range checks, and copy/decomposition.
- **Poseidon** — Pow5 permutation, sponge, and constant-length hashing with concrete P128 constants.
- **Sinsemilla & Merkle** — `hash_to_point`, hash/commit domains, short commit, and `MerklePath::calculate_root` at depth 32.
- **Orchard gadgets** — value commitment, nullifier derivation, spend authority, note commitment, `commit_ivk`, and diversified-address integrity.
- **Top-level action circuit** — `Orchard.Action.circuit`, including public-instance wiring and the `q_orchard` arithmetic gate.

Every circuit is proven sound and complete; the Orchard tree contains no `sorry`s. The development currently rests on one axiom, `pallas_natCard`, giving the order of the Pallas curve; all group-order facts used by scalar-multiplication proofs derive from it.

The top-level circuit's spec is currently an LLM-written `IntermediateSpec`. It can be bridged to a final hand-written spec through separate `*_of_intermediate` theorems without revisiting soundness or completeness proofs.

## Building

This repository pins Clean as a Lake dependency. On a new checkout:

```sh
lake exe cache get
lake build Orchard --wfail
```

## Out of MVP scope

**Halo2 VK matching.** Clean rows do not yet distinguish advice, fixed, and selector cells; column identity; or rotations. Therefore, the serialized constraint system cannot yet be mechanically reconstructed into and checked against the pinned Halo2 verification key. Selectors are modeled as subcircuit calls and fixed columns as Lean parameters.
