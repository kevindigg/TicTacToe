class Game
    @winner=nil

    def initialize
        @p1 = Player.new("x")
        @p2 = Player.new("o")

        @b=Board.new
    end

    def play
        current_player = @p1
        next_player = @p2

        while !@winner
            puts @b.to_s
            begin
                puts "Where to, #{current_player.name}?"
                move = gets.chomp()
                @b.move(move.to_i,current_player.value)
            rescue StandardError => e
                puts e
                retry
            rescue Interrupt
                exit
            end
            current_player, next_player = next_player, current_player
            @winner = @b.status
        end

        puts @b.to_s
        puts "Winner was #{Player.get_player(@winner)}"
    end
end


class Board
    def initialize
        @board = []
        @board.fill(0,0..8)
    end

    def to_s
        boardString = ""
        for i in 0..@board.length
            boardString += i % 3 == 0 ? "\n" : " "
            case @board[i]
            when 0
                boardString += "#{i}"
            when 1
                boardString += "X"
            when -1
                boardString += "O"             
            end
        end
        boardString
    end

    def move (loc, value)
        raise StandardError, "Out of bounds"  if loc >= @board.length
        raise StandardError, "Space not available" if @board[loc] != 0

        @board[loc] = value 
    end

    def status
        #row
        for i in (0...@board.length).step(3)
            r_sum = @board[i..i+2].reduce(:+)
            return r_sum/r_sum.abs if r_sum.abs == 3
        end
        #column
        for i in (0..2)
            c_sum = 0
            for j in (i...@board.length).step(3)
                c_sum += @board[j]
                return c_sum/c_sum.abs if c_sum.abs == 3
            end
        end

        #diagonal
        d1 = @board[0] + @board[4] + @board[8]
        return d1/d1.abs if d1.abs == 3

        d2 = @board[2] + @board[4] + @board[6]
        return d2/d2.abs if d2.abs == 3

        #draw
        return 0 if !@board.include?(0)

        nil
    end

end

class Player

    attr_reader :value
    SYMBOLS = {"X" => 1, "O" => -1, "no one" => 0}

    def initialize(value)
        @value = SYMBOLS[value.upcase]
    end

    def name
        SYMBOLS.key(@value)
    end

    def self.get_player(value)
        SYMBOLS.key(value)
    end

end

g = Game.new
puts Player.get_player(1)
g.play


