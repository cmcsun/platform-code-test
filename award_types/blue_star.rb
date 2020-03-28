require_relative 'normal_award'

class BlueStar < NormalAward

  # BlueStar lose quality value 2x faster than normal awards.

  def update! #update!
    diff = expires_in > 0 ? 2 : 4
    @quality = [@quality - diff, 0].max
    @expires_in -= 1
  end

end
