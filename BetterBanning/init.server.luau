--[[


██████╗░███████╗████████╗████████╗███████╗██████╗   ██████╗ ░█████╗░███╗ ░██╗███╗ ░██╗██╗███╗ ░██╗░██████╗
██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗  ██╔══██╗██╔══██╗████╗░██║████╗░██║██║████╗░██║██╔════╝
██████╦╝█████╗░░░░░██║░░░░░░██║░░░█████╗░░██████╔╝  ██████╦╝███████║██╔██╗██║██╔██╗██║██║██╔██╗██║██║░░██╗
██╔══██╗██╔══╝░░░░░██║░░░░░░██║░░░██╔══╝░░██╔══██╗  ██╔══██╗██╔══██║██║╚████║██║╚████║██║██║╚████║██║░░╚██╗
██████╦╝███████╗░░░██║░░░░░░██║░░░███████╗██║░░██║  ██████╦╝██║░░██║██║░╚███║██║░╚███║██║██║░╚███║╚██████╔╝
╚═════╝░╚══════╝░░░╚═╝░░░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝  ╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚══╝╚═╝╚═╝░░╚══╝░╚═════╝
		█▀▄▀█ ▄▀█ █▀▄ █▀▀   █▄▄ █▄█   ▀█▀ █▀█ █ ▄▀█ █▄ █ █▀▀ █   █▀▀ ▄▀█ █▀█ █▀█ ▄▀█ █▄█
		█ ▀ █ █▀█ █▄▀ ██▄   █▄█  █     █  █▀▄ █ █▀█ █ ▀█ █▄█ █▄▄ ██▄ █▀█ █▀▄ █▀▄ █▀█  █ 
				R o b l o x    b a n n i n g    m a d e    q u i c k   a n d    e a s y!





██ ███ █  █ ██ █ ███ ██ ███ ███ ███ █ ███ █  █ █
█  █ █ ██▄█ █▄ █ █╬▄ █▄ █▄╬ █▄█  █  █ █ █ ██▄█  
██ █▄█ █ ██ █  █ █▄█ █▄ █ █ █ █	 █  █ █▄█ █ ██ █ --]]

local config = {
	-- THEME -- 
	Preset = "Custom";          			-- Preset list is linked in the communication server and devfourm post
	Custom = {								-- Editable custom values in the communication server and devfourm post 
		FontFamily = Enum.Font.Fondamento.Name,
		FontWeight = Enum.FontWeight.Bold.Value,
		Background = 4966005286
	};
												-- ( Theme only works with teleport functionality enabled! ) --

	-- TECHNICAL --
	DataStore = "BetterBanning";			-- Replace with the ban datastore of your choise
	BanModuleLocation = script.Events.onBan;		-- Learn how to use the ban module in the communication server or on the devfourm post
	UnbanModuleLocation = script.Events.onUnban;	-- Learn how to use the unban module in the communication server or on the devfourm post
}





-- MAIN BETTERBANNING MODULE --
-- DO NOT REMOVE --
require(script.MainModule):init(config)