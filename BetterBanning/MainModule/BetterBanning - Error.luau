local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local module = {}

function module.scriptError(errorCode: number, errorMessage: string)
	-- Gets all players
    for _, player : Player  in Players:GetChildren() do
        -- Sends cooler error to all players screens
		module.error(player, errorCode, errorMessage)
    end

	-- Puts error in output and stops the script
	warn("Error Code: " .. errorCode)
	error(errorMessage)
end

function module.error(player: Player, errorCode: number, errorMessage: string)
	if not RunService:IsStudio() then
		error("Error Code: " .. errorCode .. " Error: " .. errorMessage)
	end
	if errorMessage == nil then
		warn("No error message to report!")
		return
	end
	if errorCode == nil then
		errorCode = "000"
	end

	local UI = script.Parent.OffileUI:Clone()
	UI.ErrorFrame.ErrorData.ErrorText.Text = '<font color="#ff0000">Error Code:</font> '
		.. errorCode
		.. '<br /><br /> <font color="#ff0000">Error Message: </font>'
		.. errorMessage
		.. '<br /><br /><br /><i><font color="#add8e6"><font size="15">For help solving this error, join the BetterBanning communitcations server.</font></font></i>'
	UI.ErrorFrame.ErrorData.ErrorTitle.Text = 'An <font color="#ff0000">Error</font> has accrued with BetterBanning!'
	UI.ErrorFrame.Visible = true
	UI.Parent = player.PlayerGui
end

return module
