-- Nexus UI Library
-- A premium Roblox UI library with 4K support and enhanced features

local Nexus = {
    Version = "1.0.0",
    Name = "Nexus",
    Creator = {},
    Themes = {},
    Elements = {},
    Configs = {},
    Services = {},
    Notifications = {},
    Windows = {},
    CurrentWindow = nil,
    UIScale = 1,
    Transparency = 0,
    Language = "en",
    Debug = false
}

-- Core Services
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

-- Utility Functions
local function cloneref(instance)
    return (cloneref or clonereference or function(obj) return obj end)(instance)
end

local function protectgui(gui)
    local protect = protectgui or (syn and syn.protect_gui) or function() end
    protect(gui)
end

local function gethui()
    return gethui and gethui() or CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
end

local request = http_request or (syn and syn.request) or request or function() return {Body = ""} end

-- Creator Module
Nexus.Creator = {
    Font = "rbxassetid://12187365364",
    DefaultProperties = {
        ScreenGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = "Sibling",
            IgnoreGuiInset = true
        },
        Frame = {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1,1,1)
        },
        TextLabel = {
            BackgroundTransparency = 1,
            Text = "",
            RichText = true,
            TextColor3 = Color3.new(1,1,1),
            TextSize = 14,
            Font = Enum.Font.SourceSans
        },
        TextButton = {
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            TextColor3 = Color3.new(1,1,1),
            TextSize = 14,
            Font = Enum.Font.SourceSans
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0
        },
        ScrollingFrame = {
            ScrollBarImageTransparency = 1,
            BorderSizePixel = 0,
            BackgroundTransparency = 1
        }
    },
    Objects = {},
    Signals = {},
    Icons = {},
    Localization = {}
}

function Nexus.Creator:New(class, properties, children)
    local obj = Instance.new(class)
    
    -- Apply default properties
    for prop, value in pairs(self.DefaultProperties[class] or {}) do
        obj[prop] = value
    end
    
    -- Apply custom properties
    for prop, value in pairs(properties or {}) do
        if prop ~= "ThemeTag" then
            obj[prop] = value
        end
    end
    
    -- Add children
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    
    -- Theme support
    if properties and properties.ThemeTag then
        self.Objects[obj] = {
            Object = obj,
            Properties = properties.ThemeTag
        }
        self:UpdateTheme(obj)
    end
    
    return obj
end

function Nexus.Creator:Tween(obj, time, properties, easingStyle, easingDirection)
    return TweenService:Create(obj, TweenInfo.new(time, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), properties)
end

function Nexus.Creator:UpdateTheme(target)
    local function applyTheme(objData)
        for property, themeKey in pairs(objData.Properties) do
            local theme = Nexus.Themes[Nexus.CurrentTheme or "Dark"]
            if theme and theme[themeKey] then
                local value = theme[themeKey]
                if typeof(value) == "Color3" then
                    objData.Object[property] = value
                elseif typeof(value) == "table" and value.Color then
                    -- Handle gradients
                    local gradient = objData.Object:FindFirstChild("UIGradient") or Instance.new("UIGradient")
                    gradient.Color = value.Color
                    gradient.Transparency = value.Transparency
                    gradient.Parent = objData.Object
                end
            end
        end
    end
    
    if target then
        local objData = self.Objects[target]
        if objData then applyTheme(objData) end
    else
        for _, objData in pairs(self.Objects) do
            applyTheme(objData)
        end
    end
end

-- Theme System
Nexus.Themes = {
    Dark = {
        Name = "Dark",
        Background = Color3.fromHex("#0A0A0A"),
        Surface = Color3.fromHex("#1A1A1A"),
        SurfaceVariant = Color3.fromHex("#2A2A2A"),
        Primary = Color3.fromHex("#0091FF"),
        Secondary = Color3.fromHex("#6A11CB"),
        Success = Color3.fromHex("#00FF88"),
        Warning = Color3.fromHex("#FFAA00"),
        Error = Color3.fromHex("#FF4444"),
        Text = Color3.fromHex("#FFFFFF"),
        TextSecondary = Color3.fromHex("#B0B0B0"),
        TextDisabled = Color3.fromHex("#666666"),
        Border = Color3.fromHex("#333333"),
        Shadow = Color3.fromHex("#000000")
    },
    Light = {
        Name = "Light",
        Background = Color3.fromHex("#F5F5F5"),
        Surface = Color3.fromHex("#FFFFFF"),
        SurfaceVariant = Color3.fromHex("#F0F0F0"),
        Primary = Color3.fromHex("#0066CC"),
        Secondary = Color3.fromHex("#8B5CF6"),
        Success = Color3.fromHex("#00AA55"),
        Warning = Color3.fromHex("#FF8800"),
        Error = Color3.fromHex("#CC0000"),
        Text = Color3.fromHex("#000000"),
        TextSecondary = Color3.fromHex("#555555"),
        TextDisabled = Color3.fromHex("#999999"),
        Border = Color3.fromHex("#DDDDDD"),
        Shadow = Color3.fromHex("#000000")
    },
    Neon = {
        Name = "Neon",
        Background = Color3.fromHex("#0F0F23"),
        Surface = Color3.fromHex("#1A1A2E"),
        SurfaceVariant = Color3.fromHex("#16213E"),
        Primary = Color3.fromHex("#00D4FF"),
        Secondary = Color3.fromHex("#FF00FF"),
        Success = Color3.fromHex("#00FF41"),
        Warning = Color3.fromHex("#FFFF00"),
        Error = Color3.fromHex("#FF0040"),
        Text = Color3.fromHex("#FFFFFF"),
        TextSecondary = Color3.fromHex("#A0A0A0"),
        TextDisabled = Color3.fromHex("#707070"),
        Border = Color3.fromHex("#2A2A4A"),
        Shadow = Color3.fromHex("#000000")
    },
    Glass = {
        Name = "Glass",
        Background = Color3.fromHex("#0A0A0ACC"),
        Surface = Color3.fromHex("#1A1A1AAA"),
        SurfaceVariant = Color3.fromHex("#2A2A2A88"),
        Primary = Color3.fromHex("#0091FF"),
        Secondary = Color3.fromHex("#6A11CB"),
        Success = Color3.fromHex("#00FF88"),
        Warning = Color3.fromHex("#FFAA00"),
        Error = Color3.fromHex("#FF4444"),
        Text = Color3.fromHex("#FFFFFF"),
        TextSecondary = Color3.fromHex("#B0B0B0"),
        TextDisabled = Color3.fromHex("#666666"),
        Border = Color3.fromHex("#FFFFFF44"),
        Shadow = Color3.fromHex("#00000088")
    }
}

-- Icon System
function Nexus.Creator:LoadIcons()
    local iconURL = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
    local success, icons = pcall(function()
        return loadstring(request({Url = iconURL, Method = "GET"}).Body)()
    end)
    if success then
        self.Icons = icons
        icons.SetIconsType("lucide")
    end
end

function Nexus.Creator:Icon(iconName, returnData)
    if not self.Icons.Icon2 then return nil end
    return self.Icons.Icon2(iconName, nil, returnData ~= false)
end

-- Element Components
Nexus.Elements = {}

-- Window Element
function Nexus.Elements:Window(config)
    local window = {
        __type = "Window",
        Title = config.Title or "Nexus Window",
        Size = config.Size or UDim2.fromOffset(800, 600),
        Position = config.Position or UDim2.fromScale(0.5, 0.5),
        Theme = config.Theme or "Dark",
        Acrylic = config.Acrylic or false,
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable or false,
        Transparency = config.Transparency or 0,
        Tabs = {},
        Elements = {},
        AllElements = {},
        Folder = config.Folder or "Nexus"
    }
    
    -- Create main GUI
    local screenGui = self:New("ScreenGui", {
        Name = "Nexus",
        Parent = gethui(),
        ZIndexBehavior = "Sibling"
    })
    
    protectgui(screenGui)
    
    -- Main container
    local main = self:New("Frame", {
        Name = "Main",
        Parent = screenGui,
        Size = window.Size,
        Position = window.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    
    -- Background with blur effect
    local background = self:New("ImageLabel", {
        Name = "Background",
        Parent = main,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992215072",
        ImageTransparency = window.Transparency,
        ScaleType = "Slice",
        SliceCenter = Rect.new(128, 128, 128, 128),
        SliceScale = 0.5
    })
    
    -- Content frame
    local content = self:New("Frame", {
        Name = "Content",
        Parent = main,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1
    })
    
    -- Top bar
    local topBar = self:New("Frame", {
        Name = "TopBar",
        Parent = content,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Title
    local title = self:New("TextLabel", {
        Name = "Title",
        Parent = topBar,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = window.Title,
        TextSize = 18,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close button
    local closeBtn = self:New("TextButton", {
        Name = "Close",
        Parent = topBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        Text = "✕",
        TextSize = 18,
        Font = Enum.Font.SourceSansBold
    })
    
    -- Sidebar
    local sidebar = self:New("Frame", {
        Name = "Sidebar",
        Parent = content,
        Size = UDim2.new(0, 200, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Main area
    local mainArea = self:New("Frame", {
        Name = "MainArea",
        Parent = content,
        Size = UDim2.new(1, -200, 1, -40),
        Position = UDim2.new(0, 200, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Tab container
    local tabContainer = self:New("ScrollingFrame", {
        Name = "TabContainer",
        Parent = sidebar,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    })
    
    local tabList = self:New("UIListLayout", {
        Parent = tabContainer,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Content container
    local contentContainer = self:New("Frame", {
        Name = "ContentContainer",
        Parent = mainArea,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    
    -- Apply theme
    self:UpdateTheme()
    
    -- Window functions
    function window:SetTheme(theme)
        window.Theme = theme
        Nexus.CurrentTheme = theme
        self:UpdateTheme()
    end
    
    function window:SetTransparency(transparency)
        window.Transparency = transparency
        background.ImageTransparency = transparency
    end
    
    function window:SetTitle(title)
        window.Title = title
        title.Text = title
    end
    
    function window:Close()
        screenGui:Destroy()
        Nexus.CurrentWindow = nil
    end
    
    function window:Minimize()
        -- Implementation for minimize
    end
    
    function window:CreateTab(tabConfig)
        local tab = Nexus.Elements:Tab(tabConfig, window, tabContainer, contentContainer)
        table.insert(window.Tabs, tab)
        return tab
    end
    
    -- Drag functionality
    if window.Draggable then
        local drag = Nexus.Creator:New("Frame", {
            Name = "Drag",
            Parent = topBar,
            Size = UDim2.new(1, -70, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 10
        })
        
        local dragging = false
        local dragStart = Vector2.new()
        local startPos = UDim2.new()
        
        drag.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        window:Close()
    end)
    
    -- Store window reference
    window.UIElements = {
        Main = main,
        Background = background,
        Content = content,
        TopBar = topBar,
        Sidebar = sidebar,
        MainArea = mainArea,
        TabContainer = tabContainer,
        ContentContainer = contentContainer
    }
    
    Nexus.CurrentWindow = window
    return window
end

-- Tab Element
function Nexus.Elements:Tab(config, window, tabContainer, contentContainer)
    local tab = {
        __type = "Tab",
        Title = config.Title or "Tab",
        Icon = config.Icon,
        Description = config.Desc,
        Elements = {},
        Sections = {}
    }
    
    -- Tab button
    local tabBtn = Nexus.Creator:New("TextButton", {
        Name = "TabButton",
        Parent = tabContainer,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "",
        LayoutOrder = #window.Tabs
    })
    
    local tabBtnContent = Nexus.Creator:New("Frame", {
        Name = "Content",
        Parent = tabBtn,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1
    })
    
    -- Tab icon
    if tab.Icon then
        local icon = Nexus.Creator:New("ImageLabel", {
            Name = "Icon",
            Parent = tabBtnContent,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            Image = Nexus.Creator:Icon(tab.Icon) or ""
        })
        Nexus.Creator:AddThemeObject(icon, {ImageColor3 = "Text"})
    end
    
    -- Tab title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = tabBtnContent,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = tab.Title,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Tab content
    local tabContent = Nexus.Creator:New("ScrollingFrame", {
        Name = "TabContent",
        Parent = contentContainer,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        BackgroundTransparency = 1,
        Visible = false
    })
    
    local contentList = Nexus.Creator:New("UIListLayout", {
        Parent = tabContent,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Tab functions
    function tab:Show()
        for _, otherTab in ipairs(window.Tabs) do
            otherTab:Hide()
        end
        tabContent.Visible = true
        Nexus.Creator:Tween(tabBtn, 0.2, {BackgroundTransparency = 0.9}):Play()
    end
    
    function tab:Hide()
        tabContent.Visible = false
        Nexus.Creator:Tween(tabBtn, 0.2, {BackgroundTransparency = 1}):Play()
    end
    
    function tab:CreateSection(config)
        local section = Nexus.Elements:Section(config, tab, tabContent)
        table.insert(tab.Sections, section)
        return section
    end
    
    -- Tab interaction
    tabBtn.MouseButton1Click:Connect(function()
        tab:Show()
    end)
    
    -- Store elements
    tab.UIElements = {
        Button = tabBtn,
        Content = tabContent
    }
    
    -- Show first tab by default
    if #window.Tabs == 0 then
        tab:Show()
    end
    
    return tab
end

-- Section Element
function Nexus.Elements:Section(config, tab, parent)
    local section = {
        __type = "Section",
        Title = config.Title or "Section",
        Opened = config.Opened ~= false,
        Elements = {}
    }
    
    -- Section header
    local header = Nexus.Creator:New("Frame", {
        Name = "SectionHeader",
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundTransparency = 1
    })
    
    local headerBtn = Nexus.Creator:New("TextButton", {
        Name = "HeaderButton",
        Parent = header,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    })
    
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = header,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = section.Title,
        TextSize = 16,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    local expandIcon = Nexus.Creator:New("ImageLabel", {
        Name = "ExpandIcon",
        Parent = header,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0, 10),
        Image = Nexus.Creator:Icon("chevron-down") or "",
        Rotation = section.Opened and 0 or -90
    })
    Nexus.Creator:AddThemeObject(expandIcon, {ImageColor3 = "Text"})
    
    -- Section content
    local content = Nexus.Creator:New("Frame", {
        Name = "SectionContent",
        Parent = parent,
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Visible = section.Opened
    })
    
    local contentList = Nexus.Creator:New("UIListLayout", {
        Parent = content,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Section functions
    function section:Toggle()
        section.Opened = not section.Opened
        content.Visible = section.Opened
        Nexus.Creator:Tween(expandIcon, 0.2, {Rotation = section.Opened and 0 or -90}):Play()
    end
    
    function section:CreateElement(elementType, config)
        config.Parent = content
        config.Section = section
        config.Window = tab.Window
        return Nexus.Elements[elementType](config)
    end
    
    -- Section interaction
    headerBtn.MouseButton1Click:Connect(function()
        section:Toggle()
    end)
    
    section.UIElements = {
        Header = header,
        Content = content
    }
    
    return section
end

-- Button Element
function Nexus.Elements:Button(config)
    local button = {
        __type = "Button",
        Title = config.Title or "Button",
        Description = config.Desc,
        Icon = config.Icon,
        Callback = config.Callback or function() end,
        Color = config.Color or "Primary",
        Locked = config.Locked or false
    }
    
    local btn = Nexus.Creator:New("TextButton", {
        Name = "Button",
        Parent = config.Parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = ""
    })
    
    local background = Nexus.Creator:New("Frame", {
        Name = "Background",
        Parent = btn,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.1
    })
    Nexus.Creator:AddThemeObject(background, {BackgroundColor3 = button.Color})
    
    local corner = Nexus.Creator:New("UICorner", {
        Parent = background,
        CornerRadius = UDim.new(0, 8)
    })
    
    local content = Nexus.Creator:New("Frame", {
        Name = "Content",
        Parent = background,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1
    })
    
    -- Icon
    if button.Icon then
        local icon = Nexus.Creator:New("ImageLabel", {
            Name = "Icon",
            Parent = content,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -10),
            Image = Nexus.Creator:Icon(button.Icon) or ""
        })
        Nexus.Creator:AddThemeObject(icon, {ImageColor3 = "Text"})
    end
    
    -- Title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = content,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = button.Title,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Button functions
    function button:SetTitle(title)
        button.Title = title
        title.Text = title
    end
    
    function button:SetIcon(icon)
        button.Icon = icon
        if content:FindFirstChild("Icon") then
            content.Icon.Image = Nexus.Creator:Icon(icon) or ""
        end
    end
    
    function button:SetLocked(locked)
        button.Locked = locked
        background.BackgroundTransparency = locked and 0.5 or 0.1
    end
    
    -- Button interaction
    btn.MouseButton1Click:Connect(function()
        if not button.Locked then
            Nexus.Creator:Tween(background, 0.1, {BackgroundTransparency = 0.3}):Play()
            wait(0.1)
            Nexus.Creator:Tween(background, 0.1, {BackgroundTransparency = 0.1}):Play()
            button.Callback()
        end
    end)
    
    btn.MouseEnter:Connect(function()
        if not button.Locked then
            Nexus.Creator:Tween(background, 0.2, {BackgroundTransparency = 0}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not button.Locked then
            Nexus.Creator:Tween(background, 0.2, {BackgroundTransparency = 0.1}):Play()
        end
    end)
    
    button.UIElements = {
        Button = btn,
        Background = background
    }
    
    return button
end

-- Toggle Element
function Nexus.Elements:Toggle(config)
    local toggle = {
        __type = "Toggle",
        Title = config.Title or "Toggle",
        Description = config.Desc,
        Value = config.Value or false,
        Callback = config.Callback or function() end,
        Locked = config.Locked or false
    }
    
    local container = Nexus.Creator:New("Frame", {
        Name = "Toggle",
        Parent = config.Parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    local toggleBtn = Nexus.Creator:New("TextButton", {
        Name = "ToggleButton",
        Parent = container,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    })
    
    -- Toggle switch
    local switch = Nexus.Creator:New("Frame", {
        Name = "Switch",
        Parent = container,
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -45, 0.5, -10),
        BackgroundTransparency = 0.5
    })
    Nexus.Creator:AddThemeObject(switch, {BackgroundColor3 = "SurfaceVariant"})
    
    local switchCorner = Nexus.Creator:New("UICorner", {
        Parent = switch,
        CornerRadius = UDim.new(1, 0)
    })
    
    local switchThumb = Nexus.Creator:New("Frame", {
        Name = "Thumb",
        Parent = switch,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundTransparency = 0
    })
    Nexus.Creator:AddThemeObject(switchThumb, {BackgroundColor3 = "Text"})
    
    local thumbCorner = Nexus.Creator:New("UICorner", {
        Parent = switchThumb,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = container,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = toggle.Title,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Toggle functions
    function toggle:SetValue(value)
        toggle.Value = value
        Nexus.Creator:Tween(switchThumb, 0.2, {
            Position = UDim2.new(0, value and 22 or 2, 0.5, -8)
        }):Play()
        Nexus.Creator:AddThemeObject(switch, value and {BackgroundColor3 = "Primary"} or {BackgroundColor3 = "SurfaceVariant"})
        toggle.Callback(value)
    end
    
    function toggle:SetLocked(locked)
        toggle.Locked = locked
        container.BackgroundTransparency = locked and 0.5 or 1
    end
    
    -- Toggle interaction
    toggleBtn.MouseButton1Click:Connect(function()
        if not toggle.Locked then
            toggle:SetValue(not toggle.Value)
        end
    end)
    
    -- Set initial value
    toggle:SetValue(toggle.Value)
    
    toggle.UIElements = {
        Container = container,
        Switch = switch
    }
    
    return toggle
end

-- Slider Element
function Nexus.Elements:Slider(config)
    local slider = {
        __type = "Slider",
        Title = config.Title or "Slider",
        Description = config.Desc,
        Value = config.Value or {Min = 0, Max = 100, Default = 50},
        Callback = config.Callback or function() end,
        Locked = config.Locked or false
    }
    
    local container = Nexus.Creator:New("Frame", {
        Name = "Slider",
        Parent = config.Parent,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    -- Title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 10, 0, 0),
        Text = slider.Title,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Value label
    local valueLabel = Nexus.Creator:New("TextLabel", {
        Name = "Value",
        Parent = container,
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 0),
        Text = tostring(slider.Value.Default),
        TextSize = 14,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    Nexus.Creator:AddThemeObject(valueLabel, {TextColor3 = "Primary"})
    
    -- Slider track
    local track = Nexus.Creator:New("Frame", {
        Name = "Track",
        Parent = container,
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 0.5
    })
    Nexus.Creator:AddThemeObject(track, {BackgroundColor3 = "SurfaceVariant"})
    
    local trackCorner = Nexus.Creator:New("UICorner", {
        Parent = track,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Slider fill
    local fill = Nexus.Creator:New("Frame", {
        Name = "Fill",
        Parent = track,
        Size = UDim2.new((slider.Value.Default - slider.Value.Min) / (slider.Value.Max - slider.Value.Min), 0, 1, 0),
        BackgroundTransparency = 0
    })
    Nexus.Creator:AddThemeObject(fill, {BackgroundColor3 = "Primary"})
    
    local fillCorner = Nexus.Creator:New("UICorner", {
        Parent = fill,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Slider thumb
    local thumb = Nexus.Creator:New("Frame", {
        Name = "Thumb",
        Parent = track,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((slider.Value.Default - slider.Value.Min) / (slider.Value.Max - slider.Value.Min), -6, 0.5, -6),
        BackgroundTransparency = 0
    })
    Nexus.Creator:AddThemeObject(thumb, {BackgroundColor3 = "Primary"})
    
    local thumbCorner = Nexus.Creator:New("UICorner", {
        Parent = thumb,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Slider functions
    function slider:SetValue(value)
        value = math.clamp(value, slider.Value.Min, slider.Value.Max)
        local percent = (value - slider.Value.Min) / (slider.Value.Max - slider.Value.Min)
        
        Nexus.Creator:Tween(fill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        Nexus.Creator:Tween(thumb, 0.1, {Position = UDim2.new(percent, -6, 0.5, -6)}):Play()
        
        valueLabel.Text = tostring(math.floor(value + 0.5))
        slider.Callback(value)
    end
    
    function slider:SetLocked(locked)
        slider.Locked = locked
        container.BackgroundTransparency = locked and 0.5 or 1
    end
    
    -- Slider interaction
    local dragging = false
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not slider.Locked then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = slider.Value.Min + percent * (slider.Value.Max - slider.Value.Min)
            slider:SetValue(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    slider.UIElements = {
        Container = container,
        Track = track,
        Fill = fill,
        Thumb = thumb
    }
    
    return slider
end

-- Input Element
function Nexus.Elements:Input(config)
    local input = {
        __type = "Input",
        Title = config.Title or "Input",
        Description = config.Desc,
        Placeholder = config.Placeholder or "Enter text...",
        Value = config.Value or "",
        Callback = config.Callback or function() end,
        Locked = config.Locked or false
    }
    
    local container = Nexus.Creator:New("Frame", {
        Name = "Input",
        Parent = config.Parent,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1
    })
    
    -- Title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 10, 0, 0),
        Text = input.Title,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Input box
    local inputBox = Nexus.Creator:New("TextBox", {
        Name = "InputBox",
        Parent = container,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 25),
        Text = input.Value,
        PlaceholderText = input.Placeholder,
        TextSize = 14,
        ClearTextOnFocus = false
    })
    Nexus.Creator:AddThemeObject(inputBox, {
        BackgroundColor3 = "SurfaceVariant",
        TextColor3 = "Text",
        PlaceholderColor3 = "TextDisabled"
    })
    
    local inputCorner = Nexus.Creator:New("UICorner", {
        Parent = inputBox,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Input functions
    function input:SetValue(value)
        input.Value = value
        inputBox.Text = value
        input.Callback(value)
    end
    
    function input:SetLocked(locked)
        input.Locked = locked
        inputBox.TextEditable = not locked
        inputBox.BackgroundTransparency = locked and 0.7 or 0
    end
    
    -- Input interaction
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            input:SetValue(inputBox.Text)
        end
    end)
    
    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        input.Value = inputBox.Text
    end)
    
    input.UIElements = {
        Container = container,
        InputBox = inputBox
    }
    
    return input
end

-- Dropdown Element
function Nexus.Elements:Dropdown(config)
    local dropdown = {
        __type = "Dropdown",
        Title = config.Title or "Dropdown",
        Description = config.Desc,
        Values = config.Values or {},
        Value = config.Value,
        Callback = config.Callback or function() end,
        Locked = config.Locked or false,
        Opened = false
    }
    
    local container = Nexus.Creator:New("Frame", {
        Name = "Dropdown",
        Parent = config.Parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Main button
    local mainBtn = Nexus.Creator:New("TextButton", {
        Name = "MainButton",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = ""
    })
    
    local mainBg = Nexus.Creator:New("Frame", {
        Name = "Background",
        Parent = mainBtn,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.1
    })
    Nexus.Creator:AddThemeObject(mainBg, {BackgroundColor3 = "SurfaceVariant"})
    
    local mainCorner = Nexus.Creator:New("UICorner", {
        Parent = mainBg,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Selected value
    local selectedValue = Nexus.Creator:New("TextLabel", {
        Name = "SelectedValue",
        Parent = mainBg,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = dropdown.Value or dropdown.Title,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(selectedValue, {TextColor3 = "Text"})
    
    -- Dropdown arrow
    local arrow = Nexus.Creator:New("ImageLabel", {
        Name = "Arrow",
        Parent = mainBg,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        Image = Nexus.Creator:Icon("chevron-down") or ""
    })
    Nexus.Creator:AddThemeObject(arrow, {ImageColor3 = "Text"})
    
    -- Dropdown menu
    local menu = Nexus.Creator:New("Frame", {
        Name = "Menu",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 0.1,
        Visible = false,
        ClipsDescendants = true
    })
    Nexus.Creator:AddThemeObject(menu, {BackgroundColor3 = "Surface"})
    
    local menuCorner = Nexus.Creator:New("UICorner", {
        Parent = menu,
        CornerRadius = UDim.new(0, 6)
    })
    
    local menuList = Nexus.Creator:New("UIListLayout", {
        Parent = menu,
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Create dropdown options
    for _, value in ipairs(dropdown.Values) do
        local option = Nexus.Creator:New("TextButton", {
            Name = "Option",
            Parent = menu,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = ""
        })
        
        local optionText = Nexus.Creator:New("TextLabel", {
            Name = "Text",
            Parent = option,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = typeof(value) == "table" and value.Title or value,
            TextSize = 14,
            Font = Enum.Font.SourceSans,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Nexus.Creator:AddThemeObject(optionText, {TextColor3 = "Text"})
        
        option.MouseButton1Click:Connect(function()
            dropdown:Select(typeof(value) == "table" and value.Title or value)
        end)
        
        option.MouseEnter:Connect(function()
            Nexus.Creator:Tween(option, 0.1, {BackgroundTransparency = 0.9}):Play()
        end)
        
        option.MouseLeave:Connect(function()
            Nexus.Creator:Tween(option, 0.1, {BackgroundTransparency = 1}):Play()
        end)
    end
    
    -- Dropdown functions
    function dropdown:Select(value)
        dropdown.Value = value
        selectedValue.Text = value
        dropdown.Callback(value)
        dropdown:Close()
    end
    
    function dropdown:Open()
        dropdown.Opened = true
        menu.Visible = true
        Nexus.Creator:Tween(menu, 0.2, {Size = UDim2.new(1, 0, 0, math.min(#dropdown.Values * 32, 200))}):Play()
        Nexus.Creator:Tween(arrow, 0.2, {Rotation = 180}):Play()
    end
    
    function dropdown:Close()
        dropdown.Opened = false
        Nexus.Creator:Tween(menu, 0.2, {Size = UDim2.new(1, 0, 0, 0)}):Play()
        wait(0.2)
        menu.Visible = false
        Nexus.Creator:Tween(arrow, 0.2, {Rotation = 0}):Play()
    end
    
    function dropdown:Toggle()
        if dropdown.Opened then
            dropdown:Close()
        else
            dropdown:Open()
        end
    end
    
    function dropdown:SetLocked(locked)
        dropdown.Locked = locked
        mainBtn.BackgroundTransparency = locked and 0.7 or 1
    end
    
    -- Dropdown interaction
    mainBtn.MouseButton1Click:Connect(function()
        if not dropdown.Locked then
            dropdown:Toggle()
        end
    end)
    
    dropdown.UIElements = {
        Container = container,
        MainButton = mainBtn,
        Menu = menu
    }
    
    return dropdown
end

-- Colorpicker Element
function Nexus.Elements:Colorpicker(config)
    local colorpicker = {
        __type = "Colorpicker",
        Title = config.Title or "Colorpicker",
        Description = config.Desc,
        Value = config.Default or Color3.new(1, 1, 1),
        Transparency = config.Transparency or 0,
        Callback = config.Callback or function() end,
        Locked = config.Locked or false
    }
    
    local container = Nexus.Creator:New("Frame", {
        Name = "Colorpicker",
        Parent = config.Parent,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Main button
    local mainBtn = Nexus.Creator:New("TextButton", {
        Name = "MainButton",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = ""
    })
    
    local mainBg = Nexus.Creator:New("Frame", {
        Name = "Background",
        Parent = mainBtn,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.1
    })
    Nexus.Creator:AddThemeObject(mainBg, {BackgroundColor3 = "SurfaceVariant"})
    
    local mainCorner = Nexus.Creator:New("UICorner", {
        Parent = mainBg,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = mainBg,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = colorpicker.Title,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Color preview
    local preview = Nexus.Creator:New("Frame", {
        Name = "Preview",
        Parent = mainBg,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = colorpicker.Value,
        BackgroundTransparency = colorpicker.Transparency
    })
    
    local previewCorner = Nexus.Creator:New("UICorner", {
        Parent = preview,
        CornerRadius = UDim.new(0, 4)
    })
    
    -- Colorpicker dialog
    local dialog = Nexus.Creator:New("Frame", {
        Name = "Dialog",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 0.1,
        Visible = false,
        ClipsDescendants = true
    })
    Nexus.Creator:AddThemeObject(dialog, {BackgroundColor3 = "Surface"})
    
    local dialogCorner = Nexus.Creator:New("UICorner", {
        Parent = dialog,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Color wheel implementation would go here
    -- For brevity, using a simple RGB picker
    
    local rInput = Nexus.Creator:New("TextBox", {
        Name = "RInput",
        Parent = dialog,
        Size = UDim2.new(0.3, -5, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        Text = tostring(math.floor(colorpicker.Value.R * 255)),
        PlaceholderText = "R",
        TextSize = 14
    })
    Nexus.Creator:AddThemeObject(rInput, {
        BackgroundColor3 = "SurfaceVariant",
        TextColor3 = "Text"
    })
    
    local gInput = Nexus.Creator:New("TextBox", {
        Name = "GInput",
        Parent = dialog,
        Size = UDim2.new(0.3, -5, 0, 30),
        Position = UDim2.new(0.35, 0, 0, 10),
        Text = tostring(math.floor(colorpicker.Value.G * 255)),
        PlaceholderText = "G",
        TextSize = 14
    })
    Nexus.Creator:AddThemeObject(gInput, {
        BackgroundColor3 = "SurfaceVariant",
        TextColor3 = "Text"
    })
    
    local bInput = Nexus.Creator:New("TextBox", {
        Name = "BInput",
        Parent = dialog,
        Size = UDim2.new(0.3, -5, 0, 30),
        Position = UDim2.new(0.7, 0, 0, 10),
        Text = tostring(math.floor(colorpicker.Value.B * 255)),
        PlaceholderText = "B",
        TextSize = 14
    })
    Nexus.Creator:AddThemeObject(bInput, {
        BackgroundColor3 = "SurfaceVariant",
        TextColor3 = "Text"
    })
    
    -- Colorpicker functions
    function colorpicker:SetValue(color, transparency)
        colorpicker.Value = color
        colorpicker.Transparency = transparency or 0
        preview.BackgroundColor3 = color
        preview.BackgroundTransparency = colorpicker.Transparency
        
        rInput.Text = tostring(math.floor(color.R * 255))
        gInput.Text = tostring(math.floor(color.G * 255))
        bInput.Text = tostring(math.floor(color.B * 255))
        
        colorpicker.Callback(color, colorpicker.Transparency)
    end
    
    function colorpicker:Open()
        dialog.Visible = true
        Nexus.Creator:Tween(dialog, 0.2, {Size = UDim2.new(1, 0, 0, 100)}):Play()
    end
    
    function colorpicker:Close()
        Nexus.Creator:Tween(dialog, 0.2, {Size = UDim2.new(1, 0, 0, 0)}):Play()
        wait(0.2)
        dialog.Visible = false
    end
    
    function colorpicker:SetLocked(locked)
        colorpicker.Locked = locked
        mainBtn.BackgroundTransparency = locked and 0.7 or 1
    end
    
    -- Colorpicker interaction
    mainBtn.MouseButton1Click:Connect(function()
        if not colorpicker.Locked then
            if dialog.Visible then
                colorpicker:Close()
            else
                colorpicker:Open()
            end
        end
    end)
    
    -- RGB input handling
    local function updateColor()
        local r = tonumber(rInput.Text) or 0
        local g = tonumber(gInput.Text) or 0
        local b = tonumber(bInput.Text) or 0
        colorpicker:SetValue(Color3.fromRGB(r, g, b))
    end
    
    rInput.FocusLost:Connect(updateColor)
    gInput.FocusLost:Connect(updateColor)
    bInput.FocusLost:Connect(updateColor)
    
    colorpicker.UIElements = {
        Container = container,
        Preview = preview,
        Dialog = dialog
    }
    
    return colorpicker
end

-- Notification System
function Nexus:Notify(config)
    local notification = {
        Title = config.Title or "Notification",
        Content = config.Content or "",
        Icon = config.Icon,
        Duration = config.Duration or 3,
        Color = config.Color or "Primary"
    }
    
    local screenGui = Nexus.Creator:New("ScreenGui", {
        Name = "NexusNotifications",
        Parent = gethui(),
        ZIndexBehavior = "Sibling"
    })
    
    protectgui(screenGui)
    
    local container = Nexus.Creator:New("Frame", {
        Name = "Container",
        Parent = screenGui,
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -310, 1, -90),
        BackgroundTransparency = 0.1
    })
    Nexus.Creator:AddThemeObject(container, {BackgroundColor3 = "Surface"})
    
    local corner = Nexus.Creator:New("UICorner", {
        Parent = container,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Icon
    if notification.Icon then
        local icon = Nexus.Creator:New("ImageLabel", {
            Name = "Icon",
            Parent = container,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, 10, 0, 10),
            Image = Nexus.Creator:Icon(notification.Icon) or ""
        })
        Nexus.Creator:AddThemeObject(icon, {ImageColor3 = notification.Color})
    end
    
    -- Title
    local title = Nexus.Creator:New("TextLabel", {
        Name = "Title",
        Parent = container,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, notification.Icon and 40 or 10),
        Text = notification.Title,
        TextSize = 16,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Nexus.Creator:AddThemeObject(title, {TextColor3 = "Text"})
    
    -- Content
    local content = Nexus.Creator:New("TextLabel", {
        Name = "Content",
        Parent = container,
        Size = UDim2.new(1, -20, 1, notification.Icon and -50 or -30),
        Position = UDim2.new(0, 10, 0, notification.Icon and 50 or 30),
        Text = notification.Content,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    Nexus.Creator:AddThemeObject(content, {TextColor3 = "TextSecondary"})
    
    -- Progress bar
    local progressBar = Nexus.Creator:New("Frame", {
        Name = "ProgressBar",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundTransparency = 0
    })
    Nexus.Creator:AddThemeObject(progressBar, {BackgroundColor3 = notification.Color})
    
    -- Animation
    container.Size = UDim2.new(0, 0, 0, 80)
    container.Position = UDim2.new(1, 0, 1, -90)
    
    Nexus.Creator:Tween(container, 0.3, {
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -310, 1, -90)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    
    -- Progress animation
    Nexus.Creator:Tween(progressBar, notification.Duration, {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()
    
    -- Auto remove
    delay(notification.Duration, function()
        Nexus.Creator:Tween(container, 0.3, {
            Size = UDim2.new(0, 0, 0, 80),
            Position = UDim2.new(1, 0, 1, -90)
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        
        wait(0.3)
        screenGui:Destroy()
    end)
    
    return notification
end

-- Configuration Manager
function Nexus:LoadConfig(configName)
    if not isfolder("Nexus") then
        makefolder("Nexus")
    end
    
    local path = "Nexus/" .. (Nexus.CurrentWindow and Nexus.CurrentWindow.Folder or "Default") .. "/"
    if not isfolder(path) then
        makefolder(path)
    end
    
    local filePath = path .. configName .. ".json"
    if isfile(filePath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filePath))
        end)
        if success then
            return data
        end
    end
    return nil
end

function Nexus:SaveConfig(configName, data)
    if not isfolder("Nexus") then
        makefolder("Nexus")
    end
    
    local path = "Nexus/" .. (Nexus.CurrentWindow and Nexus.CurrentWindow.Folder or "Default") .. "/"
    if not isfolder(path) then
        makefolder(path)
    end
    
    local filePath = path .. configName .. ".json"
    local success, json = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    
    if success then
        writefile(filePath, json)
        return true
    end
    return false
end

-- Theme Management
function Nexus:SetTheme(themeName)
    if Nexus.Themes[themeName] then
        Nexus.CurrentTheme = themeName
        Nexus.Creator:UpdateTheme()
        return true
    end
    return false
end

function Nexus:GetCurrentTheme()
    return Nexus.CurrentTheme or "Dark"
end

function Nexus:GetThemes()
    return Nexus.Themes
end

-- Main Creation Function
function Nexus:CreateWindow(config)
    -- Load icons if not already loaded
    if not next(Nexus.Creator.Icons) then
        Nexus.Creator:LoadIcons()
    end
    
    -- Set default theme
    Nexus.CurrentTheme = config.Theme or "Dark"
    
    -- Create window
    local window = Nexus.Elements:Window(config)
    
    -- Store reference
    Nexus.Windows[config.Title or "NexusWindow"] = window
    
    return window
end

-- Initialize Nexus
function Nexus:Init()
    -- Load saved preferences
    local savedTheme = Nexus:LoadConfig("preferences")
    if savedTheme and savedTheme.theme then
        Nexus:SetTheme(savedTheme.theme)
    end
    
    -- Set up cleanup
    game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
        for _, window in pairs(Nexus.Windows) do
            if window.UIElements and window.UIElements.Main then
                window.UIElements.Main:Destroy()
            end
        end
    end)
    
    return Nexus
end

-- Return the library
return Nexus:Init()
