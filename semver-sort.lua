
local function sort_with_semver(semver)
	return function(list, getvers)
		if not getvers then
			function getvers(k)
				return k
			end
		end
		table.sort(list, function(a, b)
			return semver(getvers(a)) < semver(getvers(b))
		end)
		return list
	end
end

return sort_with_semver
