winColour = {0, 255, 0, 255}
loseColour = {255, 0, 0, 255}
drawColour = {0, 0, 255, 255}
waitingColour = {128,128,128,255}



function love.load()
    
    stats = {
        games = 0,
        moves = {
            {
                rock = 0,
                paper = 0,
                scissors = 0
            },
            {
                rock = 0,
                paper = 0,
                scissors = 0
            }
        },
        wins = {
            0,
            0
        }
    }
    input = {
    "",
    ""
    }
  
    last_state = {
    "",
    ""
    }
  
    sw = 1000
    sh = 600
  
    love.window.setMode(sw,sh)
  
    images = {
        rock = love.graphics.newImage("resources/rock.png"),
        paper = love.graphics.newImage("resources/paper.png"),
        scissors = love.graphics.newImage("resources/scissors.png")
    }

    sounds = {
        p1select = love.audio.newSource("resources/sounds/p1select.wav", "static"),
        p2select = love.audio.newSource("resources/sounds/p2select.wav", "static")
    }
  
    boxes = {
        {
            rock = {
                image = {x = 100, y = 100, w = 20},
                stats = {x = 120, y = 100, w = 20}
            },
            paper = {
                image = {x = 150, y = 200, w = 20},
                stats = {x = 170, y = 200, w = 20}
            },
            scissors = {
                image = {x = 250, y = 200, w = 20},
                stats = {x = 270, y = 200, w = 20}
            }
        },
        {
            rock = {
                image = {x = 900, y = 100, w = 20},
                stats = {x = 920, y = 100, w = 20}
            },
            paper = {
                image = {x = 850, y = 200, w = 20},
                stats = {x = 870, y = 200, w = 20}
            },
            scissors = {
                image = {x = 750, y = 200, w = 20},
                stats = {x = 770, y = 200, w = 20}
            }
        }
    }
  
  
  controls = {
    {
      ['a'] = "rock",
      ['z'] = "paper",
      ['x'] = "scissors"
    },
    {
      ["'"] = "rock",
      ["/"] = "paper",
      ["."] = "scissors"
    }
  }
end

function love.draw()
    
    local winner = getWinner(last_state[1], last_state[2])
    
    for i = 1,2 do
        if input[i] ~= "" then
            colour = waitingColour
        elseif winner == i then
            colour = winColour
        elseif winner == 0 then --draw
            colour = drawColour
        else
            colour = loseColour
        end
        love.graphics.setColor(colour[1], colour[2], colour[3], colour[4])
        love.graphics.rectangle("fill",(i-1)*sw/2,0,sw/2,sh)
        love.graphics.setColor(255,255,255,255)
        for _,hand in ipairs({"rock", "paper", "scissors"}) do
            local q = string.sub(hand, 1, 1)
            love.graphics.draw( images[hand], boxes[i][hand].image.x, boxes[i][hand].image.y, 0, 0.1, 0.1)
          --  love.graphics.printf(q, boxes[i][hand].image.x, boxes[i][hand].image.y, boxes[i][hand].image.w, "center")
            love.graphics.printf(math.floor(((stats.moves[i][hand]/stats.games)*100)), boxes[i][hand].stats.x, boxes[i][hand].stats.y, boxes[i][hand].stats.w, "center")
        end
    end
end

function love.update(dt)
    
end

function getWinner(p1, p2)
    if p1 == p2 then
        return 0
    elseif p1 == "rock" then
        if p2 == "scissors" then
            return 1
        else
            return 2
        end
    elseif p1 == "scissors" then
        if p2 == "paper" then
            return 1
        else
            return 2
        end 
    else -- paper
        if p2 == "rock" then
            return 1
        else
            return 2
        end
    end
end 

function drawBarGraph(x, y, width, height, r, p, s)
    -- Draws a bar graph of rock paper scissors move frequency, expects r p s whole numbers

    -- Normalise to 0,1
    local max = math.max(r, p, s)
    r = max/r
    p = max/p
    s = max/s

end

function love.update(dt)
end

function love.keypressed(key)
    for i, v in ipairs(controls) do
      if v[key] then
        input[i] = v[key]
        if i == 1 then -- if p1 has selected a new move
            love.audio.play(sounds.p1select)
        else
            love.audio.play(sounds.p2select)
        end
      end
    end

    -- if both players have selected a move
    if input[1] ~= "" and input[2] ~= "" then
      last_state[1] = input[1]
      last_state[2] = input[2]
      
      stats.games = stats.games+1
      
      winner = getWinner(last_state[1], last_state[2])
      for i = 1,2 do
          stats.moves[i][input[i]] = stats.moves[i][input[i]] + 1
      end

      if winner ~= 0 then
          stats.wins[winner] = stats.wins[winner] + 1
      end
      
      input[1] = ""
      input[2] = ""
    end 
      
end
