--------------------------------
-- Title Screen Implementation
--------------------------------

-- Begin Items
local Items = {
    {"Story","FreeMode","Minigame","Information"},
    {"Records","Workout","Options"}
}
local OptionSelect = {
    {nil,"PlayerSelect",nil,"Information"},
    {nil,"WorkoutMenu","Options"}
}

-- This is used to track our position
local cursorindex = {1,1}
local function OffsetVerify(val,offset)
    local changed = true
    cursorindex[val] = cursorindex[val] + offset
    if cursorindex[2] > #Items then cursorindex[2] = #Items changed=false end
    if cursorindex[2] < 1 then cursorindex[2] = 1 changed=false end
    if cursorindex[1] > #Items[cursorindex[2]] then cursorindex[1] = #Items[cursorindex[2]] changed=false end
    if cursorindex[1] < 1 then cursorindex[1] = 1 changed=false end
    MESSAGEMAN:Broadcast("CursorChanged")
    if changed then SOUND:PlayOnce( THEME:GetPathS("Common","value") ) end
end

-- Begin input tracker
local function Input(event)
    local IN = {
        ["MenuLeft"] = function() OffsetVerify( 1, -1 ) end,
        ["MenuRight"] = function() OffsetVerify( 1, 1 ) end,
        ["MenuUp"] = function() OffsetVerify( 2, -1 ) end,
        ["MenuDown"] = function() OffsetVerify( 2, 1 ) end,
        ["Start"] = function()
            SOUND:PlayOnce( THEME:GetPathS("Common","start") )
            if OptionSelect[cursorindex[2]][cursorindex[1]] then
                MESSAGEMAN:Broadcast("SelectedEntry")
                GAMESTATE:Env()["GLOBALINTERFACEENV"] = OptionSelect[cursorindex[2]][cursorindex[1]]
                SCREENMAN:GetTopScreen():SetNextScreenName( "GlobalMenu" ):StartTransitioningScreen("SM_GoToNextScreen")
            else
                SCREENMAN:SystemMessage("This option is not available yet!")
            end
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
        s:fov(90):rotationy(-20):xy( 10,50 )
        MESSAGEMAN:Broadcast("CursorChanged")
        SCREENMAN:GetTopScreen():AddInputCallback(Input)
        if GAMESTATE:Env()["BackToMainMenu"] then
            s:addy( -SCREEN_HEIGHT ):decelerate(0.6):addy( SCREEN_HEIGHT )
        end

        -- Before anything, we need to reset the players.
        for _,pn in pairs( GAMESTATE:GetEnabledPlayers() ) do
            GAMESTATE:UnjoinPlayer(pn)
        end
    end,
    SelectedEntryMessageCommand=function(s) s:linear(0.6):addy(-500) end,

    Def.Sprite{
        Texture=THEME:GetPathG("MainMenu/Paper","BG"),
        OnCommand=function(s) s:align(0,0) end,
    }
}

for s,v in ipairs(Items) do
    local yoffset = s
    for i,q in ipairs(v) do
        RI[#RI+1] = Def.ActorFrame{
            OnCommand=function(s)
                s:bob():xy( 100*i, (100*yoffset) )
                :effectperiod(4):effectoffset(0.4*i)
            end,
            Def.Sprite{
                Texture=THEME:GetPathG("","MainMenu/MusicNoteChoices/"..q),
                OnCommand=function(s)
                    s:wag():effectperiod(4):effectmagnitude(0,0,8):effectoffset( 0.3*i )
                end,
            }
        }
    end
end

t[#t+1] = loadfile( THEME:GetPathG("","Global/SkyBG.lua") )();

RI[#RI+1] = Def.ActorFrame{
    Def.Sprite{
        Texture=THEME:GetPathG("","Models/Hand/tex"),
        OnCommand=function(s)
            s:wag():rotationz(-90):effectperiod(0.3):effectmagnitude(30,0,0)
        end,
        CursorChangedMessageCommand=function(s)
            s:xy( 100*cursorindex[1], 50+(100*cursorindex[2]) )
        end,
    }
}

t[#t+1] = RI;

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+180)
        if GAMESTATE:Env()["BackToMainMenu"] then
            s:addy( SCREEN_HEIGHT/2 ):decelerate(0.6):addy( -SCREEN_HEIGHT/2 )
            GAMESTATE:Env()["BackToMainMenu"] = false
        end
    end,
    SelectedEntryMessageCommand=function(s) s:linear(1):addy(400) end,
    Def.Sprite{
        Texture=THEME:GetPathG("Global/Description","BG"),
        OnCommand=function(s) s:zoom(1.15) end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("Global/Button","4Side"),
        OnCommand=function(s) s:zoom(0.9):y( -50 ) end,
    },

    Def.BitmapText{
        Font="sysdesc",
        OnCommand=function(s) s:y(-15):zoom(0.8) end,
        CursorChangedMessageCommand=function(s) s:settext( Items[cursorindex[2]][cursorindex[1]] ) end,
        SelectedEntryMessageCommand=function(s) s:linear(0.1):diffusealpha(0) end
    },

    Def.BitmapText{
        Font="Common Normal",
        OnCommand=function(s) s:y(10):zoom(0.8) end,
        CursorChangedMessageCommand=function(s) s:settext( THEME:GetString("MainMenu",Items[cursorindex[2]][cursorindex[1]]) ) end,
        SelectedEntryMessageCommand=function(s) s:linear(0.1):diffusealpha(0) end
    }
};

t[#t+1] = Def.Quad{
	OnCommand=function(s)
        s:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Alpha(Color.Black,0) )
        if GAMESTATE:Env()["BackFromWorkout"] then
            s:diffusealpha(1):linear(0.5):diffusealpha(0)
            GAMESTATE:Env()["BackFromWorkout"] = false
        end
	end,
    OffCommand=function(s)
        if (cursorindex[2] == 2 and cursorindex[1] == 2) or (cursorindex[2] == 1 and cursorindex[1] == 4) or (cursorindex[2] == 2 and cursorindex[1] == 3) then
            s:linear(0.5):diffusealpha(1)
        end
    end,
}

return t;