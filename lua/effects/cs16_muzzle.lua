function EFFECT:GetMuzzlePos()
	local pos = self.Position

	if !IsValid(self.Weapon) then 
		return pos
	end

	local ply = LocalPlayer()
	local observing = ply:GetObserverTarget()

	if self.Weapon:IsCarriedByLocalPlayer() and !ply:ShouldDrawLocalPlayer() or ply:GetObserverMode() == OBS_MODE_IN_EYE and IsValid(observing) and self.Weapon:GetOwner() == specply then
		local vm = ply:GetViewModel()
		local attach = vm:GetAttachment(self.AttachVM)

		if attach then
			pos = attach.Pos
		end
	else
		local attach = self.Weapon:GetAttachment(self.AttachWM)
		if attach then
			pos = attach.Pos
		else
			local owner = self.Weapon:GetOwner()
			if IsValid(owner) then
				local attach = owner:GetAttachment(owner:LookupAttachment("Anim_Attachment_RH"))
				if attach then
					pos = attach.Pos + attach.Ang:Forward() * 10 + attach.Ang:Right() * 1 + attach.Ang:Up() * 5
				end
			end
		end
	end

	return pos
end

local muzzles = {
	[0] = "cs16/muzzleflash1",
	[1] = "cs16/muzzleflash2",
	[2] = "cs16/muzzleflash3",
	[3] = "cs16/muzzleflash4"
}
function EFFECT:Init(data)
	self.Weapon = data:GetEntity()
	self.Position = data:GetOrigin()
	self.ScaleVW = data:GetStart()
	self.AttachVM = data:GetAttachment()
	self.AttachWM = self.ScaleVW[3]
	self.DieTime = FrameTime() + 0.02
	self.tempt = {}

	self:SetParent(self.Weapon)
	local pos = self:GetMuzzlePos()
	local emitter = ParticleEmitter(pos)

	local v_index = math.Clamp(math.Round(self.ScaleVW[1] % 5), 0, 3)
	local w_index = math.Clamp(math.Round(self.ScaleVW[2] % 5), 0, 3)

	local v_scale = (self.ScaleVW[1] - v_index) / 2
	local w_scale = (self.ScaleVW[2] - w_index) / 2 // (self.ScaleVW[2] / 10) * 0.1
	if w_scale <= 0 then
		w_scale = 0.5
	end

	local scale, index = w_scale, w_index

	if IsValid(self.Weapon) and self.Weapon:IsCarriedByLocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() then
		scale = v_scale
		index = v_index

		if (self.Weapon:GetClass() == CS16_WEAPON_G3SG1 or self.Weapon:GetClass() == CS16_WEAPON_SG550) and self.Weapon:GetScopeZoom() > 0 then
			return
		end
	end
	
	local add = ""
	if index == 1 or index == 2 then
		add = "_"..math.random(1, 3)
	end

	for i = 0, math.random(0, 1) do
		local scale = scale
		local roll = 0
		self.tempt[i] = emitter:Add(muzzles[index]..add, pos)
		self.tempt[i]:SetGravity(Vector())
		self.tempt[i]:SetDieTime(self.DieTime)
		self.tempt[i]:SetStartAlpha(255)
		self.tempt[i]:SetEndAlpha(255)

		if index == 0 then
			scale = scale * math.Rand(0.5, 0.6)
			roll = -270 * math.random(0, 3)
		else
			roll = math.random(-180, 180)
		end

		self.tempt[i]:SetStartSize(scale)
		self.tempt[i]:SetEndSize(scale)
		self.tempt[i]:SetRoll(roll)
		self.tempt[i]:SetColor(255, 255, 255)
	end

	emitter:Finish()

	local dynlight = DynamicLight(self:EntIndex())
	dynlight.Pos = pos
	dynlight.Size = 100
	dynlight.Decay = 2 ^ 11
	dynlight.R = 255
	dynlight.G = 150
	dynlight.B = 50
	dynlight.Brightness = 2
	dynlight.DieTime = CurTime() + 0.001
	
	self:SetRenderBoundsWS(pos, self.Position)
end

function EFFECT:Think()
	self.DieTime = self.DieTime - FrameTime()
	return self.DieTime > 0
end

function EFFECT:Render()
	for k, v in pairs(self.tempt) do
		v:SetPos(self:GetMuzzlePos())
	end
end