local DataStoreService = game:GetService("DataStoreService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local error = require(script["BetterBanning - Error"])

local BetterBanning = {
	DataStore = "BetterBanning",
	UnbanFunction = nil,
	Preset = "Default",
	BanFunction = nil,
	ServerBans = {},
	Custom = {},
}

local function formatTime(future, now): string
	local betweenTime = os.difftime(future, now)
	local d = math.floor(betweenTime / 60 / 60 / 24)
	local h = string.format("%0.2i", math.floor((betweenTime - (d * 60 * 60 * 24)) / 60 / 60))
	local m = string.format("%0.2i", math.floor((betweenTime - (d * 60 * 60 * 24) - (h * 60 * 60)) / 60))
	local s = string.format("%0.2i", betweenTime - (d * 60 * 60 * 24) - (h * 60 * 60) - (m * 60))
	return d .. " days " .. h .. " hours " .. m .. " minutes " .. s .. " secounds"
end

local function removeUser(player: Player, banData)
	local teleportData = {
		["banReason"] = banData.banReason,
		["moderator"] = banData.banModerator,
		["banLength"] = banData.banLength,
		["banType"] = banData.banType,
		["gameid"] = game.PlaceId,
		["theme"] = { Preset = BetterBanning.Preset, Custom = BetterBanning.Custom },
	}

	local TeleportOptions: TeleportOptions = Instance.new("TeleportOptions")
	TeleportOptions:SetTeleportData(teleportData)

	TeleportService:TeleportAsync(9774962238, { player }, TeleportOptions)

	TeleportService.TeleportInitFailed:Connect(function(teleportPlr: Player)
		if player.UserId == teleportPlr.UserId then
			-- Creates in game UI instead of teleport
			local gameData = game.MarketplaceService:GetProductInfo(game.PlaceId)
			local UI = script.OffileUI:Clone()
			local BanFrame = UI.BanFrame
			local BanData = BanFrame.BanData

			UI.Parent = player.PlayerGui

			-- Sets game information up
			BanData.BannedText.Text = '<strong>You have been banned from: <font color="#ff0000">'
				.. gameData["Name"]
				.. "</font></strong>"

			-- Sets Ban Moderator
			BanData.ModeratorText.Text = 'Moderator: <font color="#ff0000">' .. teleportData["moderator"] .. "</font>"

			-- Sets Ban Type
			BanData.TypeText.Text = 'Ban Type: <font color="#ff0000">' .. teleportData["banType"] .. "</font>"

			-- Sets Ban Reason
			BanData.ReasonText.Text = "<strong>Reason Given:</strong><br />" .. teleportData["banReason"]

			-- Background and tiles
			BanFrame.GameBackground.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="
				.. gameData["AssetId"]
				.. "&width=768&height=432&format=png"
			BanFrame.CustomTiles.start:FireClient(player, gameData["IconImageAssetId"])

			-- Sets Ban Time
			if teleportData["banType"] == "Permanent" then
				return
			end

			if teleportData["banType"] == "Server Ban" then
				BanData.TimeText.Text = '<strong>You are banned from that server but you can join another!</strong>'
				return
			end

			local banDone = teleportData["banLength"]

			BanData.TimeText.Text = '<strong>Time Left: <font color="#ff0000">'
				.. formatTime(banDone, os.time())
				.. "</font></strong>"
			player:Kick()
		end
	end)
end

local function detectBan(player: Player)
	local userid: number = player.UserId
	local banData = BetterBanning:GetBan(userid)

	if banData ~= nil then
		-- If player ban exists
		if banData["banType"] ~= "Permanent" and banData["banLength"] < os.time() then
			local GlobalDataStore: GlobalDataStore = DataStoreService:GetDataStore(BetterBanning.DataStore)
			GlobalDataStore:RemoveAsync("Player_" .. userid)
			BetterBanning.UnbanFunction(userid)
		end

		removeUser(player, banData)
	elseif BetterBanning.ServerBans[userid] then
		removeUser(player, BetterBanning.ServerBans[userid])
	end
end

function BetterBanning:GetBan(userid: number)
	if RunService:IsClient() then
		error.error(Players.LocalPlayer, 501, "You can not require BetterBanning through the client.")
		return
	end

	-- Gets GlobalDataStore with the name declared in self.DataStore
	local GlobalDataStore: GlobalDataStore = DataStoreService:GetDataStore(self.DataStore)
	local sucsess, data = pcall(GlobalDataStore.GetAsync, GlobalDataStore, "Player_" .. userid)
	if not sucsess then
		-- If failed to get datastore
		error.scriptError(
			502,
			"Failed to get banned datastore! Try turning on 'Studio Accses to API's' in the security category in Game Settings."
		)
	else
		-- If datastore found
		return data
	end
end

function BetterBanning:Ban(userid: number, banType: string, banLength: number, banReason: string, banModerator: string)
	if RunService:IsClient() then
		error.error(Players.LocalPlayer, 501, "You can not require BetterBanning through the client.")
		return
	end

	if userid == nil then
		warn("Argument 1: UserId is required")
		return
	end
	if banType == nil then
		warn("Argument 2: BanType is required")
		return
	end
	if banType ~= "Permanent" and banLength == nil then
		warn("Argument 3: Ban Length is required if BanType is not permanent")
		return
	end
	if banReason == nil then
		banReason = "No reason given."
	end
	if banModerator == nil then
		banModerator = "Server"
	end

	local player = Players:GetPlayerByUserId(userid)
	local banData = {
		banReason = banReason,
		banModerator = banModerator,
		banLength = banLength,
		banType = banType,
	}

	local GlobalDataStore: GlobalDataStore = DataStoreService:GetDataStore(self.DataStore)
	GlobalDataStore:SetAsync("Player_" .. userid, banData)

	if player then
		removeUser(player, banData)
	end

	self.BanFunction(userid, banData)
end

function BetterBanning:ServerBan(userid: number, banReason: string, banModerator: string)
	if RunService:IsClient() then
		error.error(Players.LocalPlayer, 501, "You can not require BetterBanning through the client.")
		return
	end

	if userid == nil then
		warn("Argument 1: UserId is required")
		return
	end

	if banReason == nil then
		banReason = "No reason given."
	end
	if banModerator == nil then
		banModerator = "Server"
	end

	local player = Players:GetPlayerByUserId(userid)
	local banData = {
		banReason = banReason,
		banModerator = banModerator,
		banType = "Server Ban",
		banLength = os.time()
	}

	self.ServerBans[userid] = banData
	if player then
		removeUser(player, banData)
	end
end

function BetterBanning:Unban(userid: number,  unbanModerator: string?, unbanReason: string?)
	if RunService:IsClient() then
		error.error(Players.LocalPlayer, 501, "You can not require BetterBanning through the client.")
		return
	end

	if userid == nil then
		warn("Argument 1: UserId is required")
		return
	end

	if unbanModerator == nil then
		unbanModerator = "Server"
	end

	local GlobalDataStore: GlobalDataStore = DataStoreService:GetDataStore(self.DataStore)
	GlobalDataStore:RemoveAsync("Player_" .. userid)

	self.UnbanFunction(userid, unbanModerator, unbanReason)
end

function BetterBanning:init(config)
	-- Detects if BetterBanning was run through studio and warns
	if RunService:IsStudio() then
		warn("Teleport functionality inside Roblox Studio is disabled but you will still be kicked if banned.")
	end

	-- Sets up Developer Config
	self.UnbanFunction = require(config.UnbanModuleLocation)
	self.BanFunction = require(config.BanModuleLocation)
	self.DataStore = config.DataStore
	self.Preset = config.Preset
	self.Custom = config.Custom

	-- Goes through all players already in server to detect banned players
    for _, player : Player in Players:GetPlayers() do
        detectBan(player)
    end

	-- Fixes rojo
	script.OffileUI.IgnoreGuiInset = true

	-- Sets up detection of banned players to new players in server
	Players.PlayerAdded:Connect(detectBan)
end

return BetterBanning
