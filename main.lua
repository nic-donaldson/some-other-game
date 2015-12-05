winColour = {0, 255, 0, 255}
loseColour = {255, 0, 0, 255}
drawColour = {0, 0, 255, 255}
waitingColour = {128,128,128,255}
shadedHandColour = { 200,200,200,255 }


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
        {
            rock = love.audio.newSource("resources/sounds/rock1.wav", "static"),
            paper = love.audio.newSource("resources/sounds/paper1.wav", "static"),
            scissors = love.audio.newSource("resources/sounds/scissors1.wav", "static")
        },
        {    
            rock = love.audio.newSource("resources/sounds/rock2.wav", "static"),
            paper = love.audio.newSource("resources/sounds/paper2.wav", "static"),
            scissors = love.audio.newSource("resources/sounds/scissors2.wav", "static"),
        }
    }
  
    boxes = {
        {
            rock = {
                image = {x = 50, y = 100, w = 20},
                stats = {x = 120, y = 100, w = 20}
            },
            paper = {
                image = {x = 100, y = 200, w = 20},
                stats = {x = 170, y = 200, w = 20}
            },
            scissors = {
                image = {x = 200, y = 200, w = 20},
                stats = {x = 270, y = 200, w = 20}
            },
            win = {x = 400, y = 100, w = 20}
        },
        {
            rock = {
                image = {x = 850, y = 100, w = 20},
                stats = {x = 920, y = 100, w = 20}
            },
            paper = {
                image = {x = 800, y = 200, w = 20},
                stats = {x = 870, y = 200, w = 20}
            },
            scissors = {
                image = {x = 700, y = 200, w = 20},
                stats = {x = 770, y = 200, w = 20}
            },
            win = {x = 600, y = 100, w = 20}
        }
    }
    love.window.setTitle("Rock paper scissors")
  
  
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

        -- Background colours
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

        -- Draw RPS graphics
        for _,hand in ipairs({"rock", "paper", "scissors"}) do
            love.graphics.push("all")
            local q = string.sub(hand, 1, 1)
            if hand == last_state[i] then
                colour = shadedHandColour
            else
                colour = {255,255,255,255}
            end
            love.graphics.setColor(colour[1], colour[2], colour[3], colour[4])
            
            love.graphics.draw( images[hand], boxes[i][hand].image.x, boxes[i][hand].image.y, 0, 0.1, 0.1) 
            

            love.graphics.setColor(255,255,255,255)
          --  love.graphics.printf(q, boxes[i][hand].image.x, boxes[i][hand].image.y, boxes[i][hand].image.w, "center")
            love.graphics.printf(math.floor(((stats.moves[i][hand]/stats.games)*100)), boxes[i][hand].stats.x, boxes[i][hand].stats.y, boxes[i][hand].stats.w, "center")
            love.graphics.printf(math.floor(((stats.moves[i][hand]/stats.games)*100)), boxes[i][hand].stats.x, boxes[i][hand].stats.y, boxes[i][hand].stats.w, "center")
            love.graphics.pop()
        end

    end
        -- Draw left bar graph
        -- x = 0, y = 70% of height, width = 25% of screen, height = 
        drawBarGraph(0, sh*0.7, sw*0.25, sh*0.30, stats.moves[1].rock, stats.moves[1].paper, stats.moves[1].scissors)
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
    love.graphics.push("all")
    -- Draws a bar graph of rock paper scissors move frequency, expects r p s whole numbers
    
    -- chart padding
    local chart_padding = width*0.1
    local chart_width = width - chart_padding*2

    -- bar padding is the amount of the chart that is free space, halved
    local bar_space = chart_width*0.7
    local bar_padding = (chart_width-bar_space)/2
    local bar_width = bar_space/3

    -- bar height
    local bar_height = height*0.6

    -- Get percentage in 0,1
    local total = r + p + s
    r = r/total
    p = p/total
    s = s/total
    local bar_heights = {r*bar_height, p*bar_height, s*bar_height}

    -- Draw baseline
    love.graphics.setColor(0, 0, 0, 255)
    local chart_bottom = y + bar_height
    love.graphics.line(x, chart_bottom, x+width, chart_bottom)

    -- Draw bars and text
    for i=1,3 do
        love.graphics.rectangle("fill", x + chart_padding + (bar_padding + bar_width)*(i-1), y + (bar_height - bar_heights[i]), bar_width, bar_heights[i])
    end
    love.graphics.pop()
end

function love.update(dt)
end

function love.keypressed(key)
    for i, v in ipairs(controls) do
      if v[key] then
        input[i] = v[key]

        sounds[i][input[i]]:stop()
        sounds[i][input[i]]:play()
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
