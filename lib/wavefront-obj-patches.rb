WavefrontObj.class_eval do
  def from_grid(points, step)
    for i in (0..points.length-2-step).step(step)
      for j in (0..points.first.length-2-step).step(step)
        add_face([points[i][j], points [i][j+step], points[i+step][j+step], points[i+step][j]])
      end
    end
    self
  end
end
