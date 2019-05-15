--============================================================================--
-- destroy_and_return(built_entity, creator)
--
-- destroy an entity and return it to its creator's inventory, if possible
--
-- param built_entity (LuaEntity): The entity just placed
-- param creator (LuaEntity): The entity (player or robot) that placed the
--      new entity. nil if placed by other means (i.e. via script)
-- 
--============================================================================--
local destroy_and_return = function (built_entity, creator)
    if creator then
        local prod
        if built_entity.prototype.mineable_properties.products then
            prod = built_entity.prototype.mineable_properties.products[1].name
        else
            prod = built_entity.name
        end
        if prod ~= "entity-ghost" then
            creator.insert{name = prod, count = 1}
        end
    end
    built_entity.destroy({raise_destroy= (creator == nil)})
end

return destroy_and_return