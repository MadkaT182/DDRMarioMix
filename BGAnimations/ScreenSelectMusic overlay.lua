local t = Def.ActorFrame {
	Def.Sprite{
		Texture=THEME:GetPathG("","Global/selector.png"),
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X+170,SCREEN_CENTER_Y):addx( SCREEN_RIGHT/2 ):decelerate(0.6):addx( -SCREEN_RIGHT/2 )
		end,
		OffCommand=function(s) s:accelerate(0.6):addx( SCREEN_RIGHT/2 ) end
	};
}

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture=THEME:GetPathG("Global/Header","Under"),
		OnCommand=function(s) s:y( 48 ):halign(0):zoom(1.1):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
		OffCommand=function(s) s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end,
		CancelMessageCommand=function(s)
			GAMESTATE:Env()["BackFromWorkout"] = true
			SOUND:DimMusic(0,0.6)
			GAMESTATE:Env()["GLOBALINTERFACEENV"] = "MainMenu"
		end,
	},
	
	Def.BitmapText{
		Font="_title",
		Text=THEME:GetString("ScreenSelectMusic","HeaderText"),
		OnCommand=function(s) s:xy( 23,43 ):halign(0):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 ) end,
		OffCommand=function(s) s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
	},

	Def.ActorProxy{
		BeginCommand=function(s)
			if SCREENMAN:GetTopScreen() then
				s:SetTarget( SCREENMAN:GetTopScreen():GetChild("Banner") )
			end
			s:xy( 160,114 ):addy( -SCREEN_RIGHT/2 ):decelerate(0.6):addy( SCREEN_RIGHT/2 )
		end,
		OffCommand=function(s) s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end
	}
}

local buttonitems = {"ChooseSong","Mush","Difficulty","Song"}
local shownow = 1

t[#t+1] = Def.Actor{
	HideOrShowMessageCommand=function(s)
		shownow = shownow + 1
		if shownow > #buttonitems then shownow = 1 end
		MESSAGEMAN:Broadcast("HideRest")
	end,
};

local mtng = Def.ActorFrame{}
for i,v in ipairs(buttonitems) do
	mtng[#mtng+1] = Def.Sprite{
	Texture=THEME:GetPathG("Global/Button",v),
	OnCommand=function(s)
		s:y(0):diffusealpha( shownow == i and 1 or 0 )
		:sleep(3):queuemessage("HideOrShow")
	end,
	HideRestMessageCommand=function(s)
		s:stoptweening():linear(0.6):diffusealpha( shownow == i and 1 or 0 ):sleep(3):queuemessage("HideOrShow")
	end,
	}
end

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+180):addy( SCREEN_RIGHT/2 ):decelerate(0.6):addy( -SCREEN_RIGHT/2 ) end,
    OffCommand=function(s) s:accelerate(0.6):addy(300) end,
    Def.Quad{
        OnCommand=function(s) s:zoomto(SCREEN_WIDTH,100):y(30):diffuse( color("#00000099") ) end
	},
	mtng
};

local difficultyStates = {
	Difficulty_Beginner	 = 0,
	Difficulty_Easy		 = 1,
	Difficulty_Medium	 = 2,
	Difficulty_Hard		 = 3,
	Difficulty_Challenge = 4,
};

for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
	local p = Def.ActorFrame{
		InitCommand=function(s)
			s:xy( SCREEN_CENTER_X-370+(140*_), SCREEN_CENTER_Y ):addy( SCREEN_RIGHT/2 ):decelerate(0.6):addy( -SCREEN_RIGHT/2 )
		end,
		OffCommand=function(s) s:accelerate(0.6):addy(320) end,
	}
	-- Maybe change this into an actual graphic?
	-- I don't think people will mind having a squared cornered background.
	p[#p+1] = Def.Quad{ OnCommand=function(s) s:zoomto(118,200):vertalign(top):y(-66):diffuse( color("#00000066") ) end }
	p[#p+1] = Def.Sprite{ Texture=THEME:GetPathG("","MusicSelection/"..ToEnumShortString(pn).."Label"), OnCommand=function(s) s:xy(-36,-50) end }
	p[#p+1] = Def.Sprite{ Texture=THEME:GetPathG("","MusicSelection/DiffLabel"), OnCommand=function(s) s:y(30) end }
	p[#p+1] = Def.Sprite{ Texture=THEME:GetPathG("","MusicSelection/ScoreBG"), OnCommand=function(s) s:y(140) end }
	p[#p+1] = Def.BitmapText{
		Font="HighScore numbers", OnCommand=function(s) s:y(140) end,
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s)
			local SongOrCourse, StepsOrTrail
			if GAMESTATE:IsCourseMode() then
				SongOrCourse = GAMESTATE:GetCurrentCourse()
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
			else
				SongOrCourse = GAMESTATE:GetCurrentSong()
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
			end;

			local profile, scorelist
			local text = string.format("%09i", 0)
			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType()
				local diff = StepsOrTrail:GetDifficulty()
				local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
				local cd = GetCustomDifficulty(st, diff, courseType)

				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					profile = PROFILEMAN:GetProfile(pn)
				else
					-- machine profile
					profile = PROFILEMAN:GetMachineProfile()
				end

				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail)
				assert(scorelist)
				local scores = scorelist:GetHighScores()
				local topscore = scores[1]
				if topscore then
					text = string.format("%09i", topscore:GetScore())
				end
			end
			s:settext(text)
		end,
	}
	for i=0,4 do
		p[#p+1] = Def.Sprite{
			Texture=THEME:GetPathG("","MusicSelection/Difficulties"),
			OnCommand=function(s)
				s:animate(0):setstate(i):xy(20,50+(16*i))
			end,
			["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s)
				if GAMESTATE:GetCurrentSteps(pn) then
					local stp = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
					s:diffuse( difficultyStates[stp] == i and Color.White or color("#999999") )
					:x( difficultyStates[stp] == i and 15 or 20 )
				end
			end,
		}
	end
	t[#t+1] = p
end

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Alpha(Color.Black,0) )
	end,
	OffCommand=function(s) s:sleep(0.6):linear(1):diffusealpha(1) end,
	CancelMessageCommand=function(s) s:linear(0.6):diffusealpha(1) end,
}

return t;