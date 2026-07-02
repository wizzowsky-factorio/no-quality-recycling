# No-Quality Recycling: Mod Specification

**Target game:** Factorio 2.0 (Space Age required, since recyclers and quality come from the expansion)
**Author:** wizzowsky
**Status:** Draft scaffold

## 1. Concept

Remove the recycler-based path to higher quality items, and rebalance quality module output so the overall pace of acquiring high-quality items is similar to vanilla. The intent is to eliminate the "recycle-and-reroll" loop as a quality strategy while keeping quality progression itself viable through direct production.

### Design pillars

1. Recycling should be for resource recovery, not quality fishing.
2. Net quality output across a playthrough should roughly match vanilla so the late game doesn't feel gated.
3. Vanilla-style implementation, no opaque effect clamps. Player feedback when modules don't fit a slot should match how the rest of the game already communicates restrictions.

## 2. Feature 1: Remove quality from recyclers

- Strip `"quality"` from the recycler's `allowed_effects`.
- Verified vanilla pattern: this is how the pumpjack restricts modules in the base+quality data.
- Player-visible result: quality modules become uninsertable into recyclers, with the standard rejected-module tooltip.

Open questions to revisit:
- Should productivity also be reconsidered, or leave the rest of the recycler's module behavior alone?
- Any second-order recipes (custom recycling recipes, modded scrap recipes) that need matching treatment?

## 3. Feature 2: Rebalance quality module rates

Goal: compensate for the removal of the recycling reroll loop so total quality output stays roughly in line with vanilla.

Levers available:
- `ModulePrototype.effect.quality` — base per-module chance for each quality module tier.
- `QualityPrototype.next_probability` — cascade chance to jump an extra tier on a successful upgrade.
- `QualityPrototype.chain_probability` (2.1) — chance of an additional upgrade after one already happened in the same operation.
- `ModulePrototype.*_quality_multiplier` (2.1) — how strongly module quality tier itself amplifies the module's effect.

Open questions to revisit:
- Decide on a tuning target: "feels like vanilla pace" vs. a measurable benchmark (e.g., expected legendary items per hour with N quality-3 modules).
- Which lever(s) to use: flat bump on `effect.quality`, adjust the cascade, or both?
- Should normal-tier and legendary-tier quality probabilities scale differently?
- Any concern about productivity-by-quality interactions on machines that produce intermediate goods?

## 4. Out of scope (initial scaffold)

- Changing recipes that already opt out via `allow_quality = false`.
- Adding new quality tiers or new modules.
- Visual or tooltip changes beyond what the engine provides automatically.
- Compatibility shims for other mods.

## 5. Milestones

1. M1: Prototype the recycler change (single-line `data-updates.lua` edit) and confirm in-game UI rejects quality modules.
2. M2: Pick the rebalance lever(s) and ship a first-pass tuning.
3. M3: Playtest, gather feel, iterate on numbers.
4. M4: Localization, icon, info.json polish, mod portal release.

## 6. File structure (placeholder)

```
no-quality-recycling/
  info.json
  thumbnail.png
  changelog.txt
  data-updates.lua
  settings.lua            -- if any rebalance values are exposed as settings
  locale/
    en/
      no-quality-recycling.cfg
```

## 7. Open design questions

- Mod name and internal ID.
- Whether the rebalance values should be exposed as startup settings so players can tune to taste.
- Whether to provide a "strict mode" setting that removes quality from recyclers without any rebalance, for players who want the loop gone and accept slower quality progression.

## 8. Quality module rebalance worksheet

Base values are from `quality/prototypes/item.lua` (`effect.quality` per module). The engine scales those bases across module quality tiers with the standard `+30% / +60% / +90% / +150%` multipliers (uncommon 1.3×, rare 1.6×, epic 1.9×, legendary 2.5×). QM1 tooltip in-game confirmed.

All values are the `quality` effect (per-craft chance to trigger any tier upgrade). Cascade behavior after the trigger is governed separately by `QualityPrototype.chain_probability`.

### Vanilla quality curve

| Module quality | QM1 (base 1.0%) | QM2 (base 2.0%) | QM3 (base 2.5%) |
| --- | --- | --- | --- |
| Normal      | 1.00% | 2.00% | 2.50% |
| Uncommon    | 1.30% | 2.60% | 3.25% |
| Rare        | 1.60% | 3.20% | 4.00% |
| Epic        | 1.90% | 3.80% | 4.75% |
| Legendary   | 2.50% | 5.00% | 6.25% |

### Target quality curve

Starting point: module base values at **1.5× vanilla**, `chain_probability` bumped from **0.1 → 0.2** on uncommon, rare, and epic. `next_probability` stays at 1.0. Bases are `effect.quality` in `data.raw["module"][name]`; the engine's `+30% / +60% / +90% / +150%` scaling propagates to higher module qualities automatically.

Module base targets: **QM1 = 1.5%**, **QM2 = 3.0%**, **QM3 = 3.75%**.

| Module quality | QM1 | QM2 | QM3 |
| --- | --- | --- | --- |
| Normal      | 1.50% | 3.00% | 3.75% |
| Uncommon    | 1.95% | 3.90% | 4.88% |
| Rare        | 2.40% | 4.80% | 6.00% |
| Epic        | 2.85% | 5.70% | 7.13% |
| Legendary   | 3.75% | 7.50% | 9.38% |

### Cascade probabilities (per quality tier)

`next_probability` and `chain_probability` live on `QualityPrototype`, not on the modules. Listed here so all rebalance levers are in one place.

Vanilla source confirmed from `quality/prototypes/quality.lua` and `base/prototypes/categories/quality.lua`:

| Quality tier | `next_probability` vanilla | `next_probability` target | `chain_probability` vanilla | `chain_probability` target |
| --- | --- | --- | --- | --- |
| Normal      | 1.0 | 1.0 | 0.1 | 0.2 |
| Uncommon    | 1.0 | 1.0 | 0.1 | 0.2 |
| Rare        | 1.0 | 1.0 | 0.1 | 0.2 |
| Epic        | 1.0 | 1.0 | 0.1 | 0.2 |
| Legendary   | — | — | — | — |

### Expected per-craft outcomes (4 × normal QM3 in a normal machine, normal ingredients)

Values shown are the probability the item lands *exactly* at that tier from a single craft.

| Outcome    | Vanilla direct | Target direct | Per-craft multiplier |
| --- | --- | --- | --- |
| Uncommon   | 9.00%   | 12.00%  | 1.33× |
| Rare       | 0.90%   | 2.40%   | 2.67× |
| Epic       | 0.09%   | 0.48%   | 5.33× |
| Legendary  | 0.01%   | 0.12%   | 12×   |

### Playtest tuning guide

The starting curve is a first pass. Once you have real gameplay data, tune with the following heuristics before touching multiple knobs at once.

**Symptom: uncommon items feel trivial, every craft is uncommon+.**
- Cause: base rate is too high, cascade is fine.
- Fix: drop module base multiplier from 1.5× toward 1.25×. Leave chain_probability alone.

**Symptom: legendaries are still too rare to be worth pursuing.**
- Cause: cascade is too shallow.
- Fix: raise `chain_probability` from 0.2 to 0.22 or 0.25. This roughly doubles legendary rate per 0.05 step, with a much smaller effect on lower tiers.

**Symptom: rare and epic feel like an easy stepping stone, legendary is still hard.**
- Cause: cascade is doing most of the work but starts at too low a threshold.
- Fix: leave the base alone, raise `chain_probability` to 0.25. Consider dropping the base multiplier to 1.25× to keep uncommon rate close to vanilla.

**Symptom: whole curve feels too gentle, quality items are everywhere.**
- Cause: over-buffed.
- Fix: drop both knobs. Base to 1.25×, chain to 0.15.

**Symptom: whole curve feels too harsh compared to vanilla-loop pacing.**
- Cause: under-buffed. Likely means players were using an aggressive method-2 setup.
- Fix: raise chain first (0.2 → 0.25), then base (1.5× → 1.75×) only if legendary is still lagging.

**When to consider `ModulePrototype.quality_quality_multiplier`.**
- Only reach for this if the vanilla ratio between normal-tier and legendary-tier quality modules feels wrong after other tuning. It's a 2.1-only knob and lets you make higher-quality modules disproportionately stronger or weaker at the quality effect. Default engine scaling (+30/+60/+90/+150) is probably fine; touch this last.

**When to consider adjusting `-5% speed` penalty.**
- If total quality-module throughput cost feels too punishing after the rebalance, consider softening the speed penalty (e.g., -3% or -4%). This is orthogonal to the quality curve itself and only matters if end-game production feels sluggish.

### Notes for tuning

- Simplest rebalance flow: modify only the three base values in `effect.quality` first, playtest, then touch `chain_probability` if legendary rate still feels off.
- Any change to the module base propagates cleanly through all 15 cells of the curve because the engine handles quality scaling automatically.
- Any change to `chain_probability` reshapes the cascade for both vanilla and modded quality modules; it is a global setting on the quality prototype.

