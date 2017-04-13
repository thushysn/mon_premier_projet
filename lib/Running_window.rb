require 'gosu'

class Window < Gosu::Window

  def initialize
    super(960, 480)
    self.caption = "Cours Forest !"
	
	@hero = Gosu::Image.new(self, 'images/essai.png', true)
	@background = Gosu::Image.new(self, 'images/mako.png', true)
	@hero_position = [50, 348]
	end

	def update
		if Gosu::button_down?(Gosu::KbRight)
			move(:right)
		elsif Gosu::button_down?(Gosu::KbLeft)
		move(:left)
		jump if Gosu::button_down?(Gosu::KbSpace)
		handle_jump if @jumping
		end
	end
	
	def handle_jump
		gravity = 1.75
		ground_level = 348
		@hero_position = [@hero_position[0], @hero_position[1] - @vertical_velocity]
		
		if @vertical_velocity.round == 0
			@vertical_velocity = -1
		elsif @vertical_velocity < 0 
		 @vertical_velocity = vertical_velocity * gravity
		else
		 @vertical_velocity = @vertical_velocity / gravity
		end
		
		if @hero_position[1] >= ground_level
			@hero_position[1] = ground_level
		@jumping = false
		end
	end
	
	def jump
		return if @jumping
		@jumping = true
		@vertical_velocity = 30
	end
	
	def move (way)
		speed = 5
		if way == :right
			@hero_position[0] += speed
		else
			@hero_position[0] -= speed
		end
	end
	
	def draw
		@background.draw(0, 0, 0)
		@hero.draw(@hero_position[0], @hero_position[1], 1)
	end	
end

window = Window.new
window.show
