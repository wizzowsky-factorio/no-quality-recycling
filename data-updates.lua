-- Remove quality effects from the allowed_effects in recyclers.
data.raw["furnace"]["recycler"].allowed_effects = {"consumption", "speed", "pollution"}

-- Modify the base quality rates and the curve so that without the recycler loop lower quality
-- levels are slightly easier to achieve and legendary is roughly the same resource cost.

-- Multiply base rates
local quality_mult = 1.5

data.raw["module"]["quality-module"].effect.quality   =
  data.raw["module"]["quality-module"].effect.quality   * quality_mult
data.raw["module"]["quality-module-2"].effect.quality =
  data.raw["module"]["quality-module-2"].effect.quality * quality_mult
data.raw["module"]["quality-module-3"].effect.quality =
  data.raw["module"]["quality-module-3"].effect.quality * quality_mult

-- chain_probability curve increase
local chain_mult = 2.0

for _, name in ipairs({"normal", "uncommon", "rare", "epic"}) do
  local q = data.raw["quality"][name]
  if q.chain_probability then
    q.chain_probability = q.chain_probability * chain_mult
  end
end