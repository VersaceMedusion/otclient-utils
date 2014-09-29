--[[
  @Authors: Ukzz (Chemik)
  @Details: Table utils like table format
            output prints or wrappers.
]]

function table.find(tbl, value, careful)
    local sensitive = (type(careful) ~= "boolean" or not careful) and false or true
    
    if(not sensitive and type(value) == "string")then
        for i, v in pairs(tbl) do
            if(type(v) == "string") then
                if(v:lower() == value:lower()) then
                    return i
                end
            end
        end
        return false
    end
    for i, v in pairs(tbl) do
        if(v == value) then
            return i
        end
    end
    return false
end

function table.contains(t, value, index)
    for n = 1, #t do
        local c = t[n]
        if(type(c) == 'table') and (type(value) ~= 'table') and (index) then
            if(c[index] == value)then
                return c, n
            end
        elseif(c == value)then
            return c, n
        end
    end
    return false
end

function table.serialize(x, recur)
    local t = type(x)
    recur = recur or {}
    if(t == nil) then
        return "nil"
    elseif(t == "string") then
        return string.format("%q", x)
    elseif(t == "number") then
        return tostring(x)
    elseif(t == "boolean") then
        return x and "true" or "false"
    elseif(getmetatable(x)) then
        error("Can not serialize a table that has a metatable associated with it.")
    elseif(t == "function") then
    return tostring(x)
    elseif(t == "table") then
        if(table.find(recur, x)) then
            error("Can not serialize recursive tables.")
        end
        table.insert(recur, x)
        local s = "{"
        for k, v in pairs(x) do
            s = s .. "[" .. table.serialize(k, recur) .. "]" .. " = " .. table.serialize(v, recur) .. ", "
        end
        return s:sub(0, s:len() - 2) .. "}"
    end
    error("Can not serialize value of type '" .. t .. "'.")
end

function table.unserialize(str)
    return loadstring("return " .. str)()
end

function table.binaryfind(self, v, a)
  local index, range = 1, #self
  while index <= range do
    local mid = math.floor((range + index) / 2)
    if (self[mid][a] or self[mid]) == v then
      return mid
    elseif (self[mid][a] or self[mid]) > v then
      range = mid - 1
    else
      index = mid + 1
    end
  end
  return nil
end

function table.each(self, f, p)
  if p then
    return table.foreach(self, f)
  else
    return table.foreachi(self, f)
  end
  return self
end

function table.lower(self)
  local i = 1
  while #self >= i do
    local str = self[i]
    if type(str) == "string" then
      self[i], i = str:lower(), i + 1
    else
      table.remove(self, i)
    end
  end
  return self
end

function table.upper(self)
  local i = 1
  while #self >= i do
    local str = self[i]
    if type(str) == "string" then
      self[i], i = str:upper(), i + 1
    else
      table.remove(self, i)
    end
  end
  return self
end

function table.id(self)
  local i = 1
  while #self >= i do
    if type(self[i]) == "number" and self[i] > 0 then
      i = i + 1
    elseif type(self[i]) == "string" then
      local id = itemid(self[i])
      if id > 0 then
        self[i], i = id, i + 1
      else
        table.remove(self, i)
      end
    else
      table.remove(self, i)
    end
  end
  return self
end

function table.include(self, value, argument)
  for k, v in ((argument and pairs) or ipairs)(self) do
    if (argument and v[argument] == value) or v == value then
      return k
    end
  end
  return nil
end

function table.unpack(self)
  local temp = {}
  for _, v in pairs(self) do
    table.insert(temp, v)
  end
  return unpack(temp)
end

function table.tostring(self, sep)
  local sep, str = sep or ' ', ''
  for k, v in pairs(self) do
    local t, n = type(v), tonumber(k)
    if t == 'string' then
      str = str .. string.format("%s,%s", (n ~= nil and string.format('"%s"', v)) or string.format('%s = "%s"', k, v), sep)
    elseif t == 'number' then
      str = str .. string.format("%s,%s", (n ~= nil and v) or string.format("%s = %s", k, v), sep)
    elseif t == 'table' then
      str = str .. string.format("%s,%s", (n ~= nil and table.tostring(v)) or string.format("%s = %s", k, table.tostring(v)), sep)
    end
  end
  local temp = string.format("{%s}", str):gsub(",}", '}'):gsub(", }", '}')
  return temp
end

function printTable(table, indent)
  local sort = table.sort
  indent = indent or 0;
  local keys = {};
  for k in pairs(table) do
    keys[#keys+1] = k;
    tabsort(keys, function(a, b)
      local ta, tb = type(a), type(b);
      if (ta ~= tb) then
        return ta < tb;
      else
        return a < b;
      end
    end);
  end

  print(string.rep('  ', indent)..'{');
  indent = indent + 1;
  for k, v in pairs(table) do
    local key = k;
    if (type(key) == 'string') then
      if not (string.match(key, '^[A-Za-z_][0-9A-Za-z_]*$')) then
        key = "['"..key.."']";
      end
    elseif (type(key) == 'number') then
      key = "["..key.."]";
    end

    if (type(v) == 'table') then
      if (next(v)) then
        printf("%s%s =", string.rep('  ', indent), tostring(key));
        printTable(v, indent);
      else
        printf("%s%s = {},", string.rep('  ', indent), tostring(key));
      end 
    elseif (type(v) == 'string') then
      printf("%s%s = %s,", string.rep('  ', indent), tostring(key), "'"..v.."'");
    else
      printf("%s%s = %s,", string.rep('  ', indent), tostring(key), tostring(v));
    end
  end
  indent = indent - 1;
  print(string.rep('  ', indent)..'}');
end