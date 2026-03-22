require 'gosu'
require 'rooibos'

# Example usage:
Rooibos::display 800, 600 do
  caption "My Gosu Window"
  background_color Gosu::Color::WHITE

  on_update do
    # Update logic can be added here if needed
  end

  on_button_down(Gosu::KB_SPACE) do
    puts "Space key was pressed!"
  end

  on_draw do
    text "Hello, World!", "Arial", 24 do
      translate 400, 100
      scale 1, 1
      color Gosu::Color::RED
      thickness 1
      rotate 15
      # render
    end

    bitmap "bitmap.png" do
      translate 120, 150
      scale 1, 1
      #   render
    end

    line(200, 10) do
      translate 50, 50
      color Gosu::Color::BLUE
      thickness 3
      # render
    end

    rectangle(150, 100) do
      translate 300, 200
      color Gosu::Color::GREEN
      thickness 4
      # render
    end

    tilemap("tileset.png", 32, 32, 0) do
      translate 500, 300
      scale 2, 2
      # render
    end
  end

#   show
#   picture("image.png") do
#     render
#     translate(100, 150)
#     scale(2, 2)
#     rotate(45)
#     flip_horizontal
#     crop(10, 10, 200, 200)
#     resize(400, 300)
#     brightness(70)
#     color(255, 0, 0)
#     thickness(5)
#     blendmode("multiply")
#     contrast(50)
#     saturation(80)
#     grayscale
#     sepia
#   end
  
  
#   circle(50) do
#     render
#     color(0, 255, 0)
#     thickness(3)
#   end
  
#   line(100) do
#     render
#     color(0, 0, 255)
#     thickness(2)
#   end
  
#   rectangle(200, 100) do
#     render
#     color(255, 255, 0)
#     thickness(4)
#   end
  
#   ellipse(80, 40) do
#     render
#     color(255, 0, 255)
#     thickness(3)
#   end
  
#   polygon(5, 60) do
#     render
#     color(0, 255, 255)
#     thickness(2)
#   end
  
#   polyline([[0,0], [50,100], [100,50]]) do
#     render
#     color(128, 128, 128)
#     thickness(2)
#   end
  
#   bezier_curve([[0,0], [50,150], [100,0]]) do
#     render
#     color(255, 165, 0)
#     thickness(3)
#   end
  
#   arc(70, 70, 0, 180) do
#     render
#     color(0, 128, 0)
#     thickness(2)
#   end
  
#   thick_arc(90, 90, 0, 270, 10) do
#     render
#     color(128, 0, 128)
#   end
  
#   pie_slice(60, 60, 0, 90)
#     text_box("Sample Text", 150, 50) do
#     render
#     color(0, 0, 0)
#     thickness(1)
#   end
  
#   sprite("sprite.png", 300, 400) do
#     render
#     scale(1.5, 1.5)
#     rotate(30)
#   end
end
