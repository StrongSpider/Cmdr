type BanData = {
	BanReason : string,
	BanModerator : string,
	BanType : string,
	BanLength : number
}

return function(userid : number, BanData : BanData)
	-- Function is called when a ban is triggered
	
	print("Player Banned!")
	print(BanData)
end