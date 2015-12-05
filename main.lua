winColour = {0, 255, 0, 255}
loseColour = {255, 0, 0, 255}
drawColour = {0, 0, 255, 255}

function love.load()

end

function love.draw()
    width, height = love.graphics.getDimensions()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf("Rock",  0, height/4, width, "center")
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.printf("Paper", 0, height - height/4, width, "center")

    love.graphics.print(getWinner("rock", "scissors"), 0, 0)
end

function love.update(dt)
    
end

function getWinner(p1, p2)
    if p1 == p2 then
        return "draw"
    elseif p1 == "rock" then
        if p2 == "scissors" then
            return "p1"
        else
            return "p2"
        end
    elseif p1 == "scissors" then
        if p2 == "paper" then
            return "p1"
        else
            return "p2"
        end 
    else -- paper
        if p2 == "rock" then
            return "p1"
        else
            return "p2"
        end
    end
end 

function drawMoves(p1, p2, winner)
    local p1Colour = drawColour
    local p2Colour = drawColour
    width, height = love.graphics.getDimensions()

    if winner == "p1" then
        p1Colour = winColour
        p2Colour = loseColour
    end

    if winner == "p2" then
        p1Colour = loseColour
        p2Colour = winColour
    end

    love.graphics.push("all")
    love.graphics.setColor(p1Colour[1], p1Colour[2], p1Colour[3], p1Colour[4])
    love.graphics.printf(p1, 0, height/4, width, "center")
    love.graphics.setColor(p2Colour[1], p2Colour[2], p2Colour[3], p2Colour[4])
    love.graphics.printf(p2, 0, height-height/4, width, "center")
    love.graphics.pop()
end
