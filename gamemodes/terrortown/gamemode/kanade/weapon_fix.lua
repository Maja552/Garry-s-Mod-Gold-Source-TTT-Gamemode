
local wfix_weps = {
    "weapon_zm_sledge",
    "weapon_ttt_p90",
    "weapon_zm_mac10",
    "weapon_ttt_famas",
}

local dist_to_pickup = 100

if SERVER then
    util.AddNetworkString("gsttt_gib_wep")

    net.Receive("gsttt_gib_wep", function(len, ply)
        if len > 512 or !ply:Alive() then return end

        local wep = net.ReadEntity()
        if !IsValid(wep) then return end

        local dist = ply:GetPos():Distance(wep:GetPos())
        --print(ply:Nick().."is trying to pickup weapon: ", wep, len, dist)

        if dist < dist_to_pickup and !ply:HasWeapon(wep:GetClass()) and ply:CanCarryWeapon(wep) then
            ply:PickupWeapon(wep, false)
        end
    end)
else
    local nwfc = 0
    hook.Add("Tick", "gsttt_weaponfix_Tick", function()
        if CurTime() < 20 or !LocalPlayer().IsZombie then return end
        if nwfc < CurTime() then
            local client = LocalPlayer()
            if client:IsZombie() or !client:Alive() or client:IsSpec() then
                nwfc = CurTime() + 10
                return
            end
            
            nwfc = CurTime() + 0.2
            for k,v in pairs(ents.FindInSphere(client:GetPos() - Vector(0,0,20), dist_to_pickup + 5)) do
                v.nextPickupTry = v.nextPickupTry or 0
                if table.HasValue(wfix_weps, v:GetClass()) and !IsValid(v:GetOwner()) and v.nextPickupTry < CurTime() then
                    v.nextPickupTry = CurTime() + 2
                    --print("trying to pick up " .. v:GetClass())
                    local dist = client:GetPos():Distance(v:GetPos())
                    if dist < dist_to_pickup then
                        net.Start("gsttt_gib_wep")
                            net.WriteEntity(v)
                        net.SendToServer()
                        nwfc = CurTime() + 0.5
                    end
                end
            end
        end
    end)
end
