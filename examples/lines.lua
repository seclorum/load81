function setup()
    background(255,0,1);
end

function draw()
    fill(math.random(255),math.random(255),math.random(255),math.random())
    line (math.random(WIDTH),math.random(HEIGHT),
             math.random(WIDTH),math.random(HEIGHT))
end
