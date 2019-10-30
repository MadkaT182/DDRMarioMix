local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("","Gameplay/ready" ),
	InitCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
	OnCommand=function(s) s:sleep(3):diffusealpha(0) end
};

local offsetpos = {
	[PLAYER_1] = 500,
	[PLAYER_2] = -500
}
for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
	local side = (pn == PLAYER_2 and -1 or 1)
	t[#t+1] = Def.Actor{
		OnCommand=function(s) s:playcommand("SetupPlayers") end,
		SetupPlayersCommand=function(s)
			if SCREENMAN:GetTopScreen() then
				SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(pn)):addx( -500*side ):linear(0.8):addx( 500*side )
			end
		end,
	}
end

return t;