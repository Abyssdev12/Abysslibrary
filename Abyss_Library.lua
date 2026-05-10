--[[
    Abyss UI Library - Pro Edition
    Inspirada na estética Nebulatech & Deep Sea
    Desenvolvida para Roblox (Luau)
    Repositório: https://github.com/Abyssdev12/Abysslibrary
]]

local Abyss = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Configurações de Tema
local Theme = {
    MainBackground = Color3.fromRGB(10, 15, 25),
    SidebarBackground = Color3.fromRGB(15, 25, 40),
    SectionBackground = Color3.fromRGB(20, 35, 55),
    Accent = Color3.fromRGB(0, 180, 255),
    TextPrimary = Color3.fromRGB(240, 250, 255),
    TextSecondary = Color3.fromRGB(150, 180, 200),
    Border = Color3.fromRGB(30, 50, 80),
    Font = Enum.Font.GothamMedium,
    Transparency = 0.1,
    GlowColor = Color3.fromRGB(0, 180, 255)
}

-- Utilitários
local function Create(class, properties)
    local instance = Instance.new(class)
    for i, v in pairs(properties) do
        if i ~= "Parent" then
            instance[i] = v
        end
    end
    instance.Parent = properties.Parent
    return instance
end

-- Dragging Suave (Lerp)
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    local dragSpeed = 0.15

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            object.Position = object.Position:Lerp(targetPos, dragSpeed)
        end
    end)
end

function Abyss:CreateWindow(title, subtitle, keySettings)
    local ScreenGui = Create("ScreenGui", {
        Name = "AbyssUI",
        Parent = CoreGui,
        ResetOnSpawn = false
    })

    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.MainBackground,
        BackgroundTransparency = Theme.Transparency,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
        Visible = false
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainFrame})
    Create("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.5, Parent = MainFrame})

    -- Resize Handle
    local ResizeHandle = Create("Frame", {
        Name = "ResizeHandle",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 20, 0, 20),
        ZIndex = 10
    })

    local resizing = false
    local resizeStartPos, startSize

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStartPos = input.Position
            startSize = MainFrame.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStartPos
            MainFrame.Size = UDim2.new(0, math.max(400, startSize.X.Offset + delta.X), 0, math.max(300, startSize.Y.Offset + delta.Y))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    -- Sistema de Key (Corrigido)
    if keySettings and keySettings.Enabled then
        local KeyFrame = Create("Frame", {
            Name = "KeySystem",
            Parent = ScreenGui,
            BackgroundColor3 = Theme.MainBackground,
            BackgroundTransparency = 0.05,
            Position = UDim2.new(0.5, -150, 0.5, -100),
            Size = UDim2.new(0, 300, 0, 200)
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = KeyFrame})
        Create("UIStroke", {Color = Theme.Accent, Thickness = 1, Parent = KeyFrame})

        local KeyTitle = Create("TextLabel", {
            Parent = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 20),
            Size = UDim2.new(1, 0, 0, 30),
            Font = Theme.Font,
            Text = "ABYSS KEY SYSTEM",
            TextColor3 = Theme.Accent,
            TextSize = 18
        })

        local KeyInput = Create("TextBox", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.SidebarBackground,
            Position = UDim2.new(0.1, 0, 0.4, 0),
            Size = UDim2.new(0.8, 0, 0, 35),
            Font = Theme.Font,
            PlaceholderText = "Enter Key...",
            Text = "",
            TextColor3 = Theme.TextPrimary,
            TextSize = 14
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeyInput})

        local VerifyBtn = Create("TextButton", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0.1, 0, 0.65, 0),
            Size = UDim2.new(0.8, 0, 0, 35),
            Font = Theme.Font,
            Text = "Verify Key",
            TextColor3 = Theme.TextPrimary,
            TextSize = 14,
            AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = VerifyBtn})

        VerifyBtn.MouseButton1Click:Connect(function()
            if KeyInput.Text == keySettings.Key then
                KeyFrame:Destroy()
                MainFrame.Visible = true
            end
        end)
    else
        MainFrame.Visible = true
    end

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.SidebarBackground,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 170, 1, 0)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})

    -- Perfil (Black Gradient + UIStroke 2px)
    local ProfileFrame = Create("Frame", {
        Name = "Profile",
        Parent = Sidebar,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 0, 110)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ProfileFrame})
    Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Parent = ProfileFrame})
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Rotation = 90,
        Parent = ProfileFrame
    })

    local Player = Players.LocalPlayer
    local AvatarCircle = Create("ImageLabel", {
        Name = "Avatar",
        Parent = ProfileFrame,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Position = UDim2.new(0.5, -25, 0, 10),
        Size = UDim2.new(0, 50, 0, 50),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150",
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = AvatarCircle})

    local NameLabel = Create("TextLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 65),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Theme.Font,
        Text = Player.Name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14
    })

    local StatusLabel = Create("TextLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 85),
        Size = UDim2.new(1, 0, 0, 15),
        Font = Theme.Font,
        Text = Player.MembershipType == Enum.MembershipType.Premium and "PREMIUM" or "FREE USER",
        TextColor3 = Theme.Accent,
        TextSize = 10
    })

    -- Tab Buttons Container
    local TabButtons = Create("ScrollingFrame", {
        Name = "TabButtons",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 130),
        Size = UDim2.new(1, 0, 1, -130),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    Create("UIListLayout", {Parent = TabButtons, Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center})

    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 0),
        Size = UDim2.new(1, -170, 1, 0)
    })

    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 1, -30)
    })

    MakeDraggable(Sidebar, MainFrame)

    local Window = {Tabs = {}}

    function Window:CreateTab(name, iconId)
        local TabButton = Create("TextButton", {
            Parent = TabButtons,
            BackgroundColor3 = Theme.SectionBackground,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 150, 0, 35),
            Font = Theme.Font,
            Text = name,
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabButton})

        local TabPage = Create("ScrollingFrame", {
            Parent = TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        Create("UIListLayout", {Parent = TabPage, Padding = UDim.new(0, 10)})

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Page.Visible = false
                tab.Button.BackgroundTransparency = 1
                tab.Button.TextColor3 = Theme.TextSecondary
            end
            TabPage.Visible = true
            TabButton.BackgroundTransparency = 0.5
            TabButton.TextColor3 = Theme.Accent
        end)

        local Tab = {Button = TabButton, Page = TabPage}
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then TabPage.Visible = true end

        function Tab:CreateSection(sectionName)
            local SectionFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.SectionBackground,
                BackgroundTransparency = 0.3,
                Size = UDim2.new(1, -10, 0, 40)
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SectionFrame})
            Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = SectionFrame})

            local SectionTitle = Create("TextLabel", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Theme.Font,
                Text = sectionName:upper(),
                TextColor3 = Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SectionContent = Create("Frame", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 0, 0)
            })
            local SectionList = Create("UIListLayout", {Parent = SectionContent, Padding = UDim.new(0, 8)})
            Create("UIPadding", {Parent = SectionContent, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})

            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 45)
                TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPage.UIListLayout.AbsoluteContentSize.Y + 20)
            end)

            local Section = {}

            function Section:CreateButton(text, callback)
                local Button = Create("TextButton", {
                    Parent = SectionContent,
                    BackgroundColor3 = Theme.MainBackground,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 14,
                    AutoButtonColor = false
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Button})
                Create("UIGradient", {Color = ColorSequence.new(Theme.MainBackground, Theme.SectionBackground), Parent = Button})
                Button.MouseButton1Click:Connect(callback)
            end

            function Section:CreateToggle(text, default, callback)
                local Toggled = default or false
                local ToggleBtn = Create("TextButton", {
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = ""
                })
                local Label = Create("TextLabel", {Parent = ToggleBtn, BackgroundTransparency = 1, Size = UDim2.new(1, -40, 1, 0), Font = Theme.Font, Text = text, TextColor3 = Theme.TextSecondary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
                local Box = Create("Frame", {Parent = ToggleBtn, BackgroundColor3 = Theme.MainBackground, Position = UDim2.new(1, -35, 0.5, -10), Size = UDim2.new(0, 35, 0, 20)})
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Box})
                local Inner = Create("Frame", {Parent = Box, BackgroundColor3 = Toggled and Theme.Accent or Theme.TextSecondary, Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Size = UDim2.new(0, 16, 0, 16)})
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Inner})

                ToggleBtn.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    TweenService:Create(Inner, TweenInfo.new(0.2), {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Toggled and Theme.Accent or Theme.TextSecondary}):Play()
                    callback(Toggled)
                end)
            end

            function Section:CreateSlider(text, min, max, default, callback)
                local Value = default or min
                local SliderFrame = Create("Frame", {Parent = SectionContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40)})
                local Label = Create("TextLabel", {Parent = SliderFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Font = Theme.Font, Text = text, TextColor3 = Theme.TextSecondary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
                local ValLabel = Create("TextLabel", {Parent = SliderFrame, BackgroundTransparency = 1, Position = UDim2.new(1, -40, 0, 0), Size = UDim2.new(0, 40, 0, 20), Font = Theme.Font, Text = tostring(Value), TextColor3 = Theme.Accent, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right})
                local Bar = Create("Frame", {Parent = SliderFrame, BackgroundColor3 = Theme.MainBackground, Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 8)})
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})
                local Fill = Create("Frame", {Parent = Bar, BackgroundColor3 = Theme.Accent, Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)})
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})

                local function Update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Value = math.floor(min + (max - min) * pos)
                    ValLabel.Text = tostring(Value)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    callback(Value)
                end

                local dragging = false
                Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(input) end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
            end

            function Section:CreateTextBox(text, placeholder, callback)
                local BoxFrame = Create("Frame", {Parent = SectionContent, BackgroundColor3 = Theme.MainBackground, Size = UDim2.new(1, 0, 0, 30)})
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = BoxFrame})
                local Label = Create("TextLabel", {Parent = BoxFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), Font = Theme.Font, Text = text, TextColor3 = Theme.TextSecondary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
                local Input = Create("TextBox", {Parent = BoxFrame, BackgroundTransparency = 1, Position = UDim2.new(0.4, 0, 0, 0), Size = UDim2.new(0.6, -10, 1, 0), Font = Theme.Font, PlaceholderText = placeholder, Text = "", TextColor3 = Theme.TextPrimary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right})
                Input.FocusLost:Connect(function() callback(Input.Text) end)
            end

            function Section:CreateDropdown(text, options, default, callback)
                local Selected = default or options[1]
                local Expanded = false
                local DropdownFrame = Create("Frame", {Parent = SectionContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ClipsDescendants = true})
                local Main = Create("TextButton", {Parent = DropdownFrame, BackgroundColor3 = Theme.MainBackground, Size = UDim2.new(1, 0, 0, 30), Text = "", AutoButtonColor = false})
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Main})
                local Label = Create("TextLabel", {Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -30, 1, 0), Font = Theme.Font, Text = text .. ": " .. Selected, TextColor3 = Theme.TextSecondary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
                local Icon = Create("TextLabel", {Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(1, -25, 0, 0), Size = UDim2.new(0, 20, 1, 0), Font = Theme.Font, Text = "▼", TextColor3 = Theme.TextSecondary, TextSize = 12})
                
                local OptionContainer = Create("Frame", {Parent = DropdownFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 35), Size = UDim2.new(1, 0, 0, 0)})
                local OptionList = Create("UIListLayout", {Parent = OptionContainer, Padding = UDim.new(0, 4)})

                for _, opt in pairs(options) do
                    local OptBtn = Create("TextButton", {Parent = OptionContainer, BackgroundColor3 = Theme.SidebarBackground, Size = UDim2.new(1, 0, 0, 25), Font = Theme.Font, Text = opt, TextColor3 = Theme.TextSecondary, TextSize = 13, AutoButtonColor = false})
                    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = OptBtn})
                    OptBtn.MouseButton1Click:Connect(function()
                        Selected = opt
                        Label.Text = text .. ": " .. Selected
                        Expanded = false
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                        callback(Selected)
                    end)
                end

                Main.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    local targetSize = Expanded and UDim2.new(1, 0, 0, 35 + OptionList.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 30)
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
                end)
            end

            function Section:CreateColorPicker(text, default, callback)
                local Color = default or Color3.fromRGB(255, 255, 255)
                local ColorFrame = Create("Frame", {Parent = SectionContent, BackgroundColor3 = Theme.MainBackground, Size = UDim2.new(1, 0, 0, 30)})
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ColorFrame})
                local Label = Create("TextLabel", {Parent = ColorFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -40, 1, 0), Font = Theme.Font, Text = text, TextColor3 = Theme.TextSecondary, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
                local Preview = Create("TextButton", {Parent = ColorFrame, BackgroundColor3 = Color, Position = UDim2.new(1, -30, 0.5, -10), Size = UDim2.new(0, 20, 0, 20), Text = ""})
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Preview})
                
                Preview.MouseButton1Click:Connect(function()
                    -- Simples alternância de cores para o exemplo, um picker real precisaria de uma UI dedicada
                    Color = (Color == Color3.fromRGB(255, 255, 255) and Theme.Accent or Color3.fromRGB(255, 255, 255))
                    Preview.BackgroundColor3 = Color
                    callback(Color)
                end)
            end

            return Section
        end
        return Tab
    end
    return Window
end

return Abyss
