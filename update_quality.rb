require 'award_types/base_award'

def update_quality(awards)
  awards.each{ |award| award.update! }
end
