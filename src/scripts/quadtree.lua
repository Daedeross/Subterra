--------------------------------------------------------------------------------
-- quadtree.lua
--------------------------------------------------------------------------------
-- Synopsis:
-- Contains classes to manage a Quadtree spacial data structure for faster
-- collision detection
--------------------------------------------------------------------------------
-- Classes:
-- -- QuadtreeNode:
-- -- -- Used internally. Each instance represents one node in the tree
-- -- -- 'children' may be either nil of contain for child QuadtreeNodes
-- -- -- if 'children' is nil iff proxies has items

--QuadtreeNode


MAX_ITEMS_PER_QUADTREE_NODE = 8	-- this will eventually be in a config file
INITIAL_EXTENTS = {
	left_top      = { x = -1000, y = -1000},
	right_bottom  = { x =  1000, y =  1000},
}

DEBUG = false

function make_bbox(left, top, right, bottom)
	return { 
		left_top = { x = left, y = top},
		right_bottom = { x = right, y = bottom}
	}
end

QuadtreeNode = {}

function QuadtreeNode:new (bbox)
	local qt = {
		center = {
			x = ((bbox.left_top.x + bbox.right_bottom.x) / 2),
			y = ((bbox.left_top.y + bbox.right_bottom.y) / 2),
		},
		extents = bbox,
		children = nil,
		proxies = {},
	}
	setmetatable(qt, self)
	self.__index = self
	return qt
end

function QuadtreeNode:new_root (new_children)
	local left = new_children[1].extents.left_top.x
	local top = new_children[1].extents.left_top.y
	local right = new_children[4].extents.right_bottom.x
	local bottom = new_children[4].extents.right_bottom.y

	local qt = {
		center = {
			x = ((left + right) / 2),
			y = ((top + bottom) / 2),
		},
		extents = make_bbox(left, top, right, bottom),
		children = new_children,
		proxies = {},
	}
	setmetatable(qt, self)
	self.__index = self
	return qt
end

function QuadtreeNode:add_proxy (proxy)
	if self.children == nil then
		-- print ("self: " .. tostring(self))
		-- print ("proxies: " .. tostring(self.proxies))
		table.insert(self.proxies, proxy)
		if #self.proxies >= MAX_ITEMS_PER_QUADTREE_NODE then
			self:split()
		end
	else
		if proxy.bbox.left_top.y < self.center.y then
			if proxy.bbox.left_top.x < self.center.x then
				self.children[1]:add_proxy(proxy)
			end
			if proxy.bbox.right_bottom.x > self.center.x then
				self.children[2]:add_proxy(proxy)
			end
		end
		if proxy.bbox.right_bottom.y > self.center.y then
			if proxy.bbox.left_top.x < self.center.x then
				self.children[3]:add_proxy(proxy)
			end
			if proxy.bbox.right_bottom.x > self.center.x then
				self.children[4]:add_proxy(proxy)
			end
		end
	end
end

function QuadtreeNode:rebuild_metatables(node)
	if getmetatable(node) ~= nil then
		setmetatable(node, self) 
	end
	if node.children ~= nil then
		for _,c in pairs(node.children) do
			QuadtreeNode:rebuild_metatables(c)
		end
	end
end

-------------------------------------------------------------
-- Creates 4 child QuadtreeNodes and places the 'owned' proxies
-- in the appropriate node(s)
--
-- The index of the child nodes looks like this:
-- +---+---+
-- | 1 | 2 |
-- +---+---+
-- | 3 | 4 |
-- +---+---+
--
-- Note: in Factorio, positive-x is to the right and
--       positive y is down
-------------------------------------------------------------
function QuadtreeNode:split()
	--print("SPLIT")
	-- create children array and populate it with new nodes
	self.children = {}
	self.children[1] = QuadtreeNode:new({
		left_top     = self.extents.left_top, 
		right_bottom = self.center,
	})
	self.children[2] = QuadtreeNode:new({
		left_top      = {x=self.center.x, y=self.extents.left_top.y},
		right_bottom  = {x=self.extents.right_bottom.x, y=self.center.y},
	})
	self.children[3] = QuadtreeNode:new({
		left_top      = {x=self.extents.left_top.x, y=self.center.y},
		right_bottom  = {x=self.center.x, y=self.extents.right_bottom.y},
	})
	self.children[4] = QuadtreeNode:new({
		left_top      = self.center, 
		right_bottom  = self.extents.right_bottom,
	})
	-- add proxies to the appropriate child(ren)
	-- 
    -- print ("self: " .. tostring(self))
	-- print ("proxies: " .. tostring(self.proxies))
	for i = table.getn(self.proxies), 1, -1 do
		local p = self.proxies[i]
		-- print(p)
		if p.bbox.left_top.y < self.center.y then
			if p.bbox.left_top.x < self.center.x then
				self.children[1]:add_proxy(p)
			end
			if p.bbox.right_bottom.x > self.center.x then
				self.children[2]:add_proxy(p)
			end
		end
		if p.bbox.right_bottom.y > self.center.y then
			if p.bbox.left_top.x < self.center.x then
				self.children[3]:add_proxy(p)
			end
			if p.bbox.right_bottom.x > self.center.x then
				self.children[4]:add_proxy(p)
			end
		end
		-- remove proxies from this node (they are now in the children)
		table.remove(self.proxies, i)
	end
end

-- recursively checks the QuadtreeNode
function QuadtreeNode:check_proxy_collision (bbox)
	-- first check if it is even in this node
	if bbox.left_top.x > self.extents.right_bottom.x or
	   bbox.left_top.y > self.extents.right_bottom.y or
	   bbox.right_bottom.x < self.extents.left_top.x or
	   bbox.right_bottom.y < self.extents.left_top.y then
		return nil -- no collision
	end
	if self.children == nil then
		-- check collision with owned proxies (if any)
		for _, p in pairs(self.proxies) do
			if not (
			   bbox.left_top.x > p.bbox.right_bottom.x or
			   bbox.left_top.y > p.bbox.right_bottom.y or
			   bbox.right_bottom.x < p.bbox.left_top.x or
			   bbox.right_bottom.y < p.bbox.left_top.y
				) then
				return p
			end
		end
	else
		-- recursievly check child nodes
		local result = nil
		if bbox.left_top.y < self.center.y then
			if bbox.left_top.x < self.center.x then
				result = self.children[1]:check_proxy_collision(bbox)
				if result ~= nil then return result end
			end
			if bbox.right_bottom.x > self.center.x then
				result = self.children[2]:check_proxy_collision(bbox)
				if result ~= nil then return result end
			end
		end
		if bbox.right_bottom.y > self.center.y then
			if bbox.left_top.x < self.center.x then
				result = self.children[3]:check_proxy_collision(bbox)
				if result ~= nil then return result end
			end
			if bbox.right_bottom.x > self.center.x then
				result = self.children[4]:check_proxy_collision(bbox)
				if result ~= nil then return result end
			end
		end
	end
	-- if we get here nothing collides
	return nil
end

-- if the proxy to add is outside the extents of the tree,
-- then create a new root node and make 'this' one of its
-- children. The new root is thus twice the dimensions (4x the area).
-- if bbox is not outside the node, does nothing
function QuadtreeNode:expand(bbox)
	if bbox.left_top.x < self.extents.left_top.x or
	   bbox.left_top.y < self.extents.left_top.y or
	   bbox.right_bottom.x > self.extents.right_bottom.x or
	   bbox.right_bottom.y > self.extents.right_bottom.y then
		-- print ("EXPAND")

		-- must create new root
		local dx = self.extents.right_bottom.x - self.extents.left_top.x
		local dy = self.extents.right_bottom.y - self.extents.left_top.y
		local cx = 0
		local cy = 0
		local new_left = 0
		local new_right = 0
		local new_top = 0
		local new_bottom = 0
		local new_children = {}
		
		-- I should probably make these checks more efficient, yet verbose
		if bbox.left_top.x < self.extents.left_top.x then
			if bbox.left_top.y < self.extents.left_top.y then
				cx = self.extents.left_top.x
				cy = self.extents.left_top.y
				new_left   = self.extents.left_top.x - dx
				new_top    = self.extents.left_top.y - dy
				new_right  = self.extents.right_bottom.x
				new_bottom = self.extents.right_bottom.y

				new_children[1] = QuadtreeNode:new(make_bbox(new_left, new_top, cx, cy))
				new_children[2] = QuadtreeNode:new(make_bbox(cx, new_top , new_right, cy))
				new_children[3] = QuadtreeNode:new(make_bbox(new_left, cy , cx, new_bottom))
				new_children[4] = self
			else
				cx = self.extents.left_top.x
				cy = self.extents.right_bottom.y
				new_left   = self.extents.left_top.x - dx
				new_top    = self.extents.left_top.y
				new_right  = self.extents.right_bottom.x
				new_bottom = self.extents.right_bottom.y + dy

				new_children[1] = QuadtreeNode:new(make_bbox(new_left, new_top , cx, cy))
				new_children[2] = self
				new_children[3] = QuadtreeNode:new(make_bbox(new_left, cy , cx, new_bottom))
				new_children[4] = QuadtreeNode:new(make_bbox(cx, cy , new_right, new_bottom))
			end
		else
			if bbox.left_top.y < self.extents.left_top.y then
				cx = self.extents.right_bottom.x
				cy = self.extents.left_top.y
				new_left   = self.extents.left_top.x
				new_top    = self.extents.left_top.y - dy
				new_right  = self.extents.right_bottom.x + dx
				new_bottom = self.extents.right_bottom.y

				new_children[1] = QuadtreeNode:new(make_bbox(new_left, new_top , cx, cy))
				new_children[2] = QuadtreeNode:new(make_bbox(cx, new_top , new_right, cy))
				new_children[3] = self
				new_children[4] = QuadtreeNode:new(make_bbox(cx, cy , new_right, new_bottom))
			else
				cx = self.extents.right_bottom.x
				cy = self.extents.right_bottom.y
				new_left   = self.extents.left_top.x
				new_top    = self.extents.left_top.y
				new_right  = self.extents.right_bottom.x + dx
				new_bottom = self.extents.right_bottom.y + dy

				new_children[1] = self
				new_children[2] = QuadtreeNode:new(make_bbox(cx, new_top , new_right, cy))
				new_children[3] = QuadtreeNode:new(make_bbox(new_left, cy , cx, new_bottom))
				new_children[4] = QuadtreeNode:new(make_bbox(cx, cy , new_right, new_bottom))
			end
		end
		-- create new node with given children
		local node = QuadtreeNode:new_root(new_children)
		-- check if this new root still needs to expand
		-- will recursively keep expanding until the root is big enough
		return node:expand(bbox)
	else
		return self	-- root is unchanged
	end
end

-- TODO: does not recurse down the tree
-- returns an inerator over all_proxies under the node
function QuadtreeNode:get_all_proxies()
	local i
	local n = table.getn(self.proxies)
	return function ()
		i = i + 1
		if i <= n then return self.proxies[i] end
	end
end

-- management class for the QuadtreeNodes
Quadtree = {}

function Quadtree:new(o)
	local qt = o or {
		root = QuadtreeNode:new(INITIAL_EXTENTS)
	}
	setmetatable(qt, self)
	self.__index = self
	return qt
end

function Quadtree:add_proxy_unsafe(proxy)
	self.root = self.root:expand(proxy.bbox)
	self.root:add_proxy(proxy)
end

function Quadtree:add_proxy(proxy)
	if self.root:check_proxy_collision(proxy.bbox) then
		return false
	end
	self:add_proxy_unsafe(proxy)
	return true
end

function Quadtree:check_proxy_collision (bbox)
	return self.root:check_proxy_collision (bbox)
end

function Quadtree:rebuild_metatables()
	QuadtreeNode:rebuild_metatables(self.root)
end

TelepadQTree = Quadtree:new()
--print(TelepadQTree.root) 

ProxyList = {}
CheckList = {}

if DEBUG then
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