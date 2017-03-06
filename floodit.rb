def splash_screen()
  width = 14 # Adding default width
  height = 9 # Adding default height
    
  #Creating 2D array which will store record values for different sized boards
  record = Array.new(1500)
  record.map! { Array.new(1500) }
    
  require 'console_splash' # Requiring console_splash gem
  
  # Creating splash screen
  splash = ConsoleSplash.new()
  splash = ConsoleSplash.new(15, 40) #=> 15 lines, 40 columns
  splash.write_header("Flood-it", "Benediktas Kazanavicius", "0.0.1")
  splash.write_center(-3, "Press ENTER to start")
  splash.write_horizontal_pattern("=")
  splash.write_vertical_pattern("*")
  splash.splash
    
  gets # Waiting for user to press ENTER
  puts
  print_menu(record, width, height) # Going to print_menu method
end
    
def print_menu(record, width, height)
    puts "Main menu:"
    puts "s = Start Game"
    puts "c = Change Size"
    puts "q = Quit"
    
    # If no games were played on certain board size then element won't have any value
    if record[width][height] == nil
        puts "No games played yet"
    else # If games were played then displaying record on that certain board size
        print "Best game: "
        print record[width][height]
        puts " turns"
    end
    
    # Asking user for input and starting method according to answer
    # If user's input is wrong then writing "Wrong command" and printing menu again
    print "Please enter your choice: "
    command = gets.chomp
    if command == 's' then
        create_board(width, height, record)
    elsif command == 'c' then
        change_size(record, width, height)
    elsif command == 'q' then
        exit
    else
        puts "Wrong command"
        print_menu(record, width, height)
    end    
end   

# Method to change board's size
def change_size(record, width, height)
    print "What width do you want? (Currently "
    print width
    print " ): "
    width = gets.chomp.to_i
    print "What height do you want? (Currently "
    print height
    print " ): "
    height = gets.chomp.to_i
    print_menu(record, width, height) # After getting new board size, going back to main menu
end

# Creating board
def create_board(width, height ,record)
    board = get_board(width, height)
    board_completed = Array.new(height)
    board_completed.map! { Array.new(width) }
    require 'colorize'
    (0..height-1).each do |i|
        (0..width-1).each do |j|
                board_completed[i][j] = :none
        end
    end
    turns = 0 # Assigning turns value to 0
    current_completion = 0 # Assigning current_completion value to 0
    board_completed[0][0] = board[0][0] # Completed board 0;0 element is the same as randomized board's
    recursion_count=0 # Assigning recursion_count value to 0
    
    # Checking if more then 0;0 is connected when board is created
    recursion(record, width,height,board_completed,board,recursion_count,turns,current_completion) 
end 

# Randomising board
def get_board(width, height)
    # Creating board array in which I will store randomized board
     board = Array.new(height)
     board.map! { Array.new(width) } 
    
        # Randomising every color in array
        (0..height-1).each do |i|
            (0..width-1).each do |j|
                 random = rand(1..6)
                 if random == 1
                     board[i][j] = :red
                 elsif random == 2
                    board[i][j] = :green
                 elsif random == 3
                     board[i][j] = :blue
                 elsif random == 4
                     board[i][j] = :yellow
                 elsif random == 5
                     board[i][j] = :magenta
                 elsif random == 6
                     board[i][j] = :cyan
                 end
            end
        end
    return board
end    

# method which will check and connect board_completed
def recursion(record, width,height,board_completed,board,recursion_count,turns,current_completion)
        change = false
       # recursion_count+=1 # Increasing recursion_count by one every time
        (0..height-1).each do |i|
            (0..width-1).each do |j|
                # Checking if rectangle on the right is the same as [i][j] and adding it to board_completed
                if j + 1 <= width - 1 && board_completed[i][j] == board[i][j+1] 
                    board_completed[i][j+1]=board_completed[i][j]
                    board[i][j + 1] = :nonen # When rectangle is connected changing randomized board's rectangle to never used value
                    change = true
                end
                
                # Checking if rectangle on the bottom is the same as [i][j] and adding it to board_completed                
                if i+1 <= height - 1 && board_completed[i][j] == board[i + 1][j] 
                    board_completed[i + 1][j] = board_completed[i][j]  
                    board[i + 1][j] = :nonen # When rectangle is connected changing randomized board's rectangle to never used value
                    change = true
                end
                
                # Checking if rectangle on the left is the same as [i][j] and adding it to board_completed
                if j - 1 >= 0 && board_completed[i][j]==board[i][j - 1] 
                    board_completed[i][j - 1]=board_completed[i][j]
                    board[i][j - 1] = :nonen # When rectangle is connected changing randomized board's rectangle to never used value
                    change = true
                end
                
                # Checking if rectangle on the top is the same as [i][j] and adding it to board_completed
                if i - 1 >= 0 && board_completed[i][j] == board[i - 1][j] 
                    board_completed[i - 1][j] = board_completed[i][j]
                    board[i - 1][j] = :nonen # When rectangle is connected changing randomized board's rectangle to never used value
                    change = true                   
                 end
             end
         end
 
        # If change is happenning, keep running recursion method
        if change == true
            recursion(record, width, height, board_completed, board, recursion_count, turns, current_completion)            
        # If isn't changing go to update_board method
        else
            update_board(record, width, height, board, board_completed, turns, current_completion, recursion_count)
        end
end    

# update_board method which will update board
def update_board(record, width, height, board, board_completed, turns, current_completion, recursion_count)
     # Printing board with new values
        (0..height-1).each do |i|
            (0..width-1).each do |j|
                    # If the rectangle is not connected to completed part then rectangle from randomized board is painted
                    if board_completed[i][j] == :none
                    print "  ".colorize( :background => board[i][j])
                    
                    # If rectangle is connected to completed rectangles -> painting board_completed rectangles
                    else 
                        print "  ".colorize( :background => board_completed[i][j])
                    end 
            end
            puts
    end
    
    current_completionNumber = 0 # Setting current_completionNumber to 0
    
    # loop to check how much of the game is completed
        (0..height-1).each do |i|
            (0..width-1).each do |j|
                    if board_completed[0][0] == board_completed[i][j]
                    current_completionNumber += 1
                    elsif board_completed[0][0] == board[i][j]
                    current_completionNumber += 1
                    end 
            end
    end
    
    # Formula to check percentage of how much of the game is completed
    current_completion = current_completionNumber.to_f / (height.to_f*width.to_f) * 100.to_f
    
    # Checking if the game is completed
    if current_completion == 100
        puts "You won after #{turns} turns"
        
        # Output if the game on certain difficulty is completed for the first time and adding a record
        if record[width][height] == nil
             record[width][height] = turns
             puts "You completed this difficulty for the first time in #{turns} turns"
            
        # Output if a new record was achieved on certain difficulty and setting new record
        elsif record[width][height].to_i > turns
             record[width][height] = turns
            puts "Your new record is  #{turns} turns"
        
        # If the record is better than last game outputting a record
        else
            puts "Your record is #{record[width][height]}"
        end
        
        print "Press enter to proceed to main menu"
        gets # Waiting for user to press ENTER.(made this to allow user to read outputs)
        print_menu(record,width,height) # Printing menu
    end
    
    # Printing turns, current_completion and asking user to choose a colour
    print "Turns: "
    puts turns
    print "Current completion: "
    print current_completion.to_i
    puts "%"
    print "Choose a colour: "
    colour = gets.chomp
    
    # When colour is selected all board_completed area is made to selected colour
    if colour == "y"
            (0..height-1).each do |i|
                (0..width-1).each do |j|
                           if board_completed[i][j] != :none
                               board_completed[i][j] = :yellow
                           end
                    end
                end
    
    elsif colour == "b"
                (0..height-1).each do |i|
                    (0..width-1).each do |j|
                           if board_completed[i][j] != :none
                               board_completed[i][j] = :blue
                           end
                    end
                end
    
    elsif colour == "g"
                (0..height-1).each do |i|
                    (0..width-1).each do |j|
                           if board_completed[i][j] != :none
                               board_completed[i][j] = :green
                           end
                    end
                end
    
    elsif colour == "r"
                (0..height-1).each do |i|
                    (0..width-1).each do |j|
                           if board_completed[i][j] != :none
                               board_completed[i][j] = :red
                           end
                    end
                end
    
    elsif colour == "m"
                (0..height-1).each do |i|
                    (0..width-1).each do |j|
                           if board_completed[i][j] != :none
                               board_completed[i][j] = :magenta
                           end
                    end
                end
    
    elsif colour == "c"
                (0..height-1).each do |i|
                    (0..width-1).each do |j|
                           if board_completed[i][j] != :none
                               board_completed[i][j] = :cyan
                           end
                    end
                end
    # If input is q then moving to main menu
    elsif colour == 'q' then
         print_menu(record, width, height)
        
    # If input is not recognised then outputting "Wrong command" and starting update_board method again
    else
        puts "Wrong command"
        update_board(record, width, height, board, board_completed, turns, current_completion, recursion_count)   
    end
        
    turns += 1 # After turn is made adding value 1 to turns
    recursion(record, width, height, board_completed, board, recursion_count, turns, current_completion) # Starting recursion function
end
    
# Main program
splash_screen # Starting from splash screen
    