local t = Def.ActorFrame{}
local offsetpos = {
	[PLAYER_1] = -900,
	[PLAYER_2] = 900
}
t[#t+1] = Def.Actor{
	OnCommand=function(s)
		if SCREENMAN:GetTopScreen() then
			for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
				SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(pn)):addx( offsetpos[pn] ):linear(0.8):addx( -offsetpos[pn] )
			end
		end
	end,
}

return t;