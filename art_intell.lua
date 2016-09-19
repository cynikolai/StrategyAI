require 'torch'
require 'game'
require 'nn'
require 'math'
require 'os'
require 'strategy'

tree = {}
tree. __index = tree

-- Tree object constructor
function tree.create(player_new)
    local tt = {}
    setmetatable(tt,tree)
    tt.board = torch.Tensor(3,3)
    tt.win = 0
    tt.x = 0
    tt.y = 0
    tt.player = player_new    
    return tt    
end

-- Generates child set for tree
function tree:children()
  child_set = {}
  set_size = 0
    for i=1,3 do
      for j=1,3 do
        if legal(self.board,i,j) then
          set_size = set_size + 1
          child_new = tree.create(return_player(self.player))
          child_new.board = torch.Tensor(3,3):copy(self.board)
          child_new.board[i][j] = child_new.player
          child_new.x = i
          child_new.y = j
          child_new:winner()
          child_set[set_size] = child_new
        end
      end
    end
  return child_set
end

-- Determine if the game has been won and which player has won
function tree:winner()
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
    for k = player,player do
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
    for k = return_player(player),return_player(player) do
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

function tree:heuristic()
  if self.win == 1 then
    return -1
  elseif self.win == 2 then
    return 1
  elseif self.win == 3 then
    return 0
  end
end

function tree:isLeaf()
  if self.win == 0 then
    return false
  end
    return true
end

-- Credit for this code to (https://github.com/kennyledet)
-- Choose the optimal move by minimax
function minimax(tree, maximize)
  if tree:isLeaf(tree) then
    return tree:heuristic(tree)
  end
  local good_x
  local good_y
  local children = tree:children(tree)
  if maximize then
    local bestScore = -math.huge
    for i, child in ipairs(children) do
      local bestScoreNew = minimax(child, false)
      if(bestScoreNew > bestScore) then
        bestScore = bestScoreNew
        good_x = child.x
        good_y = child.y
      end
    end
    x= good_x
    y = good_y
    return bestScore
  else
    local bestScore = math.huge
    for i, child in ipairs(children) do
      local bestScoreNew = minimax(child, true)
      if(bestScoreNew < bestScore) then
        bestScore = bestScoreNew
        good_x = child.x
        good_y = child.y
      end
    end
    x= good_x
    y = good_y
    return bestScore
  end
  
end

-- Determine the best move given minimax
function best_move_minimax(player, ttt)
    board_old = ttt.board
    tree_new = tree.create(return_player(player))
    tree_new.board = board_old
    x = 0
    y = 0   
    local max = (player == 2)
    row2 = board_old[2][1] == 0 and board_old[2][3] == 0
    row1 = board_old[1][1] == 0 and board_old[1][2] == 0 and board_old[1][3] == 0
    row3 = board_old[3][1] == 0 and board_old[3][2] == 0 and board_old[3][3] == 0
    if(board_old[2][2] == 0) then
      return 2,2
    elseif row1 and row2 and row3 then
      return 1,1
    else
      minimax(tree_new, max, x, y)
    end
    return x, y
end


