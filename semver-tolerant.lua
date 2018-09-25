
local semver = require "semver"

local M = {}
M.semver = require "semver"

local floatprecision = require "limits.floatprecision"

M.dot4precision = floatprecision()
M.limitreach = print

local function v(vstring)
	local semver = assert(M.semver)
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
	local prefix, dot4, suffix = string.match(vstring, "^([0-9]+%.[0-9]+%.[0-9]+)%.([0-9]+)(.*)$")
	if prefix then
		if dot4 and not dot4:find("^%.0*$") then -- there is dot number after the patch (but ignore .0)
			-- let's make a little hack
			local v = semver(prefix..(suffix or ""))
			local pad = assert(M.dot4precision, "missing semver-tolerant.dot4precision")
			if #dot4+#tostring(v.patch)>pad then
				M.limitreach("subpatch is larger than supported: "..#dot4.."+"..#tostring(v.patch)..">"..pad.." for version "..vstring)
			end
			local padding = ((pad-#dot4>0) and (("0"):rep(pad-#dot4)) or "")
			v.patch = assert(tonumber(tostring(v.patch).."."..padding..dot4)) or v.patch
			v.subpatch = dot4
			return v
		end
		-- it is just .0 => can be removed and be semver compatible
		vstring = prefix..suffix
	end
-- :gsub("^([0-9]+%.[0-9]+%.[0-9]+)%.([0-9].*)$", "%1+ERROR.%2")
	return semver(vstring)
end
M.v=v

local function _tostring(sv)
	local semver = assert(M.semver)
	assert(type(sv)=="table")
	if sv.subpatch then
		local s = tostring(sv) -- tostring by semver (we should get a 1.2.3 or 1.2.3[+-]any)
		local major_minor, patch, suffix = string.match(s, "^([0-9]+%.[0-9]+%.)([0-9]+)([^0-9]*.*)$")
		assert(major_minor) -- it must match
		return major_minor..patch.."."..sv.subpatch..(suffix or "")
	end
	return tostring(sv)
end
M.tostring=_tostring

setmetatable(M, {__call=function(_,...) return v(...) end})
return M
