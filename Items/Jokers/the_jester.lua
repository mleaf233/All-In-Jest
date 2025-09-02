local the_jester = {
  object_type = "Joker",
  order = 170,

  key = "the_jester",
  config = {
    extra = {
      active = true,
    }
  },
  rarity = 2,
  pos = { x = 17, y = 9 },
  atlas = 'joker_atlas',
  cost = 7,
  unlocked = true,
  discovered = false,
  blueprint_compat = false,
  eternal_compat = true,

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS['c_fool']
    local default_loc = {
      active = "(Active!)",
      inactive = "(Inactive)"
    }
    local active_text = default_loc.inactive
    if card.ability.extra.active then
      active_text = localize('k_active_ex')
      if active_text == "ERROR" then
        active_text = default_loc.active
      else
        active_text = "(" .. active_text .. ")"
      end
      return {
        vars = {
          active_text
        }
      }
    else
      active_text = localize("k_aij_inactive")
      if active_text == "ERROR" then
        active_text = default_loc.inactive
      else
        active_text = "(" .. active_text .. ")"
      end
      return {
        vars = {
          active_text
        }
      }
    end
  end,

  calculate = function(self, card, context)
    if context.selling_card then
      if context.card ~= card then
        if context.card.ability.set == "Joker" and card.ability.extra.active then
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
              if G.consumeables.config.card_limit > #G.consumeables.cards then
                play_sound('timpani')
                local _card = create_card(nil, G.consumeables, nil, nil, nil, nil, 'c_fool', nil)
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                card:juice_up(0.3, 0.3)
                card.ability.extra.active = false
              end
              return {
                true,
                message = 'The Fool'
              }
            end
          }))
          delay(0.6)
        end
      end
    end
    if context.end_of_round then
      card.ability.extra.active = true
    end
  end

}
return { name = { "Jokers" }, items = { the_jester } }
