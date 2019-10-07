return Def.ActorFrame {
	Def.Quad{
		OnCommand=cmd(FullScreen;diffusecolor,Color.White);
	};
	LoadActor("nintendo")..{
		InitCommand=cmd(diffusealpha,0;Center;linear,.967;diffusealpha,1;sleep,2.203;linear,.8;diffusealpha,0);
	};
	LoadActor("konami")..{
		InitCommand=cmd(diffusealpha,0;Center;sleep,5.238;linear,.934;diffusealpha,1);
	};
}