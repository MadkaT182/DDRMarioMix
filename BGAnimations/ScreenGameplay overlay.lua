local t = Def.ActorFrame{}

local function LoadSteps(s,player)
	local difficultyStates = {
		Difficulty_Beginner	 = 0,
		Difficulty_Easy		 = 2,
		Difficulty_Medium	 = 4,
		Difficulty_Hard		 = 6,
		Difficulty_Challenge = 8,
		Difficulty_Edit		 = 10,
	};
	local selection;
	if GAMESTATE:IsCourseMode() then
		selection = GAMESTATE:GetCurrentTrail(player);
		local entry = selection:GetTrailEntry(GAMESTATE:GetLoadingCourseSongIndex()+1)
		selection = entry:GetSteps()
	else
		selection = GAMESTATE:GetCurrentSteps(player);
	end;
	local diff = selection:GetDifficulty()
	local state = difficultyStates[diff] or 10;
	if player == PLAYER_2 then state = state + 1; end;
	return state;
end;

for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
	local side = (pn == PLAYER_2 and -1 or 1)
	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=function(s) s:y(SCREEN_TOP+48):addy( -200 ):linear(0.8):addy( 200 ) end,
			Def.Sprite{ Texture=THEME:GetPathG("","Gameplay/LifeNormal"), InitCommand=function(s) s:x(SCREEN_CENTER_X-(245*side)):zoomx( side ) end },
			Def.Sprite{ Texture=THEME:GetPathG("","Gameplay/LifeBG"), InitCommand=function(s) s:x(SCREEN_CENTER_X-(187*side)):zoomx( side ) end },
			Def.ActorProxy{
				BeginCommand=function(s)
					if SCREENMAN:GetTopScreen():GetChild("Life"..ToEnumShortString(pn)) then
						s:SetTarget(SCREENMAN:GetTopScreen():GetChild("Life"..ToEnumShortString(pn)))
						:xy( SCREEN_CENTER_X-(177*side),SCREEN_TOP ):zoomx( side )
					end
				end
			}
		};
		Def.ActorFrame{
			InitCommand=function(s) s:y(SCREEN_BOTTOM-56):addy( 200 ):linear(0.8):addy( -200 ) end,
			Def.Sprite{
				Texture=THEME:GetPathG("","Gameplay/ScoreNormal"),
				InitCommand=function(s) s:x(SCREEN_CENTER_X-(222*side)):zoomx( side ) end },
			Def.BitmapText{
				InitCommand=function(s) s:x(SCREEN_CENTER_X-(108*side)) end,
				Font="Gameplay "..ToEnumShortString(pn).."_score",
				Text=string.format( "%09i", 0),
				JudgmentMessageCommand=function(s, params)
					s:settext( string.format( "%09i" ,STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore() ) )
				end;
			},
		};
		Def.Sprite{
			Texture=THEME:GetPathG("StepsDisplayGameplay","frame"),
			InitCommand=function(s)
				local po = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions();
				s:xy(SCREEN_CENTER_X-(257*side),po:Reverse() ~= 0 and SCREEN_TOP+53 or SCREEN_BOTTOM-66)
				:pause():setstate(LoadSteps(s,pn))
				:addx( -200*side ):linear(1):addx( 200*side )
			end;
		}
	}
end

return t;