import Lake
open Lake DSL

package CleanOrchard where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩]

@[default_target]
lean_lib CleanOrchard where
  roots := #[`Orchard]

require Clean from git "https://github.com/Verified-zkEVM/clean.git"@"1e563b9c27991b3795eb440c1ee0757edb4ce8b1"
