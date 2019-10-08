-- PlayerSelect Implementation
--------------------------------

-- Begin Items
local Items = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
}
local StuffShown = {
    "About the theme!",
    "The making of MMSM5",
    "Other Items",
    "FAQ",
    "Up, Down, Left, Right",
    "Song open (01)",
    "Song open (02)",
    "Song open (03)",
    "Song open (04)",
    "Song open (05)",
    "Song open (06)",
    "Song open (07)",
    "Song open (08)",
    "Song open (09)",
    "Song open (10)",
    "Song open (11)",
    "Song open (12)",
    "Song open (13)",
    "Song open (14)",
    "Song open (15)",
    "Song open (16)",
    "Song open (17)",
    "Song open (18)",
    "Song open (19)",
    "Song open (20)",
    "Song open (21)",
    "Song open (22)",
    "Song open (23)",
    "Song open (24)",
    "Song open (25)",
    "Song open (26)",
    "Song open (27)",
    "Song open (28)",
    "Minigame open (01)",
    "Minigame open (02)",
    "Minigame open (03)",
    "Minigame open (04)",
    "Minigame open (05)",
    "Minigame open (06)",
    "Minigame open (07)",
    "Minigame open (08)",
    "Minigame open (09)",
    "Minigame open (10)",
    "Minigame open (11)",
    "Minigame open (12)",
    "World 1 cleared!",
    "World 2 cleared!",
    "World 3 cleared!",
    "World 4 cleared!",
    "Story Mode cleared!",
    "Dance Level B!",
    "Dance Level A!",
    "Dance Level F…",
    "Super Hard level open!",
    "All songs open!",
    "100 combos!"
}

-- This is used to track our position
local cursorindex = 1
local selecteditem,lockedinput
local indexset = 0

for i,v in ipairs(Items) do
    Items[i+(8*indexset)] = StuffShown[i+(8*indexset)]
end

local function OffsetVerify(offset)
    local changed = true
    cursorindex = cursorindex + offset
    if cursorindex > #Items then
        changed=false
        indexset = indexset + 1
        for i,v in ipairs(Items) do
            Items[i] = StuffShown[i+(8*indexset)]
        end
        cursorindex = 1
        MESSAGEMAN:Broadcast("UpdateItemLabels")
    end
    if cursorindex < 1 then
        changed=false
        indexset = indexset - 1
        for i,v in ipairs(Items) do
            Items[i] = StuffShown[i+(8*indexset)]
        end
        cursorindex = #Items
        MESSAGEMAN:Broadcast("UpdateItemLabels")
    end
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
            lockedinput = true
            selecteditem = cursorindex
            MESSAGEMAN:Broadcast("SelectedEntry")
        end,
        ["Back"] = function()
            if not lockedinput then
                GAMESTATE:Env()["BackToMainMenu"] = true
                GAMESTATE:Env()["BackFromWorkout"] = true
                GAMESTATE:Env()["GLOBALINTERFACEENV"] = "MainMenu"
                SCREENMAN:GetTopScreen():SetPrevScreenName( "GlobalMenu" ):StartTransitioningScreen("SM_GoToPrevScreen")
                MESSAGEMAN:Broadcast("SelectedEntry")
            end
            if lockedinput then
                lockedinput = false
                MESSAGEMAN:Broadcast("SelectedEntry")
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
    OnCommand=function(s)
        MESSAGEMAN:Broadcast("CursorChanged")
        SCREENMAN:GetTopScreen():AddInputCallback(Input)
    end,
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","Information/GWZE01_fa65357a_9"),
    OnCommand=function(s) s:xy( 30,SCREEN_CENTER_Y ):halign(0):zoom(1.6) end,
    SelectedEntryMessageCommand=function(s) if not lockedinput and GAMESTATE:Env()["BackToMainMenu"] then s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end end,
}

t[#t+1] = Def.Quad{
    InitCommand=function(s)
        s:xy( 30,SCREEN_CENTER_Y-160+36 ):halign(0)
        :zoomto( 420,30 ):diffuse( Alpha(Color.Orange,0.5) )
    end,
    SelectedEntryMessageCommand=function(s)
        s:sleep( lockedinput and 0 or 0.4):diffusealpha( lockedinput and 0 or 0.5 )
    end,
    CursorChangedMessageCommand=function(s)
        s:stoptweening():decelerate(0.2):y( SCREEN_CENTER_Y-158+(36*cursorindex) )
    end,
}

for s,v in ipairs(Items) do
    local offset = s
    RI[#RI+1] = Def.ActorFrame{
        InitCommand=function(s)
            s:xy( 240, SCREEN_CENTER_Y-160+(36*offset) )
        end,
        SelectedEntryMessageCommand=function(s)
            if lockedinput then
                s:diffusealpha( 0 )
            else
                s:sleep(0.5):diffusealpha( 1 )
            end
        end,

        Def.BitmapText{
            Font="Common Normal",
            Text=v or "",
            OnCommand=function(s) s:halign(0):x(-200):shadowlengthy(3) end,
            UpdateItemLabelsMessageCommand=function(s)
                s:settext( Items[offset] )
            end,
        }
    }
end

t[#t+1] = Def.BitmapText{
    Font="Common Normal",
    OnCommand=function(s) s:halign(0):x(40):shadowlengthy(3) end,
    SelectedEntryMessageCommand=function(s)
        s:settext( Items[selecteditem] )
        if lockedinput then
            s:y( SCREEN_CENTER_Y-160+(36*selecteditem) )
            :sleep(0.2):linear(0.2):y( SCREEN_CENTER_Y-160+(36*1) )
        else
            s:y( SCREEN_CENTER_Y-160+(36*1) )
            :sleep(0.2):linear(0.2):y( SCREEN_CENTER_Y-160+(36*selecteditem) )
        end
    end,
}

t[#t+1] = Def.BitmapText{
    Font="Common Normal",
    OnCommand=function(s)
        s:halign(0):vertalign(top):xy(40,SCREEN_CENTER_Y-160+(36*2)):shadowlengthy(3)
        :zoom(0.6):wrapwidthpixels(500)
    end,
    SelectedEntryMessageCommand=function(s)
        s:settext( THEME:GetString("Information",Items[selecteditem]) )
        s:sleep( lockedinput and 0.4 or 0):diffusealpha( lockedinput and 1 or 0 )
    end,
}

t[#t+1] = RI;

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("Global/Header","Under"),
    OnCommand=function(s) s:xy( 0,55 ):halign(0):zoomx(0.9) end,
    SelectedEntryMessageCommand=function(s) if not lockedinput and GAMESTATE:Env()["BackToMainMenu"] then s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end end,
}

t[#t+1] = Def.BitmapText{
    Font="_title",
    Text=THEME:GetString("Information","HeaderText"),
    OnCommand=function(s) s:xy( 20,50 ):halign(0):zoomx(0.9) end,
    SelectedEntryMessageCommand=function(s) if not lockedinput and GAMESTATE:Env()["BackToMainMenu"] then s:accelerate(0.6):addy( -SCREEN_RIGHT/2 ) end end,
}

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+180) end,
    SelectedEntryMessageCommand=function(s)
        if not lockedinput and GAMESTATE:Env()["BackToMainMenu"] then
            s:accelerate(0.6):diffusealpha(0)
        end
    end,
    Def.Sprite{
        Texture=THEME:GetPathG("Global/Button","UpDownChoose"),
        OnCommand=function(s) s:zoom(0.9) end,
        SelectedEntryMessageCommand=function(s)
            local input = lockedinput and "UpDownScroll" or "UpDownChoose"
            s:Load( THEME:GetPathG("Global/Button",input) )
        end,
    },
};

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