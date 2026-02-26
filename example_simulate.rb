require_relative 'display'

simulate 800, 600 do
  caption "My Gosu Simulation Window"
  background_color Gosu::Color.new(200, 200, 200, 255)
  
  text "Simulating...", "Arial", 24 do
    translate 350, 280
    scale 1, 1
    color Gosu::Color.new(0, 0, 0, 255)
    thickness 1
  end
end do
  # Update logic can be added here if needed
end