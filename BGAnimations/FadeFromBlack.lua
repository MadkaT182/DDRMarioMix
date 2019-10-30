return Def.ActorFrame {
	--Black overlay
	Def.Quad{
		OnCommand=function(s)
			s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
			:diffuse(Color.Black):linear(0.5):diffusealpha(0)
		end
	};
};