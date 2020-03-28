require_relative 'normal_award'

class BlueFirst < NormalAward
  #Blue First 2x on expiry

  def update!
    add = expires_in > 0 ? 1 : 2
    @quality = [@quality + add, 50].min
    @expires_in -= 1
  end

end
