# No Quality Recycling

Quality parts come from good base materials or exteremly well done crafting. Deconstructing a machine and getting better quality intermediate parts out of it doesn't make sense, so this mod removes the quality effect from recyclers. This should also simplify the quality recycle loop slightly as you only have a chance for quality bumps in the crafting step.

To keep things at a similar/scale as what is possible in vanilla Factorio the quality percent chance from modules across all levels and quality have been adjusted. This should give only a small bump at the beginning, before you can unlock recyclers, but should help scale to a fairly higher percent at in the later stages to keep up with vanilla rates.

## What it does

1. **Removes quality from recyclers.** Quality modules can no longer be inserted into a recycler.
2. **Rebalances quality modules.** Quality module rates are adjusted to compensate for the loss of recycler-based quality, with the goal of roughly matching vanilla's overall pace of acquiring high-quality items.

## Quality curves

Values are the per-craft `quality` effect (chance to trigger any tier upgrade). The engine scales base values across module qualities using the standard `+30% / +60% / +90% / +150%` pattern.

### Vanilla

| Module quality | QM1 (base 1.0%) | QM2 (base 2.0%) | QM3 (base 2.5%) |
| --- | --- | --- | --- |
| Normal      | 1.00% | 2.00% | 2.50% |
| Uncommon    | 1.30% | 2.60% | 3.25% |
| Rare        | 1.60% | 3.20% | 4.00% |
| Epic        | 1.90% | 3.80% | 4.75% |
| Legendary   | 2.50% | 5.00% | 6.25% |

Cascade probabilities: `next_probability` = 1.0 and `chain_probability` = 0.1 on uncommon/rare/epic.

### This mod

Module bases at 1.5× vanilla (QM1: 1.5%, QM2: 3.0%, QM3: 3.75%). `chain_probability` raised from 0.1 to 0.2.

| Module quality | QM1 (base 1.5%) | QM2 (base 3.0%) | QM3 (base 3.75%) |
| --- | --- | --- | --- |
| Normal      | 1.50% | 3.00% | 3.75% |
| Uncommon    | 1.95% | 3.90% | 4.88% |
| Rare        | 2.40% | 4.80% | 6.00% |
| Epic        | 2.85% | 5.70% | 7.13% |
| Legendary   | 3.75% | 7.50% | 9.38% |

Cascade probabilities: `next_probability` = 1.0 and `chain_probability` = 0.2 on uncommon/rare/epic.