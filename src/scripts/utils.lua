function get_member_safe( t, key )
  local call_result, value = pcall( function () return t[key] end )
  if call_result then
    return value
  else
    return nil
  end
end

function addPlayerProxy(i, p)
    if global.player_proxies[i] == nil then
        local proxy = {
            name = player.name,
            index = i,
            player = p,
            on_pad = false,
        }
        global.player_proxies[i] = proxy
    end
end
