local semver = require"semver"
local semver = require"semver-tolerant"
local sort = require "semver-sort"(semver)

--local list = require "samples.versions-lua-tosort"
--local list = require "samples.versions-luajit-tosort"
--local list = require "samples.versions-luarocks-tosort"
local list = require "samples.versions-4dot-tosort"

local keys = {}
for i in ipairs(list) do
	table.insert(keys, i)
end

local getv = function(item) return item[1] end

for i,item in ipairs(list) do
	print("original", i, getv(item))
end

sort(list, getv)

for i,item in ipairs(list) do
	local v = getv(item)
	local sv = semver(v)
	local txt= tostring(sv)
	local vtxt = (semver.tostring or tostring)(semver(getv(item)))
        print("sorted", i, ("%-10s -> %s"):format(v, vtxt), vtxt==txt and "" or "(with internal hack)")
end

