require 'net/http'
class Hangman
    attr_accessor :chosen_word,:wordLength,:players_word,:used_characters,:turns,:temp_word
    
    def initialize(turns=5)
        @chosen_word = select_word.upcase
        @wordLength = @chosen_word.length
        @players_word = ""
        @used_characters = ""
        @turns = turns
        @temp_word = ""
        for i in 0...@wordLength
            @players_word = @players_word + "_ "
        end
    end


    private
    # Randomly choose words from the given api
    def select_word
        uri = URI('https://random-word-api.herokuapp.com/word?number=5')
        words = Net::HTTP.get(uri)  
        words = words.delete("[").delete("]").delete("\"")
        words = words.split(",")
        index = rand(words.count - 1)
        return words[index]
    end

    def game_over?
        @temp_word= @players_word
        @temp_word=@temp_word.delete(" ")

        @turns == 0 || @temp_word.eql?(@chosen_word) 
    end

    def play_game
        puts "Total turns left : #{@turns}" 
        puts "Your word : #{@players_word}"
        print "Enter a character : " 
        character = gets.chomp().upcase;
      
        #Check input if more than one character is there then it is invalid
        if (character.length > 1) 
          puts "Invalid input" 
          play_game
        end
      
        # Check if  word contains the input character
        if  @chosen_word.include? character
          for i in 0...@wordLength
            if (@chosen_word[i] == character) && (@players_word[i*2] == "_")
              @players_word[i*2] = character 
            elsif @chosen_word[i] == character
              puts "Input character is already used try some new character"
              play_game  
            end
          end
        else 
          @turns -= 1
          @used_characters+= character.upcase.to_s + ","
        end
        puts "The incorrect characters entered are :#{@used_characters}"
      end

    # method to start the game
    public 
    def start_game
        while !game_over
            play_game
        end
          
        puts "Game Over"
        puts "The word was: #{@chosen_word}"
        if @turns > 0
            puts "You Won the game !! you are a genius "
        else
            puts "Better luck next time"
        end
    end
end

h=Hangman.new()
h.start_game