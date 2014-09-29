--[[
  @Authors: Ukzz (Chemik)
  @Details: Otclient utils module that turns
	    gives many util functions.
]]

function loadUtils()
  dofile('data/string-utils.lua')
  dofile('data/table-utils.lua')
  dofile('data/other-utils.lua')
end

function init()
  loadUtils()
end

function terminate()
  --
end