
local plymeta = FindMetaTable("Player")

function plymeta:ForceRemoveFlashlight()
	if IsValid(self.halfLifeFlashlight) then
		self.halfLifeFlashlight:Remove()
	end
	self.halfLifeFlashlight = nil
end

local attach_to_entities = false

hook.Add("Tick", "HalfLifeFlashlightsTick", function()
	for _, ply in ipairs(player.GetAll()) do

		if ply:Alive() then
			if IsValid(ply.halfLifeFlashlight) then
				if attach_to_entities then
					if IsValid(ply:GetEyeTrace().Entity) then
						ply.halfLifeFlashlight:SetPos(ply:GetEyeTrace().Entity:GetPos())
					else
						ply.halfLifeFlashlight:SetPos(ply:GetEyeTrace().HitPos)
					end
				else
					ply.halfLifeFlashlight:SetPos(ply:GetEyeTrace().HitPos)
				end
			end
		else
			ply:ForceRemoveFlashlight()
		end
	end
end)

function plymeta:ForceUseFlashlight()
	local Light = ents.Create("light_dynamic")
	self.halfLifeFlashlight = Light
	Light:SetKeyValue("distance", 170)
	Light:SetKeyValue("_light", 237 .. " " .. 237 .. " " .. 185)
	Light:SetPos(self:GetEyeTrace().HitPos)
	Light:Spawn()
end

function GM:PlayerSwitchFlashlight(ply, enabled)
	ply.nextFlashlightUse = ply.nextFlashlightUse or 0
	if !ply:Alive() or ply:Team() == TEAM_SPECTATOR or !IsValid(ply) or ply.nextFlashlightUse > CurTime() then return false end
 
	timer.Simple(0.001, function()
	   if ply:Alive() then
		  ply:SendLua('surface.PlaySound("gsttt/flashlight1.wav")')
	   end
	end)

 
	ply.nextFlashlightUse = CurTime() + 0.25
	if IsValid(ply.halfLifeFlashlight) then
		ply:ForceRemoveFlashlight()
	else
		ply:ForceUseFlashlight()
	end

	return false
 end


hook.Add("PlayerDisconnected", "PlayerDisconnected_RemoveFlashlights", function(ply)
	ply:ForceRemoveFlashlight()
end)

hook.Add("PlayerDisconnected", "PlayerDisconnected_RemoveFlashlights", function(ply)
	ply:ForceRemoveFlashlight()
end)

hook.Add("DoPlayerDeath", "DoPlayerDeath_RemoveFlashlights", function(ply)
	ply:ForceRemoveFlashlight()
end)

hook.Add("TTTPrepareRound", "TTTPrepareRound_RemoveFlashlights", function()
    for k,ply in pairs(player.GetAll()) do
        ply:ForceRemoveFlashlight()
    end
end)
