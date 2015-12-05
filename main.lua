function love.load()
  input = {
    "",
    ""
  }
  
  last_state = {
    "",
    ""
  }
  
  
  controls = {
    {
      rock = "a",
      paper = "z",
      scissors = "x"
    },
    {
      rock = "'",
      paper = "/",
      scissors = "."
    }
  }
  
  
end

function love.draw()
  
end

function love.update(dt)
end

function love.keypressed(key)
  for i, v in ipairs(controls) do
    if v[key] then
      input[i] = v[key]
    end
  end

  if input[1] == input[2] and input[1] ~= "" then
    last_state[1] = input[1]
    last_state[2] = input[2]
  end
end
