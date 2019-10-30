--------------------------------
-- Workout Menu
--------------------------------

-- Begin Items
local Items = { "","","","","","","","" }
local NumProfiles = PROFILEMAN:GetNumLocalProfiles()

-- This is used to track our position
local cursorindex = 1
local function OffsetVerify(offset)
    local changed = true
    cursorindex = cursorindex + offset
    if cursorindex > #Items then cursorindex = #Items changed=false end
    if cursorindex < 1 then cursorindex = 1 changed=false end
    MESSAGEMAN:Broadcast("CursorChanged")
    if changed then SOUND:PlayOnce( THEME:GetPathS("Common","value") ) end
end

-- Begin input tracker
local function Input(event)
    local IN = {
        ["MenuUp"] = function() OffsetVerify( -1 ) end,
        ["MenuDown"] = function() OffsetVerify( 1 ) end,
        ["Start"] = function(pn)
            SOUND:PlayOnce( THEME:GetPathS("Common","start") )
            MESSAGEMAN:Broadcast("SelectedEntry")
            -- if OptionSelect[cursorindex[2]][cursorindex[1]] then
                -- SCREENMAN:GetTopScreen():SetNextScreenName( OptionSelect[cursorindex[2]][cursorindex[1]] ):StartTransitioningScreen("SM_GoToNextScreen")
            -- end
        end,
        ["Back"] = function()
            GAMESTATE:Env()["BackFromWorkout"] = true
            GAMESTATE:Env()["BackToMainMenu"] = true
            GAMESTATE:Env()["GLOBALINTERFACEENV"] = "MainMenu"
            MESSAGEMAN:Broadcast("SelectedEntry")
            SCREENMAN:GetTopScreen():SetPrevScreenName( "GlobalMenu" ):StartTransitioningScreen("SM_GoToPrevScreen")
        end
    }
    if not event.PlayerNumber then return end
    -- Input that occurs at the moment the button is pressed.
    if ToEnumShortString(event.type) == "FirstPress" then
        if IN[event.GameButton] then IN[event.GameButton](event.PlayerNumber) end
    end
end

local t = Def.ActorFrame{}
local RI = Def.ActorFrame{
    InitCommand=function(s) MESSAGEMAN:Broadcast("UpdateBackground") end,
    OnCommand=function(s)
        MESSAGEMAN:Broadcast("CursorChanged")
        SCREENMAN:GetTopScreen():AddInputCallback(Input)
    end,
    SelectedEntryMessageCommand=function(s)
        if not GAMESTATE:Env()["BackFromWorkout"] then
            s:accelerate(0.6):addx( SCREEN_RIGHT/2 )
        end
    end,
}

for s,v in ipairs(Items) do
    local offset = s
    if offset-1 < NumProfiles and PROFILEMAN:GetLocalProfileFromIndex(offset-1) then
        v = PROFILEMAN:GetLocalProfileFromIndex(offset-1)
        Items[offset] = PROFILEMAN:GetLocalProfileFromIndex(offset-1)
    else
        v = nil
    end
    RI[#RI+1] = Def.ActorFrame{
        InitCommand=function(s)
            s:xy( SCREEN_RIGHT+30, SCREEN_CENTER_Y-160+(36*offset) )
        end,
        CursorChangedMessageCommand=function(s)
            s:stoptweening():decelerate(0.2):x( offset == cursorindex and SCREEN_RIGHT or SCREEN_RIGHT+30 )
        end,

        Def.Sprite{
            Texture=THEME:GetPathG("","Workout/ItemBase"),
            OnCommand=function(s) s:halign(1) end,
        },
        Def.BitmapText{
            Font="Common Normal",
            Text=v and v:GetDisplayName() or "--------",
            OnCommand=function(s) s:halign(0):x(-200) end,
        }
    }
end

t[#t+1] = RI;

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("Global/Header","Under"),
    OnCommand=function(s) s:y( 55 ):halign(0):zoomx(0.9) end,
    SelectedEntryMessageCommand=function(s) if not GAMESTATE:Env()["BackFromWorkout"] then s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end end,
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Global/SelectorWide"),
    InitCommand=function(s) s:xy( SCREEN_RIGHT+120,SCREEN_CENTER_Y-160+36 ):halign(1):zoom(0.6) end,
    SelectedEntryMessageCommand=function(s) if not GAMESTATE:Env()["BackFromWorkout"] then s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end end,
    CursorChangedMessageCommand=function(s)
        s:stoptweening():decelerate(0.2):y( SCREEN_CENTER_Y-160+(36*cursorindex) )
    end,
}

t[#t+1] = Def.BitmapText{
    Font="_title",
    Text=THEME:GetString("WorkoutMenu","HeaderText"),
    OnCommand=function(s) s:xy( 20,50 ):halign(0):zoomx(0.9) end,
    SelectedEntryMessageCommand=function(s) if not GAMESTATE:Env()["BackFromWorkout"] then s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end end,
}

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+180) end,
    SelectedEntryMessageCommand=function(s) s:accelerate(0.6):diffusealpha(0) end,
    Def.Quad{
        OnCommand=function(s) s:zoomto(SCREEN_WIDTH,100):y(30):diffuse( color("#00000099") ) end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("Global/Button","UpDownChange"),
        OnCommand=function(s) s:zoom(0.9) end,
        CursorChangedMessageCommand=function(s)
            if cursorindex > NumProfiles then
                s:Load( THEME:GetPathG("Global/Button","UpDownCreate") )
            else
                s:Load( THEME:GetPathG("Global/Button","UpDownChange") )
            end
        end,
    },
};

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Workout/WorkoutInfoBar"),
    OnCommand=function(s)
        s:halign(0):y(SCREEN_CENTER_Y)
    end,
}

t[#t+1] = Def.BitmapText{
    Font="Result Stats",
    OnCommand=function(s)
        s:halign(0):xy(160,SCREEN_CENTER_Y-96)
    end,
    CursorChangedMessageCommand=function(s)
        if type(Items[cursorindex]) == "userdata" then
            s:settext( string.format( "%3i", Items[cursorindex]:GetWeightPounds() ) )
        end
    end,
}

t[#t+1] = Def.BitmapText{
    Font="Result Stats",
    OnCommand=function(s)
        s:halign(1):xy(240,SCREEN_CENTER_Y-40)
    end,
    CursorChangedMessageCommand=function(s)
        if type(Items[cursorindex]) == "userdata" then
            s:settext( string.format( "% 3.3f", Items[cursorindex]:GetCaloriesBurnedToday() ) )
        end
    end,
}

t[#t+1] = Def.BitmapText{
    Font="Result Stats",
    OnCommand=function(s)
        s:halign(1):xy(200,SCREEN_CENTER_Y+120)
    end,
    CursorChangedMessageCommand=function(s)
        if type(Items[cursorindex]) == "userdata" then
            s:settext( string.format( "% 10.3f", Items[cursorindex]:GetTotalCaloriesBurned() ) )
        end
    end,
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Alpha(Color.Black,1) ):linear(1):diffusealpha(0)
	end,
    OffCommand=function(s) s:sleep(0.6):linear(1):diffusealpha(1) end,
    SelectedEntryMessageCommand=function(s)
        if GAMESTATE:Env()["BackFromWorkout"] then
            s:stoptweening():linear(0.5):diffusealpha(1)
        end
    end,
}

return t;