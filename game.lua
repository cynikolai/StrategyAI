require 'torch'

TTT = {}
TTT. __index = TTT

--TTT object constructor
function TTT.create()
    local ttt = {}
    setmetatable(ttt,TTT)
    ttt.board = torch.Tensor(3,3)
    ttt.win = 0
    return ttt
end

-- num: player number
-- i: x coordinate of tile to play
-- j: y coordinate of tile to play

-- Updates game board with new move.
function TTT:move(num, i, j)   
    self.board[i][j] = num 
    return self.board
end

-- Reset board to new game
function TTT:reset(num, i, j)
    for x = 1, 3 do
        for y = 1, 3 do
            self.board[x][y] = 0
        end
    end
    self.win = 0
end

-- Swap player
function return_player(player_new)
    if player_new == 1 then
        return 2
    else
        return 1 
    end
end

-- Return next player
function swap_player(player)
    if player == 1 then
        player = 2
    else
        player = 1 
    end
end

-- Return a board with new move.
function move_alt(board, num, i, j)
    board_new = torch.Tensor(3,3):copy(board)
    board_new[i][j] = num
    return board_new
end 

-- Returns array with 0 for playable, 1 for non playable
function TTT:legal(i, j)
    return self.board[i][j] == 0
end

-- Returns array with 0 for playable, 1 for non playable
function legal(board, i, j)
    return board[i][j] == 0
end

-- Determine if the game has been won and which player has won
function TTT:winner()
        --Tie
        k = 3
        v = 1
        for x = 1,3 do
            for y = 1,3 do
                if self.board[x][y] == 0 then
                    v = 0
                end
            end
        end
        if v == 1 then
            self.win = k
        end
    for k = 1,2 do
        -- vertical
        for x = 1,3 do
            v = 1
            for y = 1,3 do
                if self.board[x][y] ~= k then
                    v = 0
                end
            end
            if v == 1 then 
                self.win = k
            end
        end
        -- horizontal
        for y = 1,3 do
            v = 1
            for x = 1,3 do 
                if self.board[x][y] ~= k then
                    v = 0
                end
            end
            if v == 1 then
                self.win = k
            end
        end
        -- diagonal 1
        v = 1
        for z = 1,3 do
            if self.board[z][z] ~= k then
                v = 0
            end
        end
        if v == 1 then
            self.win = k
        end
        -- diagonal 2
        v = 1
        for x = 1,3 do
            y = 4 - x
            if self.board[x][y] ~= k then
                v = 0
            end
        end
        if v == 1 then
            self.win = k
        end
    end
end

