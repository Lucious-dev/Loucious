local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Вспомогательная функция для создания элементов UI
local function CreateElement(class, properties)
    local element = Instance.new(class)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- Вспомогательная функция для анимации (твин)
local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function UILibrary:CreateWindow(title)
    local window = {}

    local ScreenGui = CreateElement("ScreenGui", {
        Name = "DC_GUI",
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })

    -- Основной фрейм
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(54, 57, 63), -- тёмный Discord
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -350, 0.5, -250),
        Size = UDim2.new(0, 700, 0, 500),
        ClipsDescendants = true,
        Visible = true
    })
    CreateElement("UICorner", {CornerRadius = UDim.new(0, 20), Parent = MainFrame})

    -- Верхняя панель
    local TopBar = CreateElement("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(47, 49, 54),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 70)
    })
    CreateElement("UICorner", {CornerRadius = UDim.new(0, 20), Parent = TopBar})

    local TitleLabel = CreateElement("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = title or "DC GUI",
        TextColor3 = Color3.fromRGB(114, 137, 218), -- пурпурный Discord
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Кнопки закрытия и свертывания
    local function CreateTopButton(text, color, position)
        local btn = CreateElement("TextButton", {
            Parent = TopBar,
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Position = position,
            Size = UDim2.new(0, 40, 0, 40),
            Font = Enum.Font.SourceSansBold,
            Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20
        })
        CreateElement("UICorner", {CornerRadius = UDim.new(0, 12), Parent = btn})
        return btn
    end

    local CloseButton = CreateTopButton("X", Color3.fromRGB(237, 66, 69), UDim2.new(1, -60, 0.5, -20))
    local MinimizeButton = CreateTopButton("-", Color3.fromRGB(240, 170, 60), UDim2.new(1, -110, 0.5, -20))

    -- Левая панель вкладок
    local TabContainer = CreateElement("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(47, 49, 54),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(0, 200, 1, -70)
    })
    CreateElement("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TabContainer})
    CreateElement("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })

    -- Основное содержимое
    local ContentFrame = CreateElement("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 210, 0, 80),
        Size = UDim2.new(1, -220, 1, -90)
    })

    -- Аватар и имя игрока в левом нижнем углу
    local AvatarFrame = CreateElement("Frame", {
        Name = "AvatarFrame",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 1, -60),
        Size = UDim2.new(0, 180, 0, 50)
    })
    local Player = Players.LocalPlayer
    local Avatar = CreateElement("ImageLabel", {
        Parent = AvatarFrame,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    })
    CreateElement("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Avatar})

    local UsernameLabel = CreateElement("TextLabel", {
        Parent = AvatarFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = Player.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Поддержка перетаскивания (Android + ПК)
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)

    -- Кнопка закрытия
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Кнопка свертывания
    MinimizeButton.MouseButton1Click:Connect(function()
        if ContentFrame.Visible then
            Tween(ContentFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            ContentFrame.Visible = false
    
        else
            ContentFrame.Visible = true
            Tween(ContentFrame, {Size = UDim2.new(1, -220, 1, -90)}, 0.2)
        end
    end)

    return window
end

return UILibrary
