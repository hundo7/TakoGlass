-- TakoGlass UI Library v10.0 - Optimized Version
-- Superior to WindUI with enhanced performance and reduced memory usage

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")

if not RunService:IsClient() then
    error("TakoGlass must run on the client")
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local TakoGlass = {Version = "10.0.0", Windows = {}, Services = {}, Elements = {}}
TakoGlass.__index = TakoGlass

-- Configuration constants
local CONFIG_FOLDER = "TakoGlassData"
local DEFAULT_THEME = "Dark"
local MAX_NOTIFICATIONS = 8
local WINDOW_RADIUS = 14
local ELEMENT_RADIUS = 10
local UI_FONT = Enum.Font.Gotham
local MONO_FONT = Enum.Font.Code

-- Performance optimization constants
local FRAME_BUDGET = 0.008
local BATCH_SIZE = 50

-- Theme definitions (compacted)
TakoGlass.Themes = {
    Dark = {
        Name = "Dark", WindowBg = Color3.fromRGB(20, 20, 30), WindowAlpha = 0.45, 
        CardBg = Color3.fromRGB(30, 30, 45), ElementBg = Color3.fromRGB(40, 40, 60), 
        SidebarBg = Color3.fromRGB(15, 15, 25), Accent = Color3.fromRGB(88, 101, 242), 
        AccentSoft = Color3.fromRGB(108, 121, 262), Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(180, 185, 210), Stroke = Color3.fromRGB(60, 60, 90), 
        Success = Color3.fromRGB(67, 181, 129), Warning = Color3.fromRGB(250, 166, 26), 
        Error = Color3.fromRGB(237, 66, 69), Shadow = Color3.fromRGB(0, 0, 0), 
        Gradient = false, IsDark = true
    },
    Light = {
        Name = "Light", WindowBg = Color3.fromRGB(248, 249, 250), WindowAlpha = 0.25, 
        CardBg = Color3.fromRGB(255, 255, 255), ElementBg = Color3.fromRGB(245, 245, 245), 
        SidebarBg = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(88, 101, 242), 
        AccentSoft = Color3.fromRGB(108, 121, 262), Text = Color3.fromRGB(30, 30, 40), 
        SubText = Color3.fromRGB(100, 105, 130), Stroke = Color3.fromRGB(220, 220, 230), 
        Success = Color3.fromRGB(40, 167, 69), Warning = Color3.fromRGB(255, 193, 7), 
        Error = Color3.fromRGB(220, 53, 69), Shadow = Color3.fromRGB(200, 200, 200), 
        Gradient = false, IsDark = false
    }
}

-- Utility functions (optimized)
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function Ease(obj, props, duration, style, direction)
    if not obj or not obj.Parent then return end
    TweenService:Create(obj, TweenInfo.new(
        duration or 0.2, 
        style or Enum.EasingStyle.Quad, 
        direction or Enum.EasingDirection.Out
    ), props):Play()
end

local function GetPlayerGui()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    while not pg do
        task.wait()
        pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    end
    return pg
end

local function HasFileApi()
    return typeof(isfolder) == "function" and typeof(makefolder) == "function" and 
           typeof(writefile) == "function" and typeof(readfile) == "function" and 
           typeof(isfile) == "function"
end

local function EnsureFolder(folder)
    if not HasFileApi() then return end
    if not isfolder(folder) then
        makefolder(folder)
    end
end

local function SafeJSONEncode(tbl)
    local ok, result = pcall(HttpService.JSONEncode, HttpService, tbl)
    return ok and result or nil
end

local function SafeJSONDecode(str)
    local ok, result = pcall(HttpService.JSONDecode, HttpService, str)
    return ok and result or nil
end

local function SaveConfig(name, data)
    if not HasFileApi() then return end
    EnsureFolder(CONFIG_FOLDER)
    local json = SafeJSONEncode(data)
    if json then
        writefile(("%s/%s.json"):format(CONFIG_FOLDER, name), json)
    end
end

local function LoadConfig(name)
    if not HasFileApi() then return {} end
    EnsureFolder(CONFIG_FOLDER)
    local path = ("%s/%s.json"):format(CONFIG_FOLDER, name)
    if not isfile(path) then return {} end
    
    local ok, content = pcall(readfile, path)
    if not ok or type(content) ~= "string" then return {} end
    
    return SafeJSONDecode(content) or {}
end

local function CalculateTextSize(text, font, size)
    return TextService:GetTextSize(text, size, font, Vector2.new(1000, 1000))
end

-- Icons (compacted)
TakoGlass.Icons = {
    Home = "🏠", Settings = "⚙️", User = "👤", Search = "🔍", Heart = "❤️", 
    Star = "⭐", Bell = "🔔", Mail = "✉️", Calendar = "📅", Clock = "🕐", 
    Camera = "📷", Image = "🖼️", Video = "🎥", Music = "🎵", Mic = "🎤", 
    Phone = "📞", Message = "💬", Chat = "💭", Send = "📤", Download = "⬇️", 
    Upload = "⬆️", Save = "💾", Load = "📂", Folder = "📁", File = "📄", 
    Code = "💻", Terminal = "🖥️", Bug = "🐛", Fire = "🔥", Lightning = "⚡", 
    Rocket = "🚀", Target = "🎯", Trophy = "🏆", Medal = "🥇", Crown = "👑", 
    Diamond = "💎", Gem = "💍", Money = "💰", Card = "💳", Gift = "🎁", 
    Party = "🎉", Balloon = "🎈", Cake = "🍰", Coffee = "☕", Pizza = "🍕", 
    Burger = "🍔", Fries = "🍟", Sushi = "🍣", Salad = "🥗", IceCream = "🍦", 
    Chocolate = "🍫", Candy = "🍬", Lollipop = "🍭", Cookie = "🍪", Beer = "🍺", 
    Wine = "🍷", Cocktail = "🍸", Whiskey = "🥃", Soda = "🥤", Milk = "🥛", 
    Water = "💧", WaterDrop = "💧", Leaf = "🍃", Tree = "🌳", Flower = "🌸", 
    Sun = "☀️", Moon = "🌙", Cloud = "☁️", Rain = "🌧️", Snow = "❄️", Rainbow = "🌈"
}

-- Animations (optimized)
TakoGlass.Animations = {
    Bounce = function(object, scale, duration)
        local originalSize = object.Size
        local sequence = TweenService:Create(object, TweenInfo.new(duration/3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize * scale})
        sequence:Play()
        
        sequence.Completed:Connect(function()
            local returnTween = TweenService:Create(object, TweenInfo.new(duration/3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = originalSize})
            returnTween:Play()
        end)
    end,
    
    FadeIn = function(object, duration)
        object.BackgroundTransparency = 1
        local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),  
            {BackgroundTransparency = 0})
        tween:Play()
        return tween
    end,
    
    SlideIn = function(object, direction, duration)
        local originalPos = object.Position
        local offset = direction == "Left" and -100 or direction == "Right" and 100 or 
                      direction == "Up" and -50 or direction == "Down" and 50
        
        object.Position = originalPos + UDim2.fromOffset(
            (direction == "Left" or direction == "Right") and offset or 0, 
            (direction == "Up" or direction == "Down") and offset or 0
        )
        
        local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out),  
            {Position = originalPos})
        tween:Play()
        return tween
    end
}

-- Notifications system
TakoGlass.Notifications = {
    Active = {}, 
    Queue = {}, 
    
    Show = function(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or options.Message or ""
        local duration = options.Duration or 5
        local icon = options.Icon or "📢"
        local type = options.Type or "Default"
        local actions = options.Actions or {}
        
        if #TakoGlass.Notifications.Active >= MAX_NOTIFICATIONS then
            table.insert(TakoGlass.Notifications.Queue, options)
            return
        end
        
        local pg = GetPlayerGui()
        local container = pg:FindFirstChild("TakoGlass_Notifications") or Create("ScreenGui", {
            Name = "TakoGlass_Notifications", 
            ResetOnSpawn = false, 
            ZIndexBehavior = Enum.ZIndexBehavior.Global
        })
        
        if not container.Parent then
            container.Parent = pg
            Create("Frame", {
                Name = "Container", 
                BackgroundTransparency = 1, 
                Size = UDim2.new(0, 320, 1, -20), 
                AnchorPoint = Vector2.new(1, 0), 
                Position = UDim2.new(1, -10, 0, 10), 
                Parent = container
            })
            
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical, 
                HorizontalAlignment = Enum.HorizontalAlignment.Right, 
                VerticalAlignment = Enum.VerticalAlignment.Top, 
                Padding = UDim.new(0, 8), 
                Parent = container.Container
            })
        end
        
        local theme = TakoGlass.CurrentTheme or TakoGlass.Themes.Dark
        local accentColor = theme.Accent
        
        if type == "Success" then
            accentColor = theme.Success
            icon = icon == "📢" and "✅" or icon
        elseif type == "Warning" then
            accentColor = theme.Warning
            icon = icon == "📢" and "⚠️" or icon
        elseif type == "Error" then
            accentColor = theme.Error
            icon = icon == "📢" and "❌" or icon
        end
        
        local notification = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0), 
            BackgroundColor3 = theme.CardBg, 
            BackgroundTransparency = 1, 
            BorderSizePixel = 0, 
            ZIndex = 200, 
            Position = UDim2.new(1, 50, 0, 0)
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, WINDOW_RADIUS), Parent = notification})
        Create("UIStroke", {
            Color = accentColor, 
            Thickness = 2, 
            Transparency = 0.5, 
            Parent = notification
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 12), 
            PaddingBottom = UDim.new(0, 12), 
            PaddingLeft = UDim.new(0, 12), 
            PaddingRight = UDim.new(0, 12), 
            Parent = notification
        })
        
        Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = icon, 
            Font = UI_FONT, 
            TextSize = 24, 
            TextColor3 = accentColor, 
            Size = UDim2.new(0, 30, 0, 30), 
            Position = UDim2.new(0, 0, 0, 0), 
            ZIndex = 201, 
            Parent = notification
        })
        
        Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = title, 
            Font = UI_FONT, 
            TextSize = 16, 
            TextColor3 = theme.Text, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            Size = UDim2.new(1, -40, 0, 20), 
            Position = UDim2.new(0, 35, 0, 0), 
            ZIndex = 201, 
            Parent = notification
        })
        
        local contentLabel = Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = content, 
            Font = UI_FONT, 
            TextSize = 13, 
            TextColor3 = theme.SubText, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextWrapped = true, 
            Size = UDim2.new(1, -40, 0, 0), 
            Position = UDim2.new(0, 35, 0, 22), 
            ZIndex = 201, 
            Parent = notification
        })
        
        local textHeight = CalculateTextSize(content, UI_FONT, 13, Vector2.new(250, 1000)).Y
        local totalHeight = math.max(50, 35 + textHeight)
        
        notification.Size = UDim2.new(1, 0, 0, totalHeight)
        contentLabel.Size = UDim2.new(1, -40, 0, textHeight)
        
        local closeBtn = Create("TextButton", {
            BackgroundTransparency = 1, 
            Text = "✕", 
            Font = UI_FONT, 
            TextSize = 16, 
            TextColor3 = theme.SubText, 
            Size = UDim2.new(0, 20, 0, 20), 
            Position = UDim2.new(1, -20, 0, 0), 
            ZIndex = 201, 
            Parent = notification
        })
        
        if #actions > 0 then
            local actionsFrame = Create("Frame", {
                BackgroundTransparency = 1, 
                Size = UDim2.new(1, -35, 0, 30), 
                Position = UDim2.new(0, 35, 1, -30), 
                ZIndex = 201, 
                Parent = notification
            })
            
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, 
                Padding = UDim.new(0, 8), 
                Parent = actionsFrame
            })
            
            for _, action in ipairs(actions) do
                local actionBtn = Create("TextButton", {
                    BackgroundColor3 = accentColor, 
                    BackgroundTransparency = 0.8, 
                    Text = action.Text, 
                    Font = UI_FONT, 
                    TextSize = 12, 
                    TextColor3 = theme.Text, 
                    Size = UDim2.new(0, 60, 0, 22), 
                    ZIndex = 202, 
                    Parent = actionsFrame
                })
                Create("UICorner", {CornerRadius = UDim.new(0, ELEMENT_RADIUS), Parent = actionBtn})
                
                actionBtn.MouseButton1Click:Connect(function()
                    if action.Callback then
                        action.Callback()
                    end
                    TakoGlass.Notifications:Remove(notification)
                end)
            end
            
            notification.Size = UDim2.new(1, 0, 0, totalHeight + 35)
        end
        
        notification.Parent = container.Container
        table.insert(TakoGlass.Notifications.Active, notification)
        
        TakoGlass.Animations.SlideIn(notification, "Right", 0.3)
        TakoGlass.Animations.FadeIn(notification, 0.3)
        
        local closeConn
        closeConn = task.delay(duration, function()
            TakoGlass.Notifications:Remove(notification)
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            TakoGlass.Notifications:Remove(notification)
            if closeConn then
                task.cancel(closeConn)
            end
        end)
        
        return notification
    end,
    
    Remove = function(notification)
        if not notification or not notification.Parent then return end
        
        local index = table.find(TakoGlass.Notifications.Active, notification)
        if index then
            table.remove(TakoGlass.Notifications.Active, index)
        end
        
        TakoGlass.Animations.SlideIn(notification, "Right", 0.2)
        Ease(notification, {BackgroundTransparency = 1}, 0.2)
        
        task.delay(0.2, function()
            if notification then
                notification:Destroy()
            end
            
            if #TakoGlass.Notifications.Queue > 0 then
                local nextNotif = table.remove(TakoGlass.Notifications.Queue, 1)
                TakoGlass.Notifications.Show(nextNotif)
            end
        end)
    end
}

-- Window system
function TakoGlass:CreateWindow(options)
    options = options or {}
    
    local window = {
        Title = options.Title or "TakoGlass v10.0", 
        SubTitle = options.SubTitle or "Superior to WindUI", 
        ConfigName = options.ConfigName or options.Title or "TakoGlass", 
        Size = options.Size or UDim2.fromOffset(650, 450), 
        Position = options.Position or UDim2.fromScale(0.5, 0.5), 
        Theme = options.Theme or DEFAULT_THEME, 
        TopbarStyle = options.TopbarStyle or "Mac",
        SidebarWidth = options.SidebarWidth or 180, 
        Transparent = options.Transparent ~= false, 
        Blur = options.Blur ~= false, 
        CanResize = options.CanResize ~= false, 
        CanMinimize = options.CanMinimize ~= false, 
        CanClose = options.CanClose ~= false, 
        ShowTitle = options.ShowTitle ~= false, 
        Animations = options.Animations ~= false,
        
        Tabs = {}, 
        Elements = {}, 
        Connections = {}, 
        IsOpen = true, 
        IsMinimized = false, 
        IsDragging = false, 
        DragOffset = Vector2.new(), 
        CurrentTab = nil, 
        Config = {}, 
        Flags = {}
    }
    
    setmetatable(window, TakoGlass)
    
    window.Config = LoadConfig(window.ConfigName)
    if window.Config.__Theme and TakoGlass.Themes[window.Config.__Theme] then
        window.Theme = window.Config.__Theme
    end
    
    TakoGlass.CurrentTheme = TakoGlass.Themes[window.Theme]
    
    local pg = GetPlayerGui()
    window.Gui = Create("ScreenGui", {
        Name = "TakoGlass_" .. window.Title, 
        ResetOnSpawn = false, 
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    window.Gui.Parent = pg
    
    window.BlurEffect = Create("BlurEffect", {
        Name = "TakoGlass_Blur", 
        Size = 20, 
        Enabled = window.Blur and window.IsOpen, 
        Parent = Lighting
    })
    
    window.MainFrame = Create("Frame", {
        Name = "MainWindow", 
        Size = window.Size, 
        Position = window.Position, 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = TakoGlass.CurrentTheme.WindowBg, 
        BackgroundTransparency = window.Transparent and TakoGlass.CurrentTheme.WindowAlpha or 0, 
        BorderSizePixel = 0, 
        ClipsDescendants = true, 
        ZIndex = 100, 
        Parent = window.Gui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, WINDOW_RADIUS), Parent = window.MainFrame})
    
    local shadow = Create("ImageLabel", {
        Name = "Shadow", 
        Size = UDim2.new(1, 20, 1, 20), 
        Position = UDim2.new(0, -10, 0, -10), 
        BackgroundTransparency = 1, 
        Image = "rbxassetid://13190783835",
        ImageTransparency = 0.7, 
        ZIndex = 99, 
        Parent = window.MainFrame
    })
    
    window:CreateTopbar()
    
    window.ContentFrame = Create("Frame", {
        Name = "Content", 
        Size = UDim2.new(1, 0, 1, -44), 
        Position = UDim2.new(0, 0, 0, 44), 
        BackgroundTransparency = 1, 
        ZIndex = 101, 
        Parent = window.MainFrame
    })
    
    window:CreateSidebar()
    
    if window.CanResize then
        window:CreateResizeHandle()
    end
    
    window:SetupDragging()
    window:SetupKeyboardShortcuts()
    window:ApplyTheme(TakoGlass.CurrentTheme)
    
    if window.Animations then
        window.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        window.MainFrame.BackgroundTransparency = 1
        Ease(window.MainFrame, {Size = window.Size, BackgroundTransparency = window.Transparent and TakoGlass.CurrentTheme.WindowAlpha or 0}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end
    
    table.insert(TakoGlass.Windows, window)
    return window
end

function TakoGlass:CreateTopbar()
    local theme = TakoGlass.CurrentTheme
    
    self.Topbar = Create("Frame", {
        Name = "Topbar", 
        Size = UDim2.new(1, 0, 0, 44), 
        BackgroundTransparency = 1, 
        ZIndex = 102, 
        Parent = self.MainFrame
    })
    
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 16), 
        PaddingRight = UDim.new(0, 12), 
        Parent = self.Topbar
    })
    
    if self.TopbarStyle == "Mac" then
        local controls = Create("Frame", {
            Size = UDim2.new(0, 60, 0, 14), 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 8, 0, 15), 
            Parent = self.Topbar
        })
        
        local closeBtn = Create("TextButton", {
            BackgroundColor3 = Color3.fromRGB(255, 95, 87), 
            Size = UDim2.new(0, 12, 0, 12), 
            Position = UDim2.new(0, 0, 0, 1), 
            Text = "", 
            ZIndex = 103, 
            Parent = controls
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = closeBtn})
        
        local minimizeBtn = Create("TextButton", {
            BackgroundColor3 = Color3.fromRGB(255, 189, 46), 
            Size = UDim2.new(0, 12, 0, 12), 
            Position = UDim2.new(0, 20, 0, 1), 
            Text = "", 
            ZIndex = 103, 
            Parent = controls
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = minimizeBtn})
        
        local maximizeBtn = Create("TextButton", {
            BackgroundColor3 = Color3.fromRGB(40, 201, 64), 
            Size = UDim2.new(0, 12, 0, 12), 
            Position = UDim2.new(0, 40, 0, 1), 
            Text = "", 
            ZIndex = 103, 
            Parent = controls
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = maximizeBtn})
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Close()
        end)
        
        minimizeBtn.MouseButton1Click:Connect(function()
            self:Minimize()
        end)
        
        maximizeBtn.MouseButton1Click:Connect(function()
            self:Maximize()
        end)
        
    else
        local controls = Create("Frame", {
            Size = UDim2.new(0, 120, 0, 30), 
            BackgroundTransparency = 1, 
            Position = UDim2.new(1, -120, 0, 7), 
            Parent = self.Topbar
        })
        
        local minimizeBtn = Create("TextButton", {
            BackgroundTransparency = 1, 
            Text = "—", 
            Font = UI_FONT, 
            TextSize = 18, 
            TextColor3 = theme.Text, 
            Size = UDim2.new(0, 40, 1, 0), 
            Position = UDim2.new(0, 0, 0, 0), 
            ZIndex = 103, 
            Parent = controls
        })
        
        local maximizeBtn = Create("TextButton", {
            BackgroundTransparency = 1, 
            Text = "□", 
            Font = UI_FONT, 
            TextSize = 16, 
            TextColor3 = theme.Text, 
            Size = UDim2.new(0, 40, 1, 0), 
            Position = UDim2.new(0, 40, 0, 0), 
            ZIndex = 103, 
            Parent = controls
        })
        
        local closeBtn = Create("TextButton", {
            BackgroundTransparency = 1, 
            Text = "✕", 
            Font = UI_FONT, 
            TextSize = 16, 
            TextColor3 = theme.Text, 
            Size = UDim2.new(0, 40, 1, 0), 
            Position = UDim2.new(0, 80, 0, 0), 
            ZIndex = 103, 
            Parent = controls
        })
        
        local function addHover(btn, hoverColor)
            btn.MouseEnter:Connect(function()
                Ease(btn, {TextColor3 = theme.Accent}, 0.2)
                btn.BackgroundTransparency = 0.9
            end)
            
            btn.MouseLeave:Connect(function()
                Ease(btn, {TextColor3 = theme.Text}, 0.2)
                btn.BackgroundTransparency = 1
            end)
        end
        
        addHover(minimizeBtn)
        addHover(maximizeBtn)
        addHover(closeBtn, theme.Error)
        
        minimizeBtn.MouseButton1Click:Connect(function()
            self:Minimize()
        end)
        
        maximizeBtn.MouseButton1Click:Connect(function()
            self:Maximize()
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Close()
        end)
    end
    
    if self.ShowTitle then
        local titleContainer = Create("Frame", {
            Size = UDim2.new(1, -150, 1, 0), 
            Position = self.TopbarStyle == "Mac" and UDim2.new(0, 80, 0, 0) or UDim2.new(0, 10, 0, 0), 
            BackgroundTransparency = 1, 
            Parent = self.Topbar
        })
        
        if self.ShowIcon then
            local icon = Create("TextLabel", {
                BackgroundTransparency = 1, 
                Text = "🎨", 
                Font = UI_FONT, 
                TextSize = 20, 
                TextColor3 = theme.Text, 
                Size = UDim2.new(0, 24, 0, 24), 
                Position = UDim2.new(0, 0, 0.5, -12), 
                ZIndex = 103, 
                Parent = titleContainer
            })
            
            self.TitleLabel = Create("TextLabel", {
                BackgroundTransparency = 1, 
                Text = self.Title, 
                Font = UI_FONT, 
                TextSize = 16, 
                TextColor3 = theme.Text, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                Size = UDim2.new(1, -30, 0, 20), 
                Position = UDim2.new(0, 30, 0, 2), 
                ZIndex = 103, 
                Parent = titleContainer
            })
            
            self.SubTitleLabel = Create("TextLabel", {
                BackgroundTransparency = 1, 
                Text = self.SubTitle, 
                Font = UI_FONT, 
                TextSize = 12, 
                TextColor3 = theme.SubText, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                Size = UDim2.new(1, -30, 0, 16), 
                Position = UDim2.new(0, 30, 1, -18), 
                ZIndex = 103, 
                Parent = titleContainer
            })
        else
            self.TitleLabel = Create("TextLabel", {
                BackgroundTransparency = 1, 
                Text = self.Title, 
                Font = UI_FONT, 
                TextSize = 16, 
                TextColor3 = theme.Text, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                Size = UDim2.new(1, 0, 0, 20), 
                Position = UDim2.new(0, 0, 0, 2), 
                ZIndex = 103, 
                Parent = titleContainer
            })
            
            self.SubTitleLabel = Create("TextLabel", {
                BackgroundTransparency = 1, 
                Text = self.SubTitle, 
                Font = UI_FONT, 
                TextSize = 12, 
                TextColor3 = theme.SubText, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                Size = UDim2.new(1, 0, 0, 16), 
                Position = UDim2.new(0, 0, 1, -18), 
                ZIndex = 103, 
                Parent = titleContainer
            })
        end
    end
end

function TakoGlass:CreateSidebar()
    local theme = TakoGlass.CurrentTheme
    
    self.Sidebar = Create("Frame", {
        Name = "Sidebar", 
        Size = UDim2.new(0, self.SidebarWidth, 1, 0), 
        Position = UDim2.new(0, 0, 0, 0), 
        BackgroundColor3 = theme.SidebarBg, 
        BackgroundTransparency = self.Transparent and 0.2 or 0, 
        BorderSizePixel = 0, 
        ZIndex = 101, 
        Parent = self.ContentFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, WINDOW_RADIUS), Parent = self.Sidebar})
    
    self.SidebarContent = Create("ScrollingFrame", {
        Name = "Content", 
        Size = UDim2.new(1, 0, 1, 0), 
        CanvasSize = UDim2.new(0, 0, 0, 0), 
        ScrollBarThickness = 4, 
        ScrollBarImageColor3 = theme.Accent, 
        BackgroundTransparency = 1, 
        BorderSizePixel = 0, 
        ZIndex = 102, 
        Parent = self.Sidebar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, 
        Padding = UDim.new(0, 4), 
        Parent = self.SidebarContent
    })
    
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10), 
        PaddingBottom = UDim.new(0, 10), 
        PaddingLeft = UDim.new(0, 8), 
        PaddingRight = UDim.new(0, 8), 
        Parent = self.SidebarContent
    })
    
    local resizeHandle = Create("Frame", {
        Name = "ResizeHandle", 
        Size = UDim2.new(0, 4, 1, 0), 
        Position = UDim2.new(1, -2, 0, 0), 
        BackgroundTransparency = 1, 
        ZIndex = 103, 
        Parent = self.Sidebar
    })
    
    local isResizing = false
    local startWidth = self.SidebarWidth
    local startX = 0
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = true
            startWidth = self.SidebarWidth
            startX = input.Position.X
            input:Capture()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position.X - startX
            local newWidth = math.clamp(startWidth + delta, 120, 300)
            
            self.SidebarWidth = newWidth
            self.Sidebar.Size = UDim2.new(0, newWidth, 1, 0)
            self.ContentArea.Position = UDim2.new(0, newWidth, 0, 0)
            self.ContentArea.Size = UDim2.new(1, -newWidth, 1, 0)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = false
            input:Release()
            
            self.Config.__SidebarWidth = self.SidebarWidth
            SaveConfig(self.ConfigName, self.Config)
        end
    end)
end

function TakoGlass:CreateResizeHandle()
    local resizeHandle = Create("Frame", {
        Name = "ResizeHandle", 
        Size = UDim2.new(0, 12, 0, 12), 
        Position = UDim2.new(1, -12, 1, -12), 
        BackgroundTransparency = 1, 
        ZIndex = 200, 
        Parent = self.MainFrame
    })
    
    local resizeIcon = Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, 
        Image = "rbxassetid://13190785000",
        ImageColor3 = TakoGlass.CurrentTheme.SubText, 
        ImageTransparency = 0.5, 
        Parent = resizeHandle
    })
    
    local isResizing = false
    local startSize = self.Size
    local startPos = Vector2.new()
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = true
            startSize = self.Size
            startPos = input.Position
            input:Capture()
            GuiService:SetCursor("ResizeNWSE")
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            local newSize = UDim2.fromOffset(
                math.clamp(startSize.X.Offset + delta.X, 400, 1200), 
                math.clamp(startSize.Y.Offset + delta.Y, 300, 800)
            )
            
            self.Size = newSize
            self.MainFrame.Size = newSize
            
            if self.ContentArea then
                self.ContentArea.Size = UDim2.new(1, -self.SidebarWidth, 1, 0)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = false
            input:Release()
            GuiService:SetCursor("Default")
            
            self.Config.__Size = {self.Size.X.Offset, self.Size.Y.Offset}
            SaveConfig(self.ConfigName, self.Config)
        end
    end)
end

function TakoGlass:SetupDragging()
    local topbar = self.Topbar
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = true
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = self.MainFrame.AbsolutePosition
            self.DragOffset = mousePos - framePos
            
            input:Capture()
            GuiService:SetCursor("Drag")
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position
            local newPos = mousePos - self.DragOffset
            
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local frameSize = self.MainFrame.AbsoluteSize
            
            newPos = Vector2.new(
                math.clamp(newPos.X, 0, viewportSize.X - frameSize.X), 
                math.clamp(newPos.Y, 0, viewportSize.Y - frameSize.Y)
            )
            
            self.MainFrame.Position = UDim2.fromOffset(newPos.X, newPos.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if self.IsDragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = false
            input:Release()
            GuiService:SetCursor("Default")
            
            local pos = self.MainFrame.AbsolutePosition
            self.Config.__Position = {pos.X, pos.Y}
            SaveConfig(self.ConfigName, self.Config)
        end
    end)
end

function TakoGlass:SetupKeyboardShortcuts()
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.RightShift then
            self:SetVisible(not self.IsOpen)
        elseif input.KeyCode == Enum.KeyCode.Escape and self.IsOpen then
            self:Close()
        end
    end))
end

-- Window methods
function TakoGlass:SetVisible(visible)
    self.IsOpen = visible
    self.Gui.Enabled = visible
    if self.BlurEffect then
        self.BlurEffect.Enabled = visible and self.Blur
    end
    
    if self.Animations then
        if visible then
            self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
            self.MainFrame.BackgroundTransparency = 1
            Ease(self.MainFrame, {Size = self.Size, BackgroundTransparency = self.Transparent and TakoGlass.CurrentTheme.WindowAlpha or 0}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Ease(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        end
    end
end

function TakoGlass:Minimize()
    self.IsMinimized = true
    local targetHeight = self.ShowTitle and 44 or 30
    
    if self.Animations then
        Ease(self.ContentFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        Ease(self.MainFrame, {Size = UDim2.new(self.Size.X, UDim2.new(0, targetHeight))}, 0.3)
    else
        self.ContentFrame.Size = UDim2.new(1, 0, 0, 0)
        self.MainFrame.Size = UDim2.new(self.Size.X, UDim2.new(0, targetHeight))
    end
end

function TakoGlass:Maximize()
    self.IsMinimized = false
    
    if self.Animations then
        Ease(self.ContentFrame, {Size = UDim2.new(1, 0, 1, -44)}, 0.3)
        Ease(self.MainFrame, {Size = self.Size}, 0.3)
    else
        self.ContentFrame.Size = UDim2.new(1, 0, 1, -44)
        self.MainFrame.Size = self.Size
    end
end

function TakoGlass:Close()
    if self.Animations then
        Ease(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.3, function()
            self:Destroy()
        end)
    else
        self:Destroy()
    end
end

function TakoGlass:Destroy()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    
    if self.BlurEffect then
        self.BlurEffect:Destroy()
    end
    
    if self.Gui then
        self.Gui:Destroy()
    end
    
    local index = table.find(TakoGlass.Windows, self)
    if index then
        table.remove(TakoGlass.Windows, index)
    end
end

function TakoGlass:SetTheme(themeName)
    if not TakoGlass.Themes[themeName] then return end
    
    self.Theme = themeName
    TakoGlass.CurrentTheme = TakoGlass.Themes[themeName]
    
    self:ApplyTheme(TakoGlass.CurrentTheme)
    
    self.Config.__Theme = themeName
    SaveConfig(self.ConfigName, self.Config)
    
    TakoGlass.Notifications.Show({
        Title = "Theme Changed", 
        Content = "Switched to " .. themeName .. " theme", 
        Duration = 2, 
        Type = "Success", 
        Icon = "🎨"
    })
end

function TakoGlass:ApplyTheme(theme)
    self.MainFrame.BackgroundColor3 = theme.WindowBg
    self.MainFrame.BackgroundTransparency = self.Transparent and theme.WindowAlpha or 0
    
    if self.Sidebar then
        self.Sidebar.BackgroundColor3 = theme.SidebarBg
        self.Sidebar.BackgroundTransparency = self.Transparent and 0.2 or 0
    end
    
    if self.TitleLabel then
        self.TitleLabel.TextColor3 = theme.Text
    end
    
    if self.SubTitleLabel then
        self.SubTitleLabel.TextColor3 = theme.SubText
    end
    
    for _, tab in ipairs(self.Tabs) do
        if tab.ApplyTheme then
            tab:ApplyTheme(theme)
        end
    end
    
    for _, element in ipairs(self.Elements) do
        if element.ApplyTheme then
            element:ApplyTheme(theme)
        end
    end
end

function TakoGlass:CreateTab(options)
    options = options or {}
    
    local tab = {
        Window = self, 
        Name = options.Name or "Tab", 
        Icon = options.Icon or "📄", 
        Description = options.Description or "", 
        Content = {}, 
        Sections = {}, 
        Elements = {}, 
        IsActive = false, 
        Order = options.Order or #self.Tabs + 1
    }
    
    tab.Button = Create("TextButton", {
        Name = tab.Name:gsub(" ", ""), 
        BackgroundTransparency = 1, 
        Size = UDim2.new(1, 0, 0, 50), 
        Text = "", 
        ZIndex = 104, 
        Parent = self.SidebarContent
    })
    
    tab.Highlight = Create("Frame", {
        BackgroundColor3 = TakoGlass.CurrentTheme.Accent, 
        BackgroundTransparency = 1, 
        Size = UDim2.new(0, 4, 1, -8), 
        Position = UDim2.new(0, -2, 0, 4), 
        ZIndex = 105, 
        Parent = tab.Button
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = tab.Highlight})
    
    tab.IconLabel = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = tab.Icon, 
        Font = UI_FONT, 
        TextSize = 20, 
        TextColor3 = TakoGlass.CurrentTheme.Text, 
        Size = UDim2.new(0, 24, 0, 24), 
        Position = UDim2.new(0, 12, 0, 13), 
        ZIndex = 105, 
        Parent = tab.Button
    })
    
    tab.NameLabel = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = tab.Name, 
        Font = UI_FONT, 
        TextSize = 14, 
        TextColor3 = TakoGlass.CurrentTheme.Text, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Size = UDim2.new(1, -40, 0, 20), 
        Position = UDim2.new(0, 40, 0, 8), 
        ZIndex = 105, 
        Parent = tab.Button
    })
    
    if tab.Description ~= "" then
        tab.DescriptionLabel = Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = tab.Description, 
            Font = UI_FONT, 
            TextSize = 11, 
            TextColor3 = TakoGlass.CurrentTheme.SubText, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            Size = UDim2.new(1, -40, 0, 14), 
            Position = UDim2.new(0, 40, 1, -18), 
            ZIndex = 105, 
            Parent = tab.Button
        })
    end
    
    tab.ContentFrame = Create("ScrollingFrame", {
        Name = tab.Name .. "_Content", 
        Size = UDim2.new(1, 0, 1, 0), 
        Position = UDim2.new(0, 0, 0, 0), 
        CanvasSize = UDim2.new(0, 0, 0, 0), 
        ScrollBarThickness = 5, 
        ScrollBarImageColor3 = TakoGlass.CurrentTheme.Accent, 
        BackgroundTransparency = 1, 
        BorderSizePixel = 0, 
        ZIndex = 103, 
        Visible = false, 
        Parent = self.ContentArea or self.ContentFrame
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, 
        Padding = UDim.new(0, 12), 
        Parent = tab.ContentFrame
    })
    
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 15), 
        PaddingBottom = UDim.new(0, 15), 
        PaddingLeft = UDim.new(0, 15), 
        PaddingRight = UDim.new(0, 15), 
        Parent = tab.ContentFrame
    })
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SetActiveTab(tab)
    end)
    
    tab.Button.MouseEnter:Connect(function()
        if not tab.IsActive then
            Ease(tab.Button, {BackgroundTransparency = 0.9, BackgroundColor3 = TakoGlass.CurrentTheme.ElementBg}, 0.2)
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if not tab.IsActive then
            Ease(tab.Button, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    function tab:SetActive(active)
        self.IsActive = active
        self.ContentFrame.Visible = active
        
        if active then
            Ease(self.Highlight, {BackgroundTransparency = 0}, 0.2)
            Ease(self.IconLabel, {TextColor3 = TakoGlass.CurrentTheme.Accent}, 0.2)
            Ease(self.NameLabel, {TextColor3 = TakoGlass.CurrentTheme.Accent}, 0.2)
            
            if self.DescriptionLabel then
                Ease(self.DescriptionLabel, {TextColor3 = TakoGlass.CurrentTheme.Accent}, 0.2)
            end
        else
            Ease(self.Highlight, {BackgroundTransparency = 1}, 0.2)
            Ease(self.IconLabel, {TextColor3 = TakoGlass.CurrentTheme.Text}, 0.2)
            Ease(self.NameLabel, {TextColor3 = TakoGlass.CurrentTheme.Text}, 0.2)
            
            if self.DescriptionLabel then
                Ease(self.DescriptionLabel, {TextColor3 = TakoGlass.CurrentTheme.SubText}, 0.2)
            end
        end
    end
    
    function tab:ApplyTheme(theme)
        if self.IsActive then
            self.Highlight.BackgroundColor3 = theme.Accent
            self.IconLabel.TextColor3 = theme.Accent
            self.NameLabel.TextColor3 = theme.Accent
            if self.DescriptionLabel then
                self.DescriptionLabel.TextColor3 = theme.Accent
            end
        else
            self.IconLabel.TextColor3 = theme.Text
            self.NameLabel.TextColor3 = theme.Text
            if self.DescriptionLabel then
                self.DescriptionLabel.TextColor3 = theme.SubText
            end
        end
        
        for _, section in ipairs(self.Sections) do
            if section.ApplyTheme then
                section:ApplyTheme(theme)
            end
        end
    end
    
    function tab:CreateSection(options)
        return TakoGlass.CreateSection(self, options)
    end
    
    if #self.Tabs == 0 then
        tab:SetActive(true)
        self.CurrentTab = tab
    end
    
    table.insert(self.Tabs, tab)
    return tab
end

function TakoGlass:SetActiveTab(tab)
    if self.CurrentTab == tab then return end
    
    if self.CurrentTab then
        self.CurrentTab:SetActive(false)
    end
    
    tab:SetActive(true)
    self.CurrentTab = tab
    
    tab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, tab.ContentFrame.UIListLayout.AbsoluteContentSize.Y + 30)
end

-- Section system
function TakoGlass.CreateSection(tab, options)
    options = options or {}
    
    local section = {
        Tab = tab, 
        Window = tab.Window, 
        Name = options.Name or "Section", 
        Description = options.Description or "", 
        IsCollapsed = options.Collapsed or false, 
        CanCollapse = options.CanCollapse ~= false, 
        Elements = {}, 
        Order = options.Order or #tab.Sections + 1
    }
    
    local theme = TakoGlass.CurrentTheme
    
    section.Frame = Create("Frame", {
        Name = section.Name:gsub(" ", ""), 
        Size = UDim2.new(1, 0, 0, 60), 
        BackgroundColor3 = theme.CardBg, 
        BackgroundTransparency = tab.Window.Transparent and 0.25 or 0.05, 
        BorderSizePixel = 0, 
        ZIndex = 104, 
        Parent = tab.ContentFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, ELEMENT_RADIUS), Parent = section.Frame})
    Create("UIStroke", {
        Color = theme.Stroke, 
        Thickness = 1, 
        Transparency = 0.4, 
        Parent = section.Frame
    })
    
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 12), 
        PaddingBottom = UDim.new(0, 12), 
        PaddingLeft = UDim.new(0, 15), 
        PaddingRight = UDim.new(0, 15), 
        Parent = section.Frame
    })
    
    section.Header = Create("TextButton", {
        Name = "Header", 
        BackgroundTransparency = 1, 
        Size = UDim2.new(1, 0, 0, 36), 
        Text = "", 
        ZIndex = 105, 
        Parent = section.Frame
    })
    
    section.Icon = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = options.Icon or "📁", 
        Font = UI_FONT, 
        TextSize = 18, 
        TextColor3 = theme.Text, 
        Size = UDim2.new(0, 24, 0, 24), 
        Position = UDim2.new(0, 0, 0, 6), 
        ZIndex = 106, 
        Parent = section.Header
    })
    
    section.Title = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = section.Name, 
        Font = UI_FONT, 
        TextSize = 16, 
        TextColor3 = theme.Text, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Size = UDim2.new(1, -60, 0, 20), 
        Position = UDim2.new(0, 30, 0, 2), 
        ZIndex = 106, 
        Parent = section.Header
    })
    
    if section.Description ~= "" then
        section.DescriptionLabel = Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = section.Description, 
            Font = UI_FONT, 
            TextSize = 12, 
            TextColor3 = theme.SubText, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            Size = UDim2.new(1, -60, 0, 14), 
            Position = UDim2.new(0, 30, 1, -14), 
            ZIndex = 106, 
            Parent = section.Header
        })
    end
    
    if section.CanCollapse then
        section.CollapseButton = Create("TextButton", {
            BackgroundTransparency = 1, 
            Text = section.IsCollapsed and "▶" or "▼", 
            Font = UI_FONT, 
            TextSize = 14, 
            TextColor3 = theme.SubText, 
            Size = UDim2.new(0, 24, 0, 24), 
            Position = UDim2.new(1, -24, 0, 6), 
            ZIndex = 106, 
            Parent = section.Header
        })
        
        section.CollapseButton.MouseButton1Click:Connect(function()
            section:SetCollapsed(not section.IsCollapsed)
        end)
    end
    
    section.Content = Create("Frame", {
        Name = "Content", 
        Size = UDim2.new(1, 0, 1, -48), 
        Position = UDim2.new(0, 0, 0, 48), 
        BackgroundTransparency = 1, 
        ZIndex = 105, 
        Parent = section.Frame
    })
    
    section.ListLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical, 
        Padding = UDim.new(0, 8), 
        Parent = section.Content
    })
    
    section.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentHeight = section.ListLayout.AbsoluteContentSize.Y
        local headerHeight = 48
        local padding = 24
        local totalHeight = headerHeight + (section.IsCollapsed and 0 or contentHeight + padding)
        
        Ease(section.Frame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        tab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, tab.ContentFrame.UIListLayout.AbsoluteContentSize.Y + 30)
    end)
    
    function section:SetCollapsed(collapsed)
        self.IsCollapsed = collapsed
        
        if self.CollapseButton then
            self.CollapseButton.Text = collapsed and "▶" or "▼"
        end
        
        Ease(self.Content, {BackgroundTransparency = collapsed and 1 or 0}, 0.3)
        
        local contentHeight = self.ListLayout.AbsoluteContentSize.Y
        local headerHeight = 48
        local padding = 24
        local totalHeight = headerHeight + (collapsed and 0 or contentHeight + padding)
        
        Ease(self.Frame, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end
    
    function section:ApplyTheme(theme)
        self.Frame.BackgroundColor3 = theme.CardBg
        self.Frame.UIStroke.Color = theme.Stroke
        self.Icon.TextColor3 = theme.Text
        self.Title.TextColor3 = theme.Text
        
        if self.DescriptionLabel then
            self.DescriptionLabel.TextColor3 = theme.SubText
        end
        
        if self.CollapseButton then
            self.CollapseButton.TextColor3 = theme.SubText
        end
        
        for _, element in ipairs(self.Elements) do
            if element.ApplyTheme then
                element:ApplyTheme(theme)
            end
        end
    end
    
    if section.IsCollapsed then
        section.Content.BackgroundTransparency = 1
    end
    
    function section:AddToggle(options)
        return TakoGlass.Elements.CreateToggle(section, options)
    end
    
    function section:AddSlider(options)
        return TakoGlass.Elements.CreateSlider(section, options)
    end
    
    function section:AddButton(options)
        return TakoGlass.Elements.CreateButton(section, options)
    end
    
    function section:AddInput(options)
        return TakoGlass.Elements.CreateInput(section, options)
    end
    
    function section:AddDropdown(options)
        return TakoGlass.Elements.CreateDropdown(section, options)
    end
    
    function section:AddColorPicker(options)
        return TakoGlass.Elements.CreateColorPicker(section, options)
    end
    
    function section:AddKeybind(options)
        return TakoGlass.Elements.CreateKeybind(section, options)
    end
    
    function section:AddParagraph(options)
        return TakoGlass.Elements.CreateParagraph(section, options)
    end
    
    function section:AddImage(options)
        return TakoGlass.Elements.CreateImage(section, options)
    end
    
    function section:AddCodeBlock(options)
        return TakoGlass.Elements.CreateCodeBlock(section, options)
    end
    
    table.insert(tab.Sections, section)
    table.insert(self.Sections, section)
    return section
end

-- Element system
TakoGlass.Elements = {}

-- Toggle element
function TakoGlass.Elements.CreateToggle(section, options)
    options = options or {}
    
    local toggle = {
        Section = section, 
        Window = section.Window, 
        Name = options.Name or "Toggle", 
        Description = options.Description or "", 
        Default = options.Default or false, 
        Flag = options.Flag or ("TG_Toggle_" .. (options.Name or "Toggle")), 
        Callback = options.Callback or function() end, 
        Locked = options.Locked or false, 
        Value = options.Default or false, 
        Type = "Toggle"
    }
    
    local theme = TakoGlass.CurrentTheme
    
    if section.Window.Config[toggle.Flag] ~= nil then
        toggle.Value = section.Window.Config[toggle.Flag]
    end
    
    section.Window.Flags[toggle.Flag] = toggle.Value
    
    toggle.Frame = Create("Frame", {
        Name = "Toggle_" .. toggle.Name, 
        Size = UDim2.new(1, 0, 0, toggle.Description ~= "" and 50 or 36), 
        BackgroundTransparency = 1, 
        ZIndex = 106, 
        Parent = section.Content
    })
    
    toggle.Label = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = toggle.Name, 
        Font = UI_FONT, 
        TextSize = 14, 
        TextColor3 = theme.Text, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Size = UDim2.new(1, -50, 0, 20), 
        Position = UDim2.new(0, 0, 0, 0), 
        ZIndex = 107, 
        Parent = toggle.Frame
    })
    
    if toggle.Description ~= "" then
        toggle.DescriptionLabel = Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = toggle.Description, 
            Font = UI_FONT, 
            TextSize = 11, 
            TextColor3 = theme.SubText, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            Size = UDim2.new(1, -50, 0, 14), 
            Position = UDim2.new(0, 0, 0, 22), 
            ZIndex = 107, 
            Parent = toggle.Frame
        })
    end
    
    toggle.Switch = Create("TextButton", {
        BackgroundTransparency = 1, 
        Size = UDim2.new(0, 40, 0, 22), 
        Position = UDim2.new(1, -40, 0, toggle.Description ~= "" and 14 or 7), 
        Text = "", 
        ZIndex = 107, 
        Parent = toggle.Frame
    })
    
    toggle.SwitchBackground = Create("Frame", {
        BackgroundColor3 = toggle.Value and theme.Accent or theme.ElementBg, 
        Size = UDim2.new(1, 0, 0, 16), 
        Position = UDim2.new(0, 0, 0.5, -8), 
        BorderSizePixel = 0, 
        ZIndex = 108, 
        Parent = toggle.Switch
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggle.SwitchBackground})
    
    toggle.SwitchHandle = Create("Frame", {
        BackgroundColor3 = theme.Text, 
        Size = UDim2.new(0, 12, 0, 12), 
        Position = toggle.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), 
        BorderSizePixel = 0, 
        ZIndex = 109, 
        Parent = toggle.SwitchBackground
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggle.SwitchHandle})
    
    function toggle:SetValue(value)
        if toggle.Locked then return end
        
        toggle.Value = value
        section.Window.Flags[toggle.Flag] = value
        section.Window.Config[toggle.Flag] = value
        SaveConfig(section.Window.ConfigName, section.Window.Config)
        
        Ease(toggle.SwitchBackground, {BackgroundColor3 = value and theme.Accent or theme.ElementBg}, 0.2)
        Ease(toggle.SwitchHandle, {
            Position = value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), 
            BackgroundColor3 = value and theme.Text or theme.SubText
        }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        toggle.Callback(value)
    end
    
    toggle.Switch.MouseButton1Click:Connect(function()
        toggle:SetValue(not toggle.Value)
    end)
    
    function toggle:ApplyTheme(newTheme)
        toggle.Label.TextColor3 = newTheme.Text
        if toggle.DescriptionLabel then
            toggle.DescriptionLabel.TextColor3 = newTheme.SubText
        end
        
        toggle.SwitchBackground.BackgroundColor3 = toggle.Value and newTheme.Accent or newTheme.ElementBg
        toggle.SwitchHandle.BackgroundColor3 = toggle.Value and newTheme.Text or newTheme.SubText
    end
    
    table.insert(section.Elements, toggle)
    table.insert(section.Window.Elements, toggle)
    
    return {
        SetValue = function(value) toggle:SetValue(value) end, 
        GetValue = function() return toggle.Value end, 
        SetLocked = function(locked) toggle.Locked = locked end, 
        Destroy = function() toggle.Frame:Destroy() end
    }
end

-- Slider element
function TakoGlass.Elements.CreateSlider(section, options)
    options = options or {}
    
    local slider = {
        Section = section, 
        Window = section.Window, 
        Name = options.Name or "Slider", 
        Min = options.Min or 0, 
        Max = options.Max or 100, 
        Default = options.Default or 50, 
        Step = options.Step or 1, 
        Flag = options.Flag or ("TG_Slider_" .. (options.Name or "Slider")), 
        Callback = options.Callback or function() end, 
        Suffix = options.Suffix or "", 
        Prefix = options.Prefix or "", 
        ShowValue = options.ShowValue ~= false, 
        Type = "Slider"
    }
    
    local theme = TakoGlass.CurrentTheme
    
    if slider.Max <= slider.Min then
        slider.Max = slider.Min + 1
    end
    
    if section.Window.Config[slider.Flag] ~= nil then
        slider.Default = math.clamp(section.Window.Config[slider.Flag], slider.Min, slider.Max)
    end
    
    slider.Value = slider.Default
    section.Window.Flags[slider.Flag] = slider.Value
    
    slider.Frame = Create("Frame", {
        Name = "Slider_" .. slider.Name, 
        Size = UDim2.new(1, 0, 0, 50), 
        BackgroundTransparency = 1, 
        ZIndex = 106, 
        Parent = section.Content
    })
    
    slider.NameLabel = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = slider.Name, 
        Font = UI_FONT, 
        TextSize = 14, 
        TextColor3 = theme.Text, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Size = UDim2.new(1, -60, 0, 20), 
        Position = UDim2.new(0, 0, 0, 0), 
        ZIndex = 107, 
        Parent = slider.Frame
    })
    
    if slider.ShowValue then
        slider.ValueLabel = Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = slider.Prefix .. tostring(slider.Value) .. slider.Suffix, 
            Font = UI_FONT, 
            TextSize = 12, 
            TextColor3 = theme.Accent, 
            TextXAlignment = Enum.TextXAlignment.Right, 
            Size = UDim2.new(0, 60, 0, 20), 
            Position = UDim2.new(1, -60, 0, 0), 
            ZIndex = 107, 
            Parent = slider.Frame
        })
    end
    
    slider.Track = Create("Frame", {
        BackgroundColor3 = theme.ElementBg, 
        Size = UDim2.new(1, 0, 0, 6), 
        Position = UDim2.new(0, 0, 1, -12), 
        BorderSizePixel = 0, 
        ZIndex = 108, 
        Parent = slider.Frame
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = slider.Track})
    
    local fillPercent = (slider.Value - slider.Min) / (slider.Max - slider.Min)
    slider.Fill = Create("Frame", {
        BackgroundColor3 = theme.Accent, 
        Size = UDim2.new(fillPercent, 0, 1, 0), 
        Position = UDim2.new(0, 0, 0, 0), 
        BorderSizePixel = 0, 
        ZIndex = 109, 
        Parent = slider.Track
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = slider.Fill})
    
    slider.Handle = Create("Frame", {
        BackgroundColor3 = theme.Text, 
        Size = UDim2.new(0, 16, 0, 16), 
        Position = UDim2.new(fillPercent, -8, 0.5, -8), 
        BorderSizePixel = 0, 
        ZIndex = 110, 
        Parent = slider.Track
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = slider.Handle})
    
    Create("ImageLabel", {
        Size = UDim2.new(1, 8, 1, 8), 
        Position = UDim2.new(0, -4, 0, -4), 
        BackgroundTransparency = 1, 
        Image = "rbxassetid://13190785000", 
        ImageColor3 = theme.Shadow, 
        ImageTransparency = 0.7, 
        ZIndex = 109, 
        Parent = slider.Handle
    })
    
    local isDragging = false
    
    function slider:SetValue(value)
        value = math.clamp(value, slider.Min, slider.Max)
        
        if slider.Step > 0 then
            value = math.floor((value - slider.Min) / slider.Step + 0.5) * slider.Step + slider.Min
        end
        
        if slider.Value == value then return end
        
        slider.Value = value
        section.Window.Flags[slider.Flag] = value
        section.Window.Config[slider.Flag] = value
        SaveConfig(section.Window.ConfigName, section.Window.Config)
        
        local percent = (value - slider.Min) / (slider.Max - slider.Min)
        
        Ease(slider.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        Ease(slider.Handle, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        if slider.ValueLabel then
            slider.ValueLabel.Text = slider.Prefix .. tostring(value) .. slider.Suffix
        end
        
        slider.Callback(value)
    end
    
    local function updateFromMouse(input)
        if not slider.Track.AbsoluteSize.X or slider.Track.AbsoluteSize.X <= 0 then return end
        
        local percent = math.clamp((input.Position.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X, 0, 1)
        local value = slider.Min + (slider.Max - slider.Min) * percent
        
        slider:SetValue(value)
    end
    
    slider.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            input:Capture()
            updateFromMouse(input)
            
            Ease(slider.Handle, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
        end
    end)
    
    slider.Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            input:Capture()
            
            Ease(slider.Handle, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            input:Release()
            
            Ease(slider.Handle, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
        end
    end)
    
    function slider:ApplyTheme(newTheme)
        slider.NameLabel.TextColor3 = newTheme.Text
        if slider.ValueLabel then
            slider.ValueLabel.TextColor3 = newTheme.Accent
        end
        slider.Track.BackgroundColor3 = newTheme.ElementBg
        slider.Fill.BackgroundColor3 = newTheme.Accent
        slider.Handle.BackgroundColor3 = newTheme.Text
    end
    
    table.insert(section.Elements, slider)
    table.insert(section.Window.Elements, slider)
    
    return {
        SetValue = function(value) slider:SetValue(value) end, 
        GetValue = function() return slider.Value end, 
        GetMin = function() return slider.Min end, 
        GetMax = function() return slider.Max end, 
        SetRange = function(min, max) 
            slider.Min = min 
            slider.Max = max 
            slider:SetValue(slider.Value)
        end, 
        Destroy = function() slider.Frame:Destroy() end
    }
end

-- Button element
function TakoGlass.Elements.CreateButton(section, options)
    options = options or {}
    
    local button = {
        Section = section, 
        Window = section.Window, 
        Name = options.Name or "Button", 
        Callback = options.Callback or function() end, 
        Style = options.Style or "Default",
        Icon = options.Icon or "", 
        FullSize = options.FullSize or false, 
        Locked = options.Locked or false, 
        Type = "Button"
    }
    
    local theme = TakoGlass.CurrentTheme
    
    local buttonColor, textColor
    if button.Style == "Primary" then
        buttonColor = theme.Accent
        textColor = Color3.new(1, 1, 1)
    elseif button.Style == "Success" then
        buttonColor = theme.Success
        textColor = Color3.new(1, 1, 1)
    elseif button.Style == "Warning" then
        buttonColor = theme.Warning
        textColor = Color3.new(0, 0, 0)
    elseif button.Style == "Danger" then
        buttonColor = theme.Error
        textColor = Color3.new(1, 1, 1)
    else
        buttonColor = theme.ElementBg
        textColor = theme.Text
    end
    
    button.Frame = Create("Frame", {
        Name = "Button_" .. button.Name, 
        Size = button.FullSize and UDim2.new(1, 0, 0, 40) or UDim2.new(1, 0, 0, 36), 
        BackgroundTransparency = 1, 
        ZIndex = 106, 
        Parent = section.Content
    })
    
    button.Button = Create("TextButton", {
        BackgroundColor3 = buttonColor, 
        BackgroundTransparency = 0, 
        Text = button.Name, 
        Font = UI_FONT, 
        TextSize = 14, 
        TextColor3 = textColor, 
        Size = UDim2.new(1, 0, 1, 0), 
        ZIndex = 107, 
        Parent = button.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, ELEMENT_RADIUS), Parent = button.Button})
    
    if button.Icon ~= "" then
        button.IconLabel = Create("TextLabel", {
            BackgroundTransparency = 1, 
            Text = button.Icon, 
            Font = UI_FONT, 
            TextSize = 16, 
            TextColor3 = textColor, 
            Size = UDim2.new(0, 20, 0, 20), 
            Position = UDim2.new(0, 10, 0.5, -10), 
            ZIndex = 108, 
            Parent = button.Button
        })
        
        button.Button.Text = "   " .. button.Name
    end
    
    local originalColor = buttonColor
    
    button.Button.MouseEnter:Connect(function()
        if button.Locked then return end
        
        Ease(button.Button, {BackgroundColor3 = button.Style == "Default" and theme.AccentSoft or buttonColor}, 0.2)
        Ease(button.Button, {BackgroundTransparency = 0.1}, 0.2)
    end)
    
    button.Button.MouseLeave:Connect(function()
        Ease(button.Button, {BackgroundColor3 = originalColor}, 0.2)
        Ease(button.Button, {BackgroundTransparency = 0}, 0.2)
    end)
    
    button.Button.MouseButton1Down:Connect(function()
        if button.Locked then return end
        
        TakoGlass.Animations.Bounce(button.Button, 0.95, 0.1)
    end)
    
    button.Button.MouseButton1Click:Connect(function()
        if button.Locked then return end
        
        local success, result = pcall(button.Callback)
        if not success then
            TakoGlass.Notifications.Show({
                Title = "Button Error", 
                Content = "Error executing button callback: " .. tostring(result), 
                Duration = 3, 
                Type = "Error", 
                Icon = "❌"
            })
        end
    end)
    
    function button:ApplyTheme(newTheme)
        local newButtonColor, newTextColor
        if button.Style == "Primary" then
            newButtonColor = newTheme.Accent
            newTextColor = Color3.new(1, 1, 1)
        elseif button.Style == "Success" then
            newButtonColor = newTheme.Success
            newTextColor = Color3.new(1, 1, 1)
        elseif button.Style == "Warning" then
            newButtonColor = newTheme.Warning
            newTextColor = Color3.new(0, 0, 0)
        elseif button.Style == "Danger" then
            newButtonColor = newTheme.Error
            newTextColor = Color3.new(1, 1, 1)
        else
            newButtonColor = newTheme.ElementBg
            newTextColor = newTheme.Text
        end
        
        button.Button.BackgroundColor3 = newButtonColor
        button.Button.TextColor3 = newTextColor
        if button.IconLabel then
            button.IconLabel.TextColor3 = newTextColor
        end
        
        originalColor = newButtonColor
    end
    
    table.insert(section.Elements, button)
    table.insert(section.Window.Elements, button)
    
    return {
        SetText = function(text) button.Button.Text = (button.Icon ~= "" and "   " or "") .. text end, 
        SetLocked = function(locked) button.Locked = locked end, 
        Destroy = function() button.Frame:Destroy() end
    }
end

-- Input element
function TakoGlass.Elements.CreateInput(section, options)
    options = options or {}
    
    local input = {
        Section = section, 
        Window = section.Window, 
        Name = options.Name or "Input", 
        Default = options.Default or "", 
        Placeholder = options.Placeholder or "", 
        Flag = options.Flag or ("TG_Input_" .. (options.Name or "Input")), 
        Callback = options.Callback or function() end, 
        Type = options.Type or "Text",
        Multiline = options.Multiline or false, 
        MaxLength = options.MaxLength or 1000, 
        ClearOnFocus = options.ClearOnFocus or false, 
        Value = options.Default or "", 
        Type = "Input"
    }
    
    local theme = TakoGlass.CurrentTheme
    
    if section.Window.Config[input.Flag] ~= nil then
        input.Value = section.Window.Config[input.Flag]
    end
    
    section.Window.Flags[input.Flag] = input.Value
    
    input.Frame = Create("Frame", {
        Name = "Input_" .. input.Name, 
        Size = UDim2.new(1, 0, 0, input.Multiline and 80 or 40), 
        BackgroundTransparency = 1, 
        ZIndex = 106, 
        Parent = section.Content
    })
    
    input.Label = Create("TextLabel", {
        BackgroundTransparency = 1, 
        Text = input.Name, 
        Font = UI_FONT, 
        TextSize = 14, 
        TextColor3 = theme.Text, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Size = UDim2.new(1, 0, 0, 20), 
        Position = UDim2.new(0, 0, 0, 0), 
        ZIndex = 107, 
        Parent = input.Frame
    })
    
    input.InputField = Create(input.Multiline and "TextBox" or "TextBox", {
        BackgroundColor3 = theme.ElementBg, 
        BackgroundTransparency = 0, 
        Text = input.Value, 
        PlaceholderText = input.Placeholder, 
        Font = UI_FONT, 
        TextSize = 13, 
        TextColor3 = theme.Text, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        ClearTextOnFocus = input.ClearOnFocus, 
        Size = UDim2.new(1, 0, 0, input.Multiline and 50 or 18), 
        Position = UDim2.new(0, 0, 1, -18), 
        ZIndex = 108, 
        Parent = input.Frame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, ELEMENT_RADIUS), Parent = input.InputField})
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 8), 
        PaddingRight = UDim.new(0, 8), 
        PaddingTop = UDim.new(0, 4), 
        PaddingBottom = UDim.new(0, 4), 
        Parent = input.InputField
    })
    
    if input.Multiline then
        input.InputField.Size = UDim2.new(1, 0, 0, 50)
        input.InputField.TextWrapped = true
        input.InputField.ClearTextOnFocus = false
    end
    
    if input.Type == "Number" then
        input.InputField.FocusLost:Connect(function()
            local number = tonumber(input.InputField.Text)
            if number then
                input:SetValue(tostring(number))
            else
                input.InputField.Text = input.Value
            end
        end)
    elseif input.Type == "Password" then
        input.InputField.Text = string.rep("•", #input.Value)
        
        input.InputField.Focused:Connect(function()
            input.InputField.Text = input.Value
        end)
        
        input.InputField.FocusLost:Connect(function()
            input:SetValue(input.InputField.Text)
            input.InputField.Text = string.rep("•", #input.Value)
        end)
    end
    
    function input:SetValue(value)
        if #value > input.MaxLength then
            value = value:sub(1, input.MaxLength)
        end
        
        input.Value = value
        section.Window.Flags[input.Flag] = value
        section.Window.Config[input.Flag] = value
        SaveConfig(section.Window.ConfigName, section.Window.Config)
        
        if input.Type == "Password" and not input.InputField:IsFocused() then
            input.InputField.Text = string.rep("•", #value)
        else
            input.InputField.Text = value
        end
        
        input.Callback(value)
    end
    
    input.InputField.FocusLost:Connect(function(enterPressed)
        input:SetValue(input.InputField.Text)
        input.Callback(input.Value, enterPressed)
    end)
    
    input.InputField:GetPropertyChangedSignal("Text"):Connect(function()
        if input.InputField.Text:len() > input.MaxLength then
            input.InputField.Text = input.InputField.Text:sub(1, input.MaxLength)
        end
    end)
    
    input.InputField.MouseEnter:Connect(function()
        Ease(input.InputField, {BackgroundTransparency = 0.9}, 0.2)
    end)
    
    input.InputField.MouseLeave:Connect(function()
        Ease(input.InputField, {BackgroundTransparency = 0}, 0.2)
    end)
    
    function input:ApplyTheme(newTheme)
        input.Label.TextColor3 = newTheme.Text
        input.InputField.BackgroundColor3 = newTheme.ElementBg
        input.InputField.TextColor3 = newTheme.Text
        input.InputField.PlaceholderColor3 = newTheme.SubText
    end
    
    table.insert(section.Elements, input)
    table.insert(section.Window.Elements, input)
    
    return {
        SetValue = function(value) input:SetValue(value) end, 
        GetValue = function() return input.Value end, 
        SetLocked = function(locked) input.InputField.Active = not locked end, 
        Destroy = function() input.Frame:Destroy() end
    }
end

-- Export
TakoGlass.Notify = TakoGlass.Notifications.Show
TakoGlass.CreateNotification = TakoGlass.Notifications.Show

return TakoGlass
