# require 'rloss'
require_relative 'display'

# Chained example:
display(800, 600) do
  # show
#   picture("image.png")
#         .translate(100, 150)
#         .scale(2, 2)
#         .rotate(45)
#         .flip_horizontal
#         .crop(10, 10, 200, 200)
#         .resize(400, 300)
#         .brightness(70)
#         .color(255, 0, 0)
#         .thickness(5)
#         .blendmode(:multiply)
#         .contrast(1.2)
#         .saturation(0.8)
#         .grayscale
#         .sepia
#         .render
#     thick_arc(100, 50, 0, 180, 10)
#         .color(255, 0, 0)
#         .thickness(5)
#         .blendmode(:multiply)
#         .contrast(1.2)
#         .saturation(0.8)
#         .grayscale
#         .sepia
#         .render
    Bitmap "bitmap.png"
        .translate(220, 150)
        .scale(1, 1)
        .rotate(0)
        .render
end
