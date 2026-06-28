# No Quality Recycling

A Factorio mod that removes the recycler-based quality reroll loop and rebalances quality modules to keep overall quality progression in line with vanilla pacing.

## Why

In vanilla Factorio with the Space Age expansion, recyclers accept quality modules, which enables a "recycle and reroll" loop as a primary path to higher-quality items. This mod removes that loop and shifts quality progression back onto direct production, with a compensating buff to quality modules so the late game does not feel slower.

## What it does

1. **Removes quality from recyclers.** Quality modules can no longer be inserted into a recycler. The slot rejects them with the standard tooltip, matching how the pumpjack already restricts modules in vanilla.
2. **Rebalances quality modules.** Quality module rates are adjusted to compensate for the loss of recycler-based quality, with the goal of roughly matching vanilla's overall pace of acquiring high-quality items.

## Compatibility

- **Factorio version:** 2.1+
- **Required:** `base >= 2.1` (Space Age expansion required, since recyclers and quality come from the expansion)
- **Other mods:** This mod targets vanilla interactions only and does not attempt to handle conflicts with mods that add their own recyclers, quality modules, or quality tiers.

## Installation

Install through the in-game mod portal once published, or drop the mod folder into `%APPDATA%\Factorio\mods\` on Windows.

## Status

Early development. See the spec for design intent and open questions.

## Author

Wizzowsky
