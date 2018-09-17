local v = require "semver-tolerant"

local operators = {
	[">"]  = function(a,b) return a>b  end,
	[">="] = function(a,b) return a>=b end,
	["<="] = function(a,b) return a<=b end,
	["<"]  = function(a,b) return a<b  end,
}


local function filter(list, constraints)
	local result = {}
	for _i, item in ipairs(list) do
		local itemversion = v(item.v)
		local function isok(itemversion, constraints)
			for _ii, constr in ipairs(constraints) do
				local op, cversion = operators[constr[1]], v(constr[2])
				assert(op, "invalid operator")
				if not op(itemversion, cversion) then
--					print("constr fail:", _i, item.v, constr[1], constr[2])
					return false
				end
			end
			return true
		end
		if isok(itemversion, constraints) then
--			print("ok", _i)
			table.insert(result,item)
		end
	end
	if #result == 0 then
		return nil
	end
	return result
end

do -- self-test
	local list = {
		{v="1.0.0"},
		{v="v2.0.0"},
		{v="3.0.0"},
	}
	local constraints = {
		{">",  "1.0.0"},
		{"<",  "3.0.0"},
		{">=", "v1.9.0-alpha1"},
		{"<=", "2.1.0"},
	}
	assert( filter(list, constraints), list[2], "self test fail" )
end

return filter
