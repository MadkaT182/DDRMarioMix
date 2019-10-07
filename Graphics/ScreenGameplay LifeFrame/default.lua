local t = Def.ActorFrame{
	OnCommand=cmd(y,SCREEN_TOP+48);
};

--TODO: Revamp this
if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = Def.ActorFrame{
		LoadActor("normal")..{
			InitCommand=cmd(x,SCREEN_CENTER_X-245);
		};
		LoadActor("bg")..{
			InitCommand=cmd(x,SCREEN_CENTER_X-187);
		};
	};
end
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	t[#t+1] = Def.ActorFrame{
		LoadActor("normal")..{
			InitCommand=cmd(x,SCREEN_CENTER_X+245;zoomx,-1);
		};
		LoadActor("bg")..{
			InitCommand=cmd(x,SCREEN_CENTER_X+187;zoomx,-1);
		};
	};
end

return t