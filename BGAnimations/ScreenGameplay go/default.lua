return Def.ActorFrame {
	LoadActor( "wego" )..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		OnCommand=cmd(sleep,1.5;diffusealpha,0);
	};
}