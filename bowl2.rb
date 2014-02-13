class Game
	@@length_of_game = 10
	def initialize
		@frames = []
		@score = 0

	end

	def calculate_total_score
		update_bonus
		@frames.each {|frame| @score += (frame.base_score + frame.bonus)}
		return @score
	end

	def update_bonus
		(@frames.count - 1).times do |index|
			frame = @frames[index]
			next_frame = @frames[index + 1] if @frames[index+1]


			if frame.spare?
				frame.bonus += next_frame.first_roll if next_frame
			elsif frame.strike? && next_frame
				if !next_frame.strike?
					frame.bonus += (next_frame.first_roll + next_frame.second_roll)
				else
					if @frames[index + 2]
						next_next_frame = @frames[index + 2]  #if walking off array, access later rolls instead of next frames
						if next_next_frame.strike?
							frame.bonus += (next_frame.first_roll + next_next_frame.first_roll)
						else
							frame.bonus += (next_frame.first_roll + next_frame.second_roll)
						end
					else
						frame.bonus += (next_frame.first_roll + next_frame.second_roll)
					end
				end
			end
		end
	end

	def execute_frame(number)
		@frames << Frame.new(number)
		@frames.last.roll_one
		
	end


	def play
		(@@length_of_game).times {|i| execute_frame(i+1)}
		calculate_total_score
		display_score
	end

	def display_score
		score = 0
		@frames.each do |frame|
			score += (frame.base_score + frame.bonus)
			puts "Frame: #{frame.frame_number}"
			puts "First roll: #{frame.first_roll}"
			puts "Second roll: #{frame.second_roll}"
			puts "Third roll: #{frame.third_roll}" if frame.third_roll
			puts "Strike!" if frame.strike?
			puts "Spare!"  if frame.spare?
			puts "Total score: #{score}"
			puts
		end
		puts "Final Score: #{@score}"
	end


end

#attributes: score_added first_roll, second_roll, 
class Frame
	@@total_pins = 10
	attr_reader :first_roll, :second_roll, :base_score, :frame_number, :third_roll
	attr_accessor :bonus

	def initialize(frame_number)
		@frame_number = frame_number
		@base_score = 0
		@bonus = 0
	end

	def strike?
		@first_roll == @@total_pins
	end

	def spare?
		!strike? && (first_roll + second_roll == @@total_pins)
	end

	def roll_one
		@first_roll = rand(@@total_pins + 1)

		if (@first_roll < @@total_pins) || (@first_roll == @@total_pins && @frame_number == 10)
			pins_left = @@total_pins - @first_roll
			roll_two(pins_left)
		else
			@base_score += @@total_pins
		end
	end

	def roll_two(pins_left)
		@second_roll = rand(pins_left + 1)
		@base_score += (@first_roll + @second_roll)

		if @frame_number == 10 
			roll_three if @first_roll == 10
			roll_three if (@first_roll + @second_roll == @@total_pins) && @first_roll != @@total_pins	
		end

	end

	def roll_three
		@third_roll = rand(@@total_pins + 1)
		@base_score += (@third_roll)
	end

end

game = Game.new
game.play


#refactoring
#testing (last two frames are both strikes)

