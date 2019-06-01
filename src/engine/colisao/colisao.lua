
local colision = {}

function colision.pegaPote(self,event)

    
    if(event.phase == "began")then
    
        local obj1 = event.target;
        local obj2 = event.other;

        if(obj2.myName == "pote") then
            
end

return colision