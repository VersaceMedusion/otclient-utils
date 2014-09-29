--[[
  @Authors: Ukzz (Chemik)
  @Details: String utils like table format
            or new wrapers functions.
]]

function string.formats(str, ...)
  return (#{...} > 0 and str:format(...) or str)
end

function string:titlecase()
    return self:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
end

function string:split(s)
    local s, tbl = s or " ", {}
    self:gsub(string.format("([^%s]+)", s), function(c) tbl[#tbl+1] = c end)
    return tbl
end

function string:trim()
  return self:gsub("^%s*(.-)%s*$", "%1")
end

function string:wordcount()
    local n = 0
    self:gsub("(%w+)", function() n = n + 1 end)
    return n
end

function string.ucwords(self)
  return self:gsub("(%a)([%w_']*)", function(a, b) return a:upper() .. b:lower() end)
end

function string.explode(self, sep)
  local parts, i = {}, 1
  local start, finish = string.find(self, sep, i)

  while (start) do
    table.insert(parts, string.sub(self, i, start - 1))

    i = finish + 1
    start, finish = string.find(self, sep, i)
  end

  table.insert(parts, string.sub(self, i))

  return parts
end

function string.fit(self, size)
  return ((type(size) == 'string' and #size or size) - #self) < 0 and self:sub(1, (type(size) == 'string' and #size or size)) .. '...'
end