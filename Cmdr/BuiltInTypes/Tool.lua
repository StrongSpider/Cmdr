local Util = require(script.Parent.Parent.Shared.Util)

local toolType = {
	Transform = function (text)
		local findTool = Util.MakeFuzzyFinder(game.ReplicatedStorage.ToolClone:GetChildren())
		return findTool(text)
	end;

	Validate = function (tools)
		return #tools > 0, "No tool with that name could be found."
	end;

	Autocomplete = function (tools)
		return Util.GetNames(tools)
	end;

	Parse = function (tools)
		return tools[1]
	end;

	Default = function(tool)
		return tool.Name
	end;
}

return function (cmdr)
	cmdr:RegisterType("tool", toolType)
<<<<<<< HEAD
end
=======
end
>>>>>>> 5d62f45237bd1fa67627c9b398389f67b39ac768
