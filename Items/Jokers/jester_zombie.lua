local jester_zombie = {
    object_type = "Joker",
    order = 236,
    key = "jester_zombie",
    config = {
      
    },
    rarity = 2,
    pos = { x = 4, y = 9},
    atlas = 'joker_atlas',
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
  
    loc_vars = function(self, info_queue, card)
        local default_loc = {
            active = "(Active!)",
            inactive = "(Inactive)"
        }
        local active_text = default_loc.inactive
        if G.GAME.jest_jester_zombie_trigger then 
            active_text = localize('k_active_ex')
            if active_text == "ERROR" then
                active_text = default_loc.active
            else
                active_text = "(" .. active_text .. ")"
            end
        else
            active_text = localize("k_aij_inactive")
            if active_text == "ERROR" then
                active_text = "(Inactive)"
            else
                active_text = "(" .. active_text .. ")"
            end
        end
        return { vars = {
            active_text
        }}
    end,
  
    calculate = function(self, card, context)
      print(G.GAME.jest_jester_zombie_trigger)
      if context.repetition and context.cardarea == G.play then
            for i = 1, #context.scoring_hand do
                if G.GAME.jest_jester_zombie_trigger then
                    return {
                        repetitions = 1,
                        card = card,
                        message = localize('k_again_ex')
                    }  
                end
            end
        end
    end
  
}
local ease_roundref = ease_round
function ease_round(mod)
    if mod ~= 0 then
        G.GAME.jest_jester_zombie_trigger = false
    end
    
    local ref = ease_roundref(mod)
    return ref
end
local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
  local ref = start_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
  if G.jokers and (self.ability.set == 'Enhanced' or self.ability.set == 'Default') then
      G.GAME.jest_jester_zombie_trigger = true
  end
  return ref
end
return { name = {"Jokers"}, items = {jester_zombie} }
