require 'torch'
require 'game'
require 'nn'
require 'math'
require 'os'
require 'strategy'
require 'art_intell'

epsilon = 1
win_count_neural = 0
tie_count_neural = 0
win_count_minimax = 0
tie_count_minimax = 0
win_count_n = 0
tie_count_n = 0
mlp = torch.load("ttt_model.t7")

function play_round_vs_minimax(ttt)
    --print(ttt.board)
    input = {}
    output = {}
    if math.random() > .5 then
        a = 1
        b = 2
    else 
        a = 2
        b = 1
    end
    player = 1
    move_num = 1
    while ttt.win == 0 do
        --print("move " .. move_num)
        move_num = move_num + 1  
        if (player == a) then
            x, y = best_move_minimax(player, ttt)
            ttt:move(player, x, y)  
        end
        if (player == b) then
            x, y = best_move(player, ttt)
            ttt:move(player, x, y)  
        end 
        player = return_player(player)   
        --print(ttt.board)
        ttt:winner()      
    end 
    if ttt.win == a then
        win_count_minimax = win_count_minimax + 1/20
    end
    if ttt.win == 3 then
        tie_count_minimax = tie_count_minimax + 1/20
    end

    data_num = data_num + move_num
    ttt:reset()
end

function play_round_vs_neural(ttt)
    --print(ttt.board)
    input = {}
    output = {}
    if math.random() > .5 then
        a = 1
        b = 2
    else 
        a = 2
        b = 1
    end
    player = 1
    move_num = 1
    while ttt.win == 0 do
        --print("move " .. move_num)
        move_num = move_num + 1             
        if player == a then
            x, y = best_move_neural(player, ttt)
            ttt:move(player, x, y)
            player = b
        else
            x, y = best_move(player, ttt)
            ttt:move(player, x, y)
            player = a
        end
        --print(ttt.board)
        ttt:winner()      
    end 
    if ttt.win == a then
        win_count_n = win_count_n + 1/1000
    end
    if ttt.win == 3 then
        tie_count_n = tie_count_n + 1/1000
    end

    data_num = data_num + move_num
    ttt:reset()
end

function play_round_mini_neural(ttt)
    --print(ttt.board)
    input = {}
    output = {}
    if math.random() > .5 then
        a = 1
        b = 2
    else 
        a = 2
        b = 1
    end
    player = 1
    move_num = 1
    while ttt.win == 0 do
        print("move " .. move_num)
        move_num = move_num + 1             
        if player == a then
            x, y = best_move_neural(player, ttt)
            ttt:move(player, x, y)
            player = b
        else
            x, y = best_move_minimax(player, ttt)
            ttt:move(player, x, y)
            player = a
        end
        print(ttt.board)
        ttt:winner()      
    end 
    if ttt.win == a then
        win_count_neural = win_count_neural + 1/10
    end
    if ttt.win == 3 then
        tie_count_neural = tie_count_neural + 1/10
    end

    data_num = data_num + move_num
    ttt:reset()
end

function play_rounds_mini_neural(game)
    for i=1,10 do
        play_round_mini_neural(game)
    end
    print("Neural wins " .. win_count_neural)
    print("Neural ties " .. tie_count_neural)
end

function play_rounds_neural(game)
    for i=1,1000 do
        play_round_vs_neural(game)
    end
    print("Neural wins " .. win_count_neural)
    print("Neural ties " .. tie_count_neural)
end

function play_rounds_minimax(game)
    for i=1,20 do
        play_round_vs_minimax(game)
    end
    print("Minimax wins " .. win_count_minimax)
    print("Minimax ties " .. tie_count_minimax)  
end

game = TTT.create()
play_rounds_minimax(game)
play_rounds_neural(game)
play_rounds_mini_neural(game)


