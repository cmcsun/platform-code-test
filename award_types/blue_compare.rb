require_relative 'normal_award'

class BlueCompare < NormalAward
  #set these
  LONG_EXPIRED = 10
  MEDIUM_EXPIRED = 5

  # Blue Compare increases in value each day before it expires
  # Increases 2 while under 10 days
  # Increases 3 while under 5 days
  # Becomes 0 upon expiry

  def update! #update
    if @expires_in > LONG_EXPIRED
      add = 1
    elsif @expires_in > MEDIUM_EXPIRED
      add = 2
    elsif @expires_in > 0
      add = 3
    end
    @quality = @expires_in > 0 ? [@quality + add, 50].min : 0
    @expires_in -= 1
  end

end
