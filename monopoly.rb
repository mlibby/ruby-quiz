#!/usr/bin/ruby -w

class Monopoly

  class Board
    attr_reader :squares

    def initialize
      @squares = 
        [
         [:go, :misc],
         [:mediterranean_ave, :property],
         [:community_chest_1, :draw, :chest],
         [:baltic_ave, :property],
         [:income_tax, :misc],
         [:reading, :railroad],
         [:oriental_ave, :property],
         [:chance_1, :draw, :chance], 
         [:vermont_ave, :property], 
         [:connecticut_ave, :property], 
         [:jail, :misc],
         [:st_charles_pl, :property], 
         [:electric_co, :util], 
         [:states_ave, :property],
         [:virginia_ave, :property], 
         [:pennsylvania, :railroad], 
         [:st_james_pl, :property],
         [:community_chest_2, :draw, :chest], 
         [:tennessee_ave, :property], 
         [:new_york_ave, :property],
         [:free_parking, :misc],
         [:kentucky_ave, :property], 
         [:chance_2, :draw, :chance],
         [:indiana_ave, :property],
         [:illinois_ave, :property], 
         [:b_and_o, :railroad],
         [:atlantic_ave, :property],
         [:ventnor_ave, :property], 
         [:water_works, :property], 
         [:marvin_gardens, :property],
         [:go_to_jail, :adv, :jail],
         [:pacific_ave, :property], 
         [:north_carolina_ave, :property],
         [:community_chest_3, :draw, :chest],
         [:pennsylvania_ave, :property],
         [:short_line, :railroad],
         [:chance_3, :draw, :chance],
         [:park_place, :property], 
         [:luxury_tax, :misc], 
         [:boardwalk , :property]
        ]
    end
    
    def move(start, adjust)
      idx = nil
      0.upto(39) do |x|
        if(@squares[x][0] == start)
          idx = x
          break
        end
      end
      raise "unknown starting position #{start}" unless idx
      idx = (idx + adjust) % 39
      return @squares[idx][0]
    end

  end #class Board

  class Cards
    class Base
      def card_names
        @cards.keys
      end
    end

    class Chance < Base
      def initialize
        @cards = { 
          :adv_go => "go",
          :adv_illinois_ave => "illinois_ave",
          :adv_utility => "util",
          :adv_rr_1 => "railroad",
          :adv_rr_2 => "railroad", 
          :adv_st_charles_pl => "st_charles_pl",
          :bank_dividend => nil,
          :get_out_jail_free => nil,
          :adv_back_three => -3,
          :adv_jail => "jail",
          :make_repairs => nil, 
          :speeding_fine => nil, 
          :adv_reading_rr => "reading",
          :adv_boardwalk => "boardwalk", 
          :elected_chairman => nil,
          :building_loan_matures => nil
        }
      end
    end # class Chance

    class CommunityChest < Base
      def initialize
        @cards = {
          :adv_go => "go", 
          :bank_error => nil, 
          :doctors_fees => nil,
          :get_out_jail_free => nil,
          :adv_jail => "jail", 
          :birthday => nil, 
          :tax_refund => nil,
          :life_insurance => nil,
          :pay_hospital => nil,
          :pay_school => nil,
          :consulting => nil, 
          :street_repairs => nil,
          :second_prize => nil, 
          :inherit => nil,
          :sale_stock => nil,
          :holiday_fund => nil
        }
      end
    end # class CommunityChest
    
  end # class Monopoly::Cards

end # class Monopoly
