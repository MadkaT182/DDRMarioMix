return Def.ActorFrame {
	Def.Sprite {
		BeginCommand=function(self)
			local Song = GAMESTATE:GetCurrentSong();
			self:LoadFromSongBanner(Song);
		end;
		OnCommand=cmd(scaletoclipped,278,100;x,SCREEN_CENTER_X;y,113);
	};
	LoadActor(THEME:GetPathG("eval","marvelous"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-48);
	};
	LoadActor(THEME:GetPathG("eval","perfect"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-18);
	};
	LoadActor(THEME:GetPathG("eval","great"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+12);
	};
	LoadActor(THEME:GetPathG("eval","good"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+42);
	};
	LoadActor(THEME:GetPathG("eval","miss"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+72);
	};
	LoadActor(THEME:GetPathG("score","label"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+107);
	};
	LoadActor(THEME:GetPathG("maxcombo","label"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+142;zoom,.845);
	};
	LoadActor("Stats")..{};
};