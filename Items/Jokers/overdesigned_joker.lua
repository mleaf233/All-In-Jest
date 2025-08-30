local suffix_table = {k_mult = " Mult ", blank = " ", k_aij_chips=" Chips "}
local prefix_table = {k_aij_give = "give", k_aij_earn = "earn"}
local function jest_overdesigned_joker_cycle(suit)
    if suit == "Heart" then
        return {"Club", 14}, {prefix_table.k_aij_give, "+", suffix_table.k_mult}, {G.C.SUITS.Clubs, G.C.MULT}
    elseif suit == "Club" then
        return {"Diamond", 2}, {prefix_table.k_aij_earn, "$", suffix_table.blank}, {G.C.SUITS.Diamonds, G.C.MONEY}
    elseif suit == "Diamond" then
        return {"Spade", 100}, {prefix_table.k_aij_give, "+", suffix_table.k_aij_chips}, {G.C.SUITS.Spades, G.C.CHIPS}
    elseif suit == "Spade" then
        return {"Heart", 1.5}, {prefix_table.k_aij_give, "X", suffix_table.k_mult}, {G.C.SUITS.Hearts, G.C.WHITE, G.C.MULT}
    end
end
local overdesigned_joker = {
    object_type = "Joker",
    order = 230,
    
    key = "overdesigned_joker",
    config = {
      suit = "Heart",
      amount = 1.5,
      extra = {
          prefix = prefix_table.k_aij_give,
          symbol = "X",
          suffix = suffix_table.k_mult,
          colours = {
              suit = G.C.SUITS.Hearts,
              amount = G.C.WHITE,
              background = G.C.MULT
          }
      }
    },
    rarity = 2,
    pos = { x = 19, y = 8},
    atlas = 'joker_atlas',
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
  
    loc_vars = function(self, info_queue, card)
        local suits = {'overdesigned_spade', 'overdesigned_heart', 'overdesigned_club', 'overdesigned_diamond'}
        local suffix_loc = card.ability.extra.suffix
        local prefix_loc = card.ability.extra.prefix
        for k, v in pairs(suffix_table) do
            if card.ability.extra.suffix == v then
                local temp_loc = localize(k)
                if temp_loc and temp_loc ~="ERROR"  then
                    suffix_loc = ' ' .. temp_loc .. ' '
                end
                break
            end
        end
        for k, v in pairs(prefix_table) do
            if card.ability.extra.prefix == v then
                local temp_loc = localize(k)
                if temp_loc then
                    prefix_loc = temp_loc..' '
                end
                break
            end
        end
        for i, key in ipairs(suits) do
          info_queue[#info_queue+1] = {set = 'Other', key = key}
        end
        return {
            vars = {
                localize(card.ability.suit, "suits_overdesigned") or card.ability.suit,
                card.ability.amount,
                prefix_loc,
                card.ability.extra.symbol,
                suffix_loc,
                colours = {
                    card.ability.extra.colours.suit,
                    card.ability.extra.colours.amount,
                    card.ability.extra.colours.background
                }
            }
        }
    end,
  
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local cardd = context.other_card
            local orig_suit = card.ability.suit
            local orig_amount = card.ability.amount
            if not context.blueprint then
            local suit_info, suffix_info, colour_info = jest_overdesigned_joker_cycle(card.ability.suit)
            card.ability.suit = suit_info[1]
            card.ability.amount = suit_info[2]
            card.ability.extra.prefix = suffix_info[1]
            card.ability.extra.symbol = suffix_info[2]
            card.ability.extra.suffix = suffix_info[3]
            card.ability.extra.colours.suit = colour_info[1]
            card.ability.extra.colours.amount = colour_info[2]
            card.ability.extra.colours.background = colour_info[3] or G.C.WHITE
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(card.ability.suit, "suits_overdesigned") or card.ability.suit, colour = G.C.FILTER})
            end
            if cardd:is_suit(orig_suit.."s") then
                if orig_suit == "Club" then
                    return {
                        mult = orig_amount,
                        card = card
                    }
                elseif orig_suit == "Diamond" then
                    return {
                        dollars = orig_amount,
                        card = card
                    }
                elseif orig_suit == "Spade" then
                    return {
                        chips = orig_amount,
                        card = card
                    }
                elseif orig_suit == "Heart" then
                    return {
                        x_mult = orig_amount,
                        card = card
                    }
                end
            end
        end
    end
  
}
return { name = {"Jokers"}, items = {overdesigned_joker} }
