--[[
  @Authors: Ukzz (Chemik)
  @Details: Other utils like shourtcuts.
]]

strfind = string.find
strrep = string.rep
strsub = string.sub
tabsort = table.sort
tostr = tostring
cout = io.write
cin = io.read
pout = print

function printf(str, ...)
  print(string.formats(str, ...))
end

function perror(str, ...)
  print(string.formats("[ERROR]: "..str, ...))
end

function pdmesg(str, ...)
  print(string.formats("[DMESG]: "..str, ...))
end

function switch(t)
  t.case = function (self, x)
    local f=self[x] or self.default
    if(f ~= nil) then
      if(type(f) == "function") then
        f(x, self)
      else
        error("case "..tostring(x).." not a function")
      end
    end
  end
  return t
end