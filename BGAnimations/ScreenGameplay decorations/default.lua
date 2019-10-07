return Def.ActorFrame {
	LoadActor(THEME:GetPathG("ScreenGameplay","LifeFrame"))..{
		InitCommand=cmd(draworder,1);
	};
	LoadActor(THEME:GetPathG("ScreenGameplay","ScoreFrame"))..{
		InitCommand=cmd(draworder,1);
	};
	LoadActor("diff")..{
		InitCommand=cmd(draworder,1);
	};
};