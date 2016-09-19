require 'torch'
require 'game'
require 'nn'
require 'math'
require 'os'

dataset = {}
data_num = 0

--Create strategy network for ttt
mlp = nn.Sequential()
input = 9
hidden1 = 120
output = 1
mlp:add(nn.Linear(input, hidden1))
mlp:add(nn.Tanh())
mlp:add(nn.Linear(hidden1, output))

-- Returns board input to network, data zero mean
function board_tensor(board)
    board_init = torch.Tensor(3,3):copy(board)
    for x=1,3 do
        for y=1,3 do
            if board_init[x][y] == 2 then
                board_init[x][y] = 1
            elseif board_init[x][y] == 1 then
                board_init[x][y] = -1
            end
        end
    end
    board_final = torch.Tensor(9):copy(board_init)
    return board_final
end 

function win_map(win)
    tensor_win = torch.Tensor(1);
    if win == 1 then
        tensor_win[1] = -1
    elseif win == 2 then
        tensor_win[1] = 1
    elseif win == 3 then
        tensor_win[1] = 0
    end
    return tensor_win
end

-- Determine the best move given the current state of the network
function best_move_neural(player, ttt)
    board_old = ttt.board
    set = false
    for x = 1,3 do       
        for y = 1,3 do
            board_new = move_alt(board_old, player, x, y)
            val_data = mlp:forward(board_tensor(board_new))
            val = val_data[1]
            if ttt:legal(x,y) then
                if not set then
                    best_val = val
                    best_x = x 
                    best_y = y
                    set = true
                elseif player == 1 then
                    if val < best_val then
                        best_val = val
                        best_x = x 
                        best_y = y
                    end
                elseif player == 2 then
                    if val > best_val then
                        best_val = val
                        best_x = x 
                        best_y = y
                    end
                end
            end
        end
    end
    return best_x, best_y
end

-- Make a random move
function best_move(player, ttt)
    board_old = ttt.board
    set = false
    for x = 1,3 do       
        for y = 1,3 do
            board_new = move_alt(board_old, player, x, y)
            val = math.random()
            if ttt:legal(x,y) then
                if not set then
                    best_val = val
                    best_x = x 
                    best_y = y
                    set = true
                elseif player == 1 then
                    if val < best_val then
                        best_val = val
                        best_x = x 
                        best_y = y
                    end
                elseif player == 2 then
                    if val > best_val then
                        best_val = val
                        best_x = x 
                        best_y = y
                    end
                end
            end
        end
    end
    return best_x, best_y
end

-- Have the network play a round against itself
function play_round_real(ttt, dataset)
    player = 1
    move_num = 0
    while ttt.win == 0 do
        print("move " .. move_num)
        move_num = move_num + 1      
        x, y = best_move_real(player, ttt)
        ttt:move(player, x, y)
        if player == 1 then
            player = 2
        else
            player = 1 
        end
        ttt:winner()      
        input[move_num] = board_tensor(ttt.board)
        print(ttt.board)
    end 
    ttt:reset()
end

-- Have the network play a round against itself for training
function play_round(ttt, dataset)
    input = {}
    output = {}
    player = 1
    move_num = 0
    while ttt.win == 0 do
        move_num = move_num + 1      
        x, y = best_move(player, ttt)
        ttt:move(player, x, y)
        if player == 1 then
            player = 2
        else
            player = 1 
        end
        ttt:winner()      
        input[move_num] = torch.Tensor(9):copy(board_tensor(ttt.board))
    end 
    for i = 1,move_num do
        output[i] = win_map(ttt.win)
        dataset[data_num + i] = {input[i], output[i]}  
    end
    data_num = data_num + move_num
    ttt:reset()
end

function gather_data(dataset)
    for j = 1,1 do
        print("learning phase" .. j)
        for i =1,5000 do
            epsilon = 1/j
            game_num = i
            print("game " .. game_num)
            play_round(game, dataset)
        end
        criterion = nn.MSECriterion()  
        trainer = nn.StochasticGradient(mlp, criterion)
        trainer.maxIteration = 30
        trainer.learningRate = 0.01
        trainer:train(dataset)
        data_num = 0
        dataset = {}
        function dataset:size() return data_num end
        play_round_real(game, dataset)
    end
    torch.save("ttt_model.t7", mlp)
end

dataset = {};
function dataset:size() return data_num end
game = TTT.create()

