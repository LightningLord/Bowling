class Game
	@@length_of_game = 10
	def initialize
		@frames = []
	end

	def update_bonus
		(@frames.count - 1).times do |index| #bonus points are scored as base points for the last frame
			frame = @frames[index]
			next_frame = @frames[index + 1]
			if frame.spare?
				frame.bonus += next_frame.first_roll 
			elsif frame.strike? 
				if !next_frame.strike?
					frame.bonus += (next_frame.first_roll + next_frame.second_roll)
				else
					if @frames[index + 2]
						next_next_frame = @frames[index + 2]  
						frame.bonus += (next_frame.first_roll + next_next_frame.first_roll)
					else #endgame logic
						frame.bonus += (next_frame.first_roll + next_frame.second_roll)
					end
				end #end of !next_frame.strike?
			end #end of frame.spare?
		end #end of loop
	end #end of update_bonus

	def execute_frame(number)
		@frames << Frame.new(number)
		@frames.last.roll_one
	end


	def play
		(@@length_of_game).times {|i| execute_frame(i+1)}
		update_bonus
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
		puts "Final Score: #{score}"
	end

end

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
		if (@first_roll < @@total_pins) || (strike? && @frame_number == 10) #non-strikes or last frame strikes
			pins_left = @@total_pins - @first_roll
			roll_two(pins_left)
		else
			@base_score += @@total_pins #all other strikes
		end
	end

	def roll_two(pins_left)
		@second_roll = pins_left == 0 ?  rand(@@total_pins + 1) :  rand(pins_left + 1)
		@base_score += (@first_roll + @second_roll)
		if @frame_number == 10 
			roll_three if strike?
			roll_three if spare?
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
#testing (if quick)
#last point bonus logic (best practice?)

