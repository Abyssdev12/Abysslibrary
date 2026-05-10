-- Abyss UI Library
-- Inspirada na estética Nebulatech
-- Desenvolvida para Roblox (Luau)

local Abyss = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configurações de Tema
local Theme = {
    MainBackground = Color3.fromRGB(15, 15, 15),
    SidebarBackground = Color3.fromRGB(20, 20, 20),
    SectionBackground = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(140, 120, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(35, 35, 35),
    Font = Enum.Font.GothamMedium
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

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos

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

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Abyss:CreateWindow(title, subtitle)
    local ScreenGui = Create("ScreenGui", {
        Name = "AbyssUI",
        Parent = CoreGui,
        ResetOnSpawn = false
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.MainBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true
    })

    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })

    Create("UIStroke", {
        Color = Theme.Border,
        Thickness = 1,
        Parent = MainFrame
    })

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.SidebarBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 160, 1, 0)
    })

    Create("UIStroke", {
        Color = Theme.Border,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = Sidebar
    })

    -- Logo/Title Area
    local TitleArea = Create("Frame", {
        Name = "TitleArea",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60)
    })

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = TitleArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Theme.Font,
        Text = title or "Abyss",
        TextColor3 = Theme.Accent,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SubtitleLabel = Create("TextLabel", {
        Name = "Subtitle",
        Parent = TitleArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -30, 0, 15),
        Font = Theme.Font,
        Text = subtitle or "UI Library",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container
    local TabButtons = Create("ScrollingFrame", {
        Name = "TabButtons",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(1, 0, 1, -70),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    Create("UIListLayout", {
        Parent = TabButtons,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(1, -160, 1, 0)
    })

    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 1, -30)
    })

    MakeDraggable(MainFrame, MainFrame)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name)
        local TabButton = Create("TextButton", {
            Name = name .. "Tab",
            Parent = TabButtons,
            BackgroundColor3 = Theme.SidebarBackground,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 140, 0, 32),
            AutoButtonColor = false,
            Font = Theme.Font,
            Text = "",
            TextColor3 = Theme.TextSecondary,
            TextSize = 14
        })

        Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })

        local TabLabel = Create("TextLabel", {
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -10, 1, 0),
            Font = Theme.Font,
            Text = name,
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local TabPage = Create("ScrollingFrame", {
            Name = name .. "Page",
            Parent = TabContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })

        local LeftColumn = Create("Frame", {
            Name = "LeftColumn",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -5, 1, 0)
        })

        Create("UIListLayout", {
            Parent = LeftColumn,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local RightColumn = Create("Frame", {
            Name = "RightColumn",
            Parent = TabPage,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 5, 0, 0),
            Size = UDim2.new(0.5, -5, 1, 0)
        })

        Create("UIListLayout", {
            Parent = RightColumn,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local function UpdateCanvasSize()
            local leftSize = LeftColumn.UIListLayout.AbsoluteContentSize.Y
            local rightSize = RightColumn.UIListLayout.AbsoluteContentSize.Y
            local maxSize = math.max(leftSize, rightSize)
            TabPage.CanvasSize = UDim2.new(0, 0, 0, maxSize + 20)
        end

        LeftColumn.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
        RightColumn.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)

        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                tab.Page.Visible = false
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SidebarBackground}):Play()
                TweenService:Create(tab.Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextSecondary}):Play()
            end
            TabPage.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SectionBackground}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()
        end

        TabButton.MouseButton1Click:Connect(SelectTab)

        local Tab = {
            Button = TabButton,
            Label = TabLabel,
            Page = TabPage
        }

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            SelectTab()
        end

        function Tab:CreateSection(sectionName, side)
            local ParentColumn = (side == "Right" and RightColumn) or LeftColumn
            
            local SectionFrame = Create("Frame", {
                Name = sectionName .. "Section",
                Parent = ParentColumn,
                BackgroundColor3 = Theme.SectionBackground,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30)
            })

            Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = SectionFrame
            })

            Create("UIStroke", {
                Color = Theme.Border,
                Thickness = 1,
                Parent = SectionFrame
            })

            local SectionTitle = Create("TextLabel", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Theme.Font,
                Text = sectionName:upper(),
                TextColor3 = Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SectionContent = Create("Frame", {
                Name = "Content",
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 0, 0)
            })

            local SectionList = Create("UIListLayout", {
                Parent = SectionContent,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Create("UIPadding", {
                Parent = SectionContent,
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })

            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 45)
                TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPage.UIListLayout.AbsoluteContentSize.Y)
            end)

            local Section = {}

            function Section:CreateButton(text, callback)
                local Button = Create("TextButton", {
                    Parent = SectionContent,
                    BackgroundColor3 = Theme.MainBackground,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    AutoButtonColor = false,
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 14
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Button
                })

                Button.MouseButton1Click:Connect(function()
                    callback()
                    local originalColor = Button.BackgroundColor3
                    Button.BackgroundColor3 = Theme.Accent
                    TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = originalColor}):Play()
                end)
            end

            function Section:CreateToggle(text, default, callback)
                local Toggled = default or false
                local ToggleFrame = Create("TextButton", {
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = ""
                })

                local Label = Create("TextLabel", {
                    Parent = ToggleFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -40, 1, 0),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Outer = Create("Frame", {
                    Parent = ToggleFrame,
                    BackgroundColor3 = Theme.MainBackground,
                    Position = UDim2.new(1, -35, 0.5, -10),
                    Size = UDim2.new(0, 35, 0, 20)
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Outer
                })

                local Inner = Create("Frame", {
                    Parent = Outer,
                    BackgroundColor3 = Toggled and Theme.Accent or Theme.TextSecondary,
                    Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16)
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Inner
                })

                ToggleFrame.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    local targetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local targetColor = Toggled and Theme.Accent or Theme.TextSecondary
                    
                    TweenService:Create(Inner, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
                    TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Toggled and Theme.TextPrimary or Theme.TextSecondary}):Play()
                    
                    callback(Toggled)
                end)
            end

            function Section:CreateSlider(text, min, max, default, callback)
                local Value = default or min
                local SliderFrame = Create("Frame", {
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45)
                })

                local Label = Create("TextLabel", {
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ValueLabel = Create("TextLabel", {
                    Parent = SliderFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -50, 0, 0),
                    Size = UDim2.new(0, 50, 0, 20),
                    Font = Theme.Font,
                    Text = tostring(Value),
                    TextColor3 = Theme.Accent,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local SliderBar = Create("Frame", {
                    Parent = SliderFrame,
                    BackgroundColor3 = Theme.MainBackground,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 6)
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = SliderBar
                })

                local Fill = Create("Frame", {
                    Parent = SliderBar,
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Fill
                })

                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    Value = math.floor(min + (max - min) * pos)
                    ValueLabel.Text = tostring(Value)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    callback(Value)
                end

                local dragging = false
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
            end

            function Section:CreateDropdown(text, options, default, callback)
                local Selected = default or options[1]
                local Expanded = false

                local DropdownFrame = Create("Frame", {
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    ClipsDescendants = true
                })

                local Main = Create("TextButton", {
                    Parent = DropdownFrame,
                    BackgroundColor3 = Theme.MainBackground,
                    Size = UDim2.new(1, 0, 0, 32),
                    AutoButtonColor = false,
                    Text = ""
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Main
                })

                local Label = Create("TextLabel", {
                    Parent = Main,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -40, 1, 0),
                    Font = Theme.Font,
                    Text = text .. ": " .. Selected,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Icon = Create("TextLabel", {
                    Parent = Main,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0, 30, 1, 0),
                    Font = Theme.Font,
                    Text = "▼",
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 12
                })

                local OptionContainer = Create("Frame", {
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 35),
                    Size = UDim2.new(1, 0, 0, 0)
                })

                local OptionList = Create("UIListLayout", {
                    Parent = OptionContainer,
                    Padding = UDim.new(0, 2)
                })

                for _, option in pairs(options) do
                    local OptionBtn = Create("TextButton", {
                        Parent = OptionContainer,
                        BackgroundColor3 = Theme.MainBackground,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Theme.Font,
                        Text = option,
                        TextColor3 = Theme.TextSecondary,
                        TextSize = 13,
                        AutoButtonColor = false
                    })

                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = OptionBtn
                    })

                    OptionBtn.MouseButton1Click:Connect(function()
                        Selected = option
                        Label.Text = text .. ": " .. Selected
                        Expanded = false
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                        Icon.Text = "▼"
                        callback(Selected)
                    end)
                end

                Main.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    local targetSize = Expanded and UDim2.new(1, 0, 0, 35 + OptionList.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 32)
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                    Icon.Text = Expanded and "▲" or "▼"
                end)
            end

            function Section:CreateTextBox(text, placeholder, callback)
                local TextBoxFrame = Create("Frame", {
                    Parent = SectionContent,
                    BackgroundColor3 = Theme.MainBackground,
                    Size = UDim2.new(1, 0, 0, 32)
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = TextBoxFrame
                })

                local Label = Create("TextLabel", {
                    Parent = TextBoxFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.4, -10, 1, 0),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Input = Create("TextBox", {
                    Parent = TextBoxFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.4, 0, 0, 0),
                    Size = UDim2.new(0.6, -10, 1, 0),
                    Font = Theme.Font,
                    PlaceholderText = placeholder or "Type here...",
                    Text = "",
                    TextColor3 = Theme.TextPrimary,
                    PlaceholderColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                Input.FocusLost:Connect(function(enterPressed)
                    callback(Input.Text)
                end)
            end

            function Section:CreateKeybind(text, default, callback)
                local Key = default or Enum.KeyCode.F
                local Binding = false

                local KeybindFrame = Create("TextButton", {
                    Parent = SectionContent,
                    BackgroundColor3 = Theme.MainBackground,
                    Size = UDim2.new(1, 0, 0, 32),
                    AutoButtonColor = false,
                    Text = ""
                })

                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeybindFrame
                })

                local Label = Create("TextLabel", {
                    Parent = KeybindFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local KeyLabel = Create("TextLabel", {
                    Parent = KeybindFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -60, 0, 0),
                    Size = UDim2.new(0, 50, 1, 0),
                    Font = Theme.Font,
                    Text = Key.Name,
                    TextColor3 = Theme.Accent,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                KeybindFrame.MouseButton1Click:Connect(function()
                    Binding = true
                    KeyLabel.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = input.KeyCode
                        KeyLabel.Text = Key.Name
                        Binding = false
                        callback(Key)
                    end
                end)
            end

            function Section:CreateLabel(text)
                local Label = Create("TextLabel", {
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                return Label
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Abyss
