class Game
  def initialize(player1, player2, board)
    @players = [player1, player2]
    @player_cycle = @players.cycle
    @current_player = @player_cycle.next
    @board = board
  end

  def play
    puts "Let the game begin!"

    loop do
      @board.display
      position = ask_for_move

      if @board.valid_move?(position)
        @board.update(position, @current_player.symbol)

        if @board.winner?(@current_player.symbol)
          @board.display
          puts "#{@current_player.name} (#{@current_player.symbol}) wins!"
          break
        elsif @board.full?
          @board.display
          puts "It's a draw! Good game!"
          break
        else
          switch_player
        end
      else
        puts "Invalid move: the position's already taken! Please try again."
      end
    end
  end

  private # These methods are only used internally by this class

  def ask_for_move
    loop do
      puts "#{@current_player.name} (#{@current_player.symbol}), pick a position from 1-9: "
      input = gets&.chomp&.strip

      if input.nil?
        puts "Goodbye!"
        exit
      end

      position = input.to_i

      if @board.valid_move?(position)
        return position
      else
        puts "Invalid move. Please try again."
      end
    end
  end

  def switch_player
    @current_player = @player_cycle.next
  end
end

class Board
  def initialize
    @cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def display
    puts ""
    rows = @cells.each_slice(3).map { |row| " #{row.join(' |')} " }
    puts rows.join("\n-----------\n")
    puts ""
  end

  def valid_move?(position)
    return false unless position.between?(1, 9)
    cell_content = @cells[position - 1]
    cell_content.is_a?(Integer) && cell_content.between?(1, 9)
  end

  def update(position, symbol)
    @cells[position - 1] = symbol
  end

  def winner?(symbol)
    winning_combos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], # rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], # columns
      [0, 4, 8], [2, 4, 6]             # diagonals
    ]

    #Checks if at least one combo meets win condition -> checks every cell in the combo has the same symbol
    winning_combos.any? do |combo|
      combo.all? { |index| @cells[index] == symbol }
    end
  end

  def full?
    @cells.none? { |cell| cell.is_a?(Integer) }
  end
end

class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

def create_players
  puts "Enter name for Player 1: "
  name1 = gets.chomp.strip

  puts "Choose a single-letter symbol for #{name1} (ex. X or O): "
  symbol1 = gets.chomp.strip.upcase

  while symbol1.length != 1 || symbol1.match(/\d/)
    puts "Symbol must be a single non-number character. Please try again: "
    symbol1 = gets.chomp.strip.upcase
  end

  puts "Enter name for Player 2: "
  name2 = gets.chomp.strip

  while name2 == name1
    puts "That name is already taken. Please choose a different name: "
    name2 = gets.chomp.strip
  end

  puts "Choose a single-letter symbol for #{name2} (ex. X or O): "
  symbol2 = gets.chomp.strip.upcase

  while symbol2 == symbol1 || symbol2.length != 1 || symbol2.match?(/\d/)
    puts "Symbol must be a single non-number character and not already taken. Please try again: "
    symbol2 = gets.chomp.strip.upcase
  end

  player1 = Player.new(name1, symbol1)
  player2 = Player.new(name2, symbol2)
  [player1, player2]
end

# Testing area
players = create_players
board = Board.new
game = Game.new(players[0], players[1], board)
game.play