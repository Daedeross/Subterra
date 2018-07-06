package.path = package.path .. ";../?.lua"
require 'src.scripts.quadtree'
require 'src.scripts.utils'

TelepadQTree = Quadtree:new()
--print(TelepadQTree.root) 

ProxyList = {}
CheckList = {}
-- 32768
math.randomseed( os.time() )
local proxy_count = 1000
local min = -9000
local max =  9000
for i=1,proxy_count do
    local new_proxy = {}
    repeat
        local half_height = math.random(100,100)
        local half_width  = math.random(100,100) 
        local position = { x = math.random(min, max), y = math.random(min, max) }
        local left   = position.x - half_width
        local top    = position.y - half_height
        local right  = position.x + half_width
        local bottom = position.y + half_height
        new_proxy = {
            name="proxy" .. tostring(i),
            bbox = {
                left_top = {x=left,y=top},
                right_bottom = {x=right,y=bottom},
            }
        }
    until TelepadQTree:add_proxy(new_proxy)  
    ProxyList[i] = new_proxy
end
local hits = 0
local test_count = 50000
for i = 1,test_count do
    local position = { x = math.random(min, max), y = math.random(min, max) }
    local bbox = {
        left_top = { x=position.x - 1, y=position.y - 1 },
        right_bottom = { x=position.x + 1, y=position.y + 1 }
    }
    CheckList[i] = bbox
end

print("now attempting to clear metatables...")

function clear_metatable(o)
    if o ~= nil then
        if o.children ~= nil then
            for _,c in pairs(o.children) do
                clear_metatable(c)
            end
        end
        setmetatable(0, nil)
    end
end

setmetatable(TelepadQTree, nil)

print("metatables are cleared")
print("attempting to rebuild them")

setmetatable(TelepadQTree, Quadtree)
TelepadQTree:rebuild_metatables()

print("rebuild complete")
print(getmetatable(TelepadQTree).name)

if true then
    local start_time = os.clock()

    for i = 1, test_count do	
        local hit = TelepadQTree:check_proxy_collision(CheckList[i])
        if hit ~= nil then hits = hits + 1 end
    end
    local end_time = os.clock()
    local qtree_time = end_time - start_time

    -- naive run
    local n_hits = 0
    start_time = os.clock()
    for _,bbox in pairs(CheckList) do
        for _,p in pairs(ProxyList) do
            if not (
                bbox.left_top.x > p.bbox.right_bottom.x or
                bbox.left_top.y > p.bbox.right_bottom.y or
                bbox.right_bottom.x < p.bbox.left_top.x or
                bbox.right_bottom.y < p.bbox.left_top.y
                ) then
                n_hits = n_hits + 1
                --break
            end
        end
    end
    end_time = os.clock()
    local n_time = end_time - start_time

    print("# of hits = " .. tostring(n_hits))
    print("# of hits = " .. tostring(hits))
    print(tostring(proxy_count) .. " objects testeded " .. tostring(test_count) .. " times")
    print("in " .. tostring(n_time) .. " seconds using naive approach")
    print("and " .. tostring(qtree_time) .. " seconds using a quadtree")
end

local i = 0
local names = {}
for p in TelepadQTree:proxies() do
    i = i + 1
    if names[p.name] then
        print(p.name)
    else
        names[p.name] = true
    end
end
print ("iterated through " .. i .. "proxies")