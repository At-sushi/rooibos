# frozen_string_literal: true

require_relative "rooibos/version"

require("gosu")
require("memo_wise")

module Rooibos
  class Error < StandardError; end

  # Display class to manage the Gosu window and rendering
  class Display < Gosu::Window
    def initialize(width, height)
      super(width, height)
      @button_down_block = {}
      puts("Initialized Gosu window with width #{width} and height #{height}.")
    end

    def on_update(&block)
      @block_update = block
    end

    def on_draw(&block)
      @block_draw = block
    end

    def on_button_down(keys, &block)
      @button_down_block[keys] = block
    end

    def update
      for key, value in @button_down_block.each do
        value.call if value and Gosu.button_down?(key)
      end
      self.instance_exec(&@block_update) if @block_update
    end

    def draw
      self.instance_exec(&@block_draw) if @block_draw
    end

    # Method to set background color
    def background_color(color)
      puts("Setting background color to RGB(#{color.red}, #{color.green}, #{color.blue}).")
      @background_color = color
    end

    # Method to set window caption
    def caption(text)
      puts("Setting window caption to '#{text}'.")
      self.caption = text
    end

    # Method to set update interval
    def interval(milliseconds, &block)
      puts("Setting interval to #{milliseconds} milliseconds.")
      self.update_interval = milliseconds
      @interval_block = block
    end

    # Define methods for various graphical elements
    def text(content, font, size, &block)
      ImageTransformer.new(Text.get_image(content, font, size)).instance_exec(&block).render
    end

    def md(content, &block)
      ImageTransformer.new(Md.get_image(content)).instance_exec(&block).render
    end

    def circle(radius, &block)
      ImageTransformer.new(Circle.get_image(radius)).instance_exec(&block).render
    end

    def line(vx, vy, &block)
      Line.new(vx, vy).instance_exec(&block).render
    end

    def rectangle(width, height, &block)
      Rectangle.new(width, height).instance_exec(&block).render
    end

    def polygon(sides, length, &block)
      ImageTransformer.new(Polygon.get_image(sides, length)).instance_exec(&block).render
    end

    def text_box(content, width, height, &block)
      TextBox.new(content, width, height).instance_exec(&block).render
    end

    def sprite(image_path, x, y, &block)
      Sprite.new(image_path, x, y).instance_exec(&block).render
    end

    def bitmap(file_path, &block)
      ImageTransformer.new(Bitmap.get_image(file_path)).instance_exec(&block).render
    end
  end

  # Picture2D module to provide transformation and styling methods for 2D graphics
  module Picture2D
    # Transformation and styling methods
    def translate(x, y)
      puts("Translating image to coordinates (#{x}, #{y}).")
      @x = x
      @y = y
      self
    end

    # Scale method
    def scale(factorx, factory)
      puts("Scaling picture by a factor of #{factorx} in x and #{factory} in y.")
      @scale_x = factorx
      @scale_y = factory
      self
    end

    # Rotate method
    def rotate(angle)
      puts("Rotating picture by #{angle} degrees.")
      @angle = angle
      self
    end

    def resize(width, height)
      puts("Resizing picture to #{width}x#{height}.")
      self
    end

    # Color method
    def color(color)
      puts("Changing picture color to RGB(#{color.red}, #{color.green}, #{color.blue}).")
      @color = color
      self
    end

    # Thickness method
    def thickness(value)
      puts("Setting picture thickness to #{value}.")
      self
    end

    # Blend mode method
    def blendmode(mode)
      puts("Setting picture blend mode to #{mode}.")
      @blend_mode = mode
      self
    end
  end

  #  Base ImageTransformer class
  class ImageTransformer
    include(Picture2D)

    def initialize(image)
      @image = image
    end

    def crop(x, y, width, height)
      @image = @image.subimage(x, y, width, height)
      self
    end

    def saturation(level)
      puts("Adjusting picture saturation to level #{level}.")
      @image.set_saturation(level)
      self
    end

    def render
      puts("Rendering image from.")
      @image.draw_rot((@x or 0), (@y or 0), 0, (@angle or 0), 0.5, 0.5, (@scale_x or 1), (@scale_y or 1), (@color or Gosu::Color::WHITE), (@blend_mode or :default))
    end
  end

  # Text class for rendering text
  class Text
    prepend(MemoWise)

    def self.get_image(content, font, size)
      Gosu::Image.from_text(content, size, :font => font)
    end

    memo_wise(:self => :get_image)
  end

  # Md class for rendering markdown content
  class Md
    prepend(MemoWise)

    def self.get_image(content)
      Gosu::Image.from_md(content)
    end

    memo_wise(:self => :get_image)
  end

  class Circle
    def initialize(radius)
      @radius = radius
    end

    def render
      puts("Rendering circle with radius #{@radius}.")
    end
  end

  class Line
    include(Picture2D)

    def initialize(vx, vy)
      @vx = vx
      @vy = vy
    end

    def render
      puts("Rendering line with vector #{@vx}, #{@vy}.")
      Gosu.draw_line((@x or 0), (@y or 0), (@color or Gosu::Color::WHITE), ((@x or 0) + @vx), ((@y or 0) + @vy), (@color or Gosu::Color::WHITE), (@z or 0), (@blend_mode or :default))
    end
  end

  class Rectangle
    include(Picture2D)

    def initialize(width, height)
      @width = width
      @height = height
    end

    def render
      puts("Rendering rectangle with width #{@width} and height #{@height}.")
      Gosu.draw_rect((@x or 0), (@y or 0), @width, @height, (@color or Gosu::Color::WHITE), (@z or 0), (@blend_mode or :default))
    end
  end

  class Polygon < ImageTransformer
    def initialize(sides, length)
      super()
      @sides = sides
      @length = length
    end

    def render
      puts("Rendering polygon with #{@sides} sides of length #{@length}.")
    end
  end

  #  Bitmap class for rendering bitmap images
  class Bitmap
    prepend(MemoWise)

    def self.get_image(file_path)
      Gosu::Image.new(file_path)
    end

    memo_wise(:self => :get_image)
  end

  class Tilemap
    prepend(MemoWise)

    def initialize(image_path, tile_width, tile_height)
      @images = Tilemap.get_image(image_path, tile_width, tile_height)
    end

    def render
      puts("Rendering tilemap with #{@images.length} tiles.")
      @images.each_with_index do |image, index|
        image.draw(((@x or 0) + ((index % 10) * image.width)), ((@y or 0) + ((index / 10) * image.height)), (@z or 0), (@scale_x or 1), (@scale_y or 1), (@color or Gosu::Color::WHITE), (@blend_mode or :default))
      end
    end

    private

    def self.get_image(image_path, tile_width, tile_height)
      Gosu::Image.from_tilemap(image_path, tile_width, tile_height)
    end

    memo_wise(:self => :get_image)
  end

  # Top-level methods
  def display(width, height, &block)
    gosu = Display.new(width, height)
    gosu.instance_exec(&block)
    gosu.show
  end

  def set_cache_enabled(enabled)
    if enabled
      puts("Enabling cache for image loading.")
    else
      puts("Disabling cache for image loading.")
      Bitmap.reset_memo_wise(:get_image)
      Text.reset_memo_wise(:get_image)
      Md.reset_memo_wise(:get_image)
    end
  end

  # Clear cache at exit
  def clear_cache
    Bitmap.reset_memo_wise(:get_image)
    Text.reset_memo_wise(:get_image)
    Md.reset_memo_wise(:get_image)
  end

  at_exit { clear_cache }
end
