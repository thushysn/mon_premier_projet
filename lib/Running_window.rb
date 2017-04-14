require 'gosu'

class Window < Gosu::Window

  def initialize
    super(960, 480)
    self.caption = "Cours Forest !"
	@flag = Gosu::Image.new(self, 'images/choco.png', true)
	@hero = Gosu::Image.new(self, 'images/essai.png', true)
	@ennemy = Gosu::Image.new(self, 'images/bea.png', true)
	@background = Gosu::Image.new(self, 'images/mako2.png', true)
	@hero_position = [50, 348]
	@ennemy_position = [200, 331]
	@flag_position = [800, 0]
	@music = Gosu::Song.new(self, "musics/choco.wav")
	end

	def update
		jump if Gosu::button_down?(Gosu::KbSpace)
		if Gosu::button_down?(Gosu::KbRight)
			move(:right)
		elsif Gosu::button_down?(Gosu::KbLeft)
		move(:left)
		handle_jump if @jumping
		if @hurt_until
		@current_hero_image = @hero[6]
		@hurt_until = nil if Gosu::milliseconds > @hurt_until
		handle_collisions
		end
end

def handle_collisions
	
	@player_rectangle = {:x => @hero_position[0] + 18,
						 :y => @hero_position[1] +18,
						 :width => @current_hero_image.width - 36,
						 :height => @current_hero_image.height - 18}
	@ennemy_rectangle = {:x => @ennemy_position[0] + 6,
						 :y => @ennemy_position[1] + 20,
						 :width => @ennemy.width - 12,
						 :height => @ennemy.height - 20}
	collision = check_for_collisions(@player_rectangle, @ennemy_rectangle)
	if collision == :left
		@hero_position[0] += 30
		@hurt_until = Gosu::milliseconds + 200
	elsif collision == :right
		@hero_position[0] -= 30
		@hurt_until = Gosu::milliseconds + 200
	elsif collision == :bottom
		@jumping = true
		@vertical_velocity = 10
	end
end

	def jump
		return if @jumping
		@jumping = true
		@vertical_velocity = 30
	end
	
	def handle_jump
		gravity = 1.75
		ground_level = 348
		@hero_position = [@hero_position[0], 
						  @hero_position[1] - @vertical_velocity]
		
		if @vertical_velocity.round == 0
			@vertical_velocity = -1
		elsif @vertical_velocity < 0 
		 @vertical_velocity = @vertical_velocity * gravity
		else
		 @vertical_velocity = @vertical_velocity / gravity
		end
		
		if @hero_position[1] >= ground_level
			@hero_position[1] = ground_level
		@jumping = false
		end
	end
	
	def move (way)
		speed = 5
		if way == :right
			@hero_position[0] += speed
		else
			@hero_position[0] -= speed
		end
	end
	
	def draw_collision_bodies
		draw_bounding_body(@player_rectangle)
		draw_bounding_body(@ennemy_rectangle)
	end
	
	def draw_bounding_body(rect, z = 10, color = Gosu::Color::GREEN)
		return unless $DEBUG
		Gosu::draw_line(rect[:x], rect[:y], color, rect[:x], rect[:y] + rect[:height], color,z)
		Gosu::draw_line(rect[:x], rect[:y] + rect[:height], color, rect[:x] + rect[:width], rect[:y], color, z)
		Gosu::draw_line(rect[:x] + rect[:width], rect[:y] + rect[:height], color, rect[:x] + rect[width], rect[:y], color, z)
		Gosu::draw_line(rect[:x] + rect[:width], rect[:y], color, rect[:x], rect[:y], color, z)
	end
	
	"def check_for_collisions(rect1, rect2)
		intersection = rec_intersection([[rect1[:x], rect1[:y]],
										[rect1[:x] + rect1[:width], rect1[:y] + rect1[:height]]],
										[[rect2[:x], rect2[:y]],
										 [rect2[:x] + rect2[:width], rect2[:y] + rect2[:height]]])
		if intersection
			top_left, bottom_right = intersection
				if(bottom_right[0] - top_left[0]) >
				   (bottom_right[1] - top_left[1])
				if rect[:y] == top_left[1] :top
				else :bottom end
		else 
				if rect1[:x] == top_left[0] :left
				else :right end
			end
		else
		nil
		end
	end
"	
	"def rec_intersection(rect1, rect2)
		x_min = [rect1[0][0], rect2[0][0]].max
		x_max = [rect1[1][0], rect2[1][0]].min
		y_min = [rect1[0][1], rect2[0][1]].max
		y_max = [rect1[1][1], rect2[1][1]].min
		return nil if ((x_max < x_min || (y_max < y_min))
		return [[x_min], [x_max, y_max]]
	end
 	end"
	
	def draw
		@background.draw(0, 0, 0)
		@hero.draw(@hero_position[0], @hero_position[1], 1)
		@ennemy.draw(@ennemy_position[0], @ennemy_position[1], 1)
		@flag.draw(@flag_position[0], @flag_position[1], 1)
		draw_collision_bodies
	end	
 end
end

window = Window.new
window.show
