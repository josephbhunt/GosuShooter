module Collidable
  def box_points
    rdx = @x + @image.width / 2
    rdy = @y + @image.height / 2
    rux = @x + @image.width / 2
    ruy = @y - @image.height / 2
    ldx = @x - @image.width / 2
    ldy = @y + @image.height / 2
    lux = @x - @image.width / 2
    luy = @y - @image.height / 2
    {rd: [rdx, rdy], ru: [rux, ruy], ld: [ldx, ldy], lu: [lux, luy]}
  end

  def collided_with?(collidable_entity)
    return false  if dead? || collidable_entity.dead?
    collision_points = collidable_entity.box_points.values.map do |points|
      points[0] <= box_points[:rd][0] && points[1] <= box_points[:rd][1] &&
      points[0] <= box_points[:ru][0] && points[1] >= box_points[:ru][1] &&
      points[0] >= box_points[:ld][0] && points[1] <= box_points[:ld][1] &&
      points[0] >= box_points[:lu][0] && points[1] >= box_points[:lu][1]
    end
    collision_points.any?
  end

  def die
    @dead = true
  end

  def dead?
    @dead
  end

  def live?
    !dead?
  end
end
