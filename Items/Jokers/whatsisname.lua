local whatsisname = {
    object_type = "Joker",
    order = 264,
    
    key = "whatsisname",
    config = {
      
    },
    rarity = 3,
    pos = { x = 9, y = 10},
    atlas = 'joker_atlas',
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
  
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Other', key = 'p_aij_guess_the_jest', vars = {1, 3}} -- TODO: 1 and 3 should be replaced with vars from the booster
    end,

    add_to_deck = function(self, card, from_debuff)
        
    end,
    remove_from_deck = function(self, card, from_debuff)
        
    end,
  
    calculate = function(self, card, context)
        
    end
  
}
return { name = {"Jokers"}, items = {whatsisname} }
