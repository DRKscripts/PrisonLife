local weapons = {"Remington 870", "M9", "Riot Shield","AK-47","M4A1"}

function setTeam(color)
    local Remote = game.Workspace.Remote['TeamEvent']
    local Arguments = {
            [1] = color
    }
    Remote:FireServer(unpack(Arguments))
end

function punch(plrname)
    local Remote = game.ReplicatedStorage['meleeEvent']
    local Arguments = {
            [1] = game.Players[plrname]
    }
    Remote:FireServer(unpack(Arguments))
end

function getGun(gun)
    local Remote = game.Workspace.Remote['ItemHandler']
    local Arguments = {
            [1] = Workspace.Prison_ITEMS.giver[gun].ITEMPICKUP
    }
    Remote:InvokeServer(unpack(Arguments))
end

function getGuns()
    local giver = workspace.Prison_ITEMS.giver
    for i,v in pairs(weapons) 
        if giver:FindFirstChild(v) then
            getGun(v)
        end
    end
end

local player = ui:MakeWindow("Player");
local dropdown = player:addDropdown({"Select team","Guard","Neutral","Inmate"})
local killaura = player:addCheckbox("Killaura")

local fast = player:addCheckbox("Fast")
local highjump = player:addCheckbox("High jump")

local weapon = ui:MakeWindow("Weapon")

weapon:addButton("Get guns",function()
    getGuns();
end)

local rapidfire = weapon:addCheckbox("Rapid fire")
local infammo = weapon:addCheckbox("Infinite ammo")

local world = ui:MakeWindow("World")
local doors = world:addCheckbox("Remove doors")
local fences = world:addCheckbox("Remove fences")

local latesttele = "none"

local teledropdown = world:addDropdown({"Teleport","Cafeteria","Criminal base","Prison gate", "Sewer","Gun place"})

local ez = Instance.new("Folder")
ez.Name = "nikodoors"
ez.Parent = game:service"ReplicatedStorage"

local ez = Instance.new("Folder")
ez.Name = "nikofences"
ez.Parent = game:service"ReplicatedStorage"


game:service"RunService".RenderStepped:connect(function()
    if teledropdown.Selected.Value ~= latesttele then
        local v = teledropdown.Selected.Value

        if game.Players.LocalPlayer.Character then
            if game.Players.LocalPlayer.Character:FindFirstChild"HumanoidRootPart" then
                if v == "Gun place" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(828.222595, 99.9900055, 2257.802))
                elseif v == "Prison gate" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(500.32901, 98.0399399, 2222.14478))
                elseif v == "Cafeteria" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(929.020569, 99.9899597, 2285.35132))
                elseif v == "Criminal base" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-935.360474, 94.1287842, 2066.77319))
                elseif v == "Sewer" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(914.87793, 78.7045288, 2411.79102))
                end
            end
        end

        latesttele = v;
    end

    

    if fast.Checked.Value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 150
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end

    if highjump.Checked.Value then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 48
    end

    if killaura.Checked.Value then
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                if v~=game.Players.LocalPlayer then
                    if v.Character:FindFirstChild"HumanoidRootPart" then
                        local m = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                        if m<200 then
                            punch(v.Name)
                        end
                    end
                end
            end
        end
    end

    for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA"Tool" and v:FindFirstChild("GunStates") then
            local gun = require(v.GunStates)
            if rapidfire.Checked.Value then
                gun.AutoFire = true;
                gun.FireRate = 0.01
            else
                gun.AutoFire = false;
                gun.FireRate = 0.08
            end
            if infammo.Checked.Value then
                gun.CurrentAmmo = math.huge
                gun.StoredAmmo = math.huge
            else
                gun.CurrentAmmo = 10;
                gun.StoredAmmo = 100;
            end
        end
    end

    if fences.Checked.Value then
        for i,v in pairs(workspace.Prison_Fences:GetChildren()) do
            v.Parent = game:service"ReplicatedStorage".nikofences
        end
    else
        for i,v in pairs(game:service"ReplicatedStorage".nikofences:GetChildren()) do
            v.Parent = workspace.Prison_Fences
        end
    end

    if doors.Checked.Value then
        for i,v in pairs(workspace.Doors:GetChildren()) do
            v.Parent = game:service"ReplicatedStorage".nikodoors
        end
    else
        for i,v in pairs(game:service"ReplicatedStorage".nikodoors:GetChildren()) do
            v.Parent = workspace.Doors
        end
    end

    for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA"Tool" and v:FindFirstChild("GunStates") then
            local gun = require(v.GunStates)
            if rapidfire.Checked.Value then
                gun.AutoFire = true;
                gun.FireRate = 0.01
            else
                gun.AutoFire = false;
                gun.FireRate = 0.08
            end
            if infammo.Checked.Value then
                gun.CurrentAmmo = math.huge
                gun.StoredAmmo = math.huge
            else
                gun.CurrentAmmo = 10;
                gun.StoredAmmo = 100;
            end
        end
    end
end)

while(true) do
    wait()
    if dropdown.Selected.Value == "Guard" then
        setTeam("Bright blue")
    elseif dropdown.Selected.Value == "Neutral" then
        setTeam("Medium stone grey")
    elseif dropdown.Selected.Value == "Inmate" then
        setTeam("Bright orange")
    end

end
