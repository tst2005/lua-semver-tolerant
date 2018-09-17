
local semver = require "semver"

local function v(vstring)
	-- allow v1.2.3 (auto remove the 'v' prefix)
	if string.sub(vstring,1,1) == "v" then
		vstring=string.sub(vstring,2)
	end
	local allowed={
		a="-",alpha="-",b="-",beta="-",c="-",rc="-",pre="-",preview="-",
	}
	vstring = vstring:gsub("([0-9])([a-z]+)", function(a,b)
		return a..(allowed[b] or "")..b
	end):gsub("([a-z]+)([0-9]+)", function(a,b)
		return a..(allowed[a] and "." or "")..b
	end)
	-- special 1.2.3.4 or 1.2.3.4+anything
	local prefix, dot4, suffix = string.match(vstring, "^([0-9]+%.[0-9]+%.[0-9]+)(%.[0-9]+)(.*)$")
	if prefix then
		if not dot4:find("^%.0*$") then -- there is dot number after the patch
			-- let's make a little hack
			local v = semver(prefix..(suffix or ""))
			v.patch = assert(tonumber(tostring(v.patch)..dot4)) or v.patch
			v.strpatch = dot4
			return v
		end
		-- it is just .0 => can be removed and be semver compatible
		vstring = prefix..suffix
	end
-- :gsub("^([0-9]+%.[0-9]+%.[0-9]+)%.([0-9].*)$", "%1+ERROR.%2")
	return semver(vstring)
end

local function _tostring(sv)
	assert(type(sv)=="table")
	if sv.patch %1 >0 then
		local s = tostring(sv) -- tostring by semver (we should get a 1.2.3 or 1.2.3[+-]any)
		local major_minor, patch, suffix = string.match(s, "^([0-9]+%.[0-9]+%.)([0-9]+)([^0-9]*.*)$")
		assert(major_minor) -- it must match
		return major_minor..("%s"):format(sv.patch)..(suffix or "")
	end
	return tostring(sv)
end
local M={v=v,tostring=_tostring}
setmetatable(M, {__call=function(_,...) return v(...) end})
return M
