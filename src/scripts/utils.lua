

function get_member_safe( t, key )
  local call_result, value = pcall( function () return t[key] end )
  if call_result then
    return value
  else
    return nil
  end
end

function addPlayerProxy(index, player)
    if global.player_proxies[index] == nil then
        local proxy = {
            name = player.name
        }
        proxy.index = index
        global.player_proxies[index] = proxy
    end
end
