local magic_mirror = {
    object_type = "Joker",
    order = 202,

    key = "magic_mirror",
    config = {
      
    },
    rarity = 3,
    pos = { x = 15, y = 7},
    atlas = 'joker_atlas',
    cost = 8,
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
        if G.GAME.jest_magic_mirror_trigger then 
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
      if context.individual and context.cardarea == G.play then
        if G.GAME.jest_magic_mirror_trigger then
            local cardd = context.other_card
            if cardd:is_face() then
                G.GAME.jest_magic_mirror_trigger = false
                 G.E_MANAGER:add_event(Event({
                trigger = 'before', -- 'before' is good for effects during scoring
                delay = 0.2,      -- A small delay to let other effects resolve first
                func = function()
                    card:juice_up(0.6, 0.2)
                    cardd:juice_up(0.6, 0.2)
                    play_sound('negative', 1.5, 0.4)
                    cardd:set_edition({negative = true}, true, true) 
                    return true
                end
            }))
            end
        end
      end
    end
  
}
local ease_anteref = ease_ante
function ease_ante(mod)
    if mod ~= 0 then
        G.GAME.jest_magic_mirror_trigger = true
    end
    
    local ref = ease_anteref(mod)
    return ref
end
return { name = {"Jokers"}, items = {magic_mirror} }
