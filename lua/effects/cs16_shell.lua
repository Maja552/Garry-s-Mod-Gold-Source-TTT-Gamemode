EFFECT.Shells = {
	[0] = {"models/cs16/pshell.mdl"},
	[1] = {"models/cs16/rshell.mdl"},
	[2] = {"models/cs16/shotgunshell.mdl", Sound("OldHit.ShotgunShell")},
}
EFFECT.BounceSound = nil
EFFECT.LifeTime = 2
EFFECT.FadeTime = 0.25

function CS16_GetDefaultShellInfo(pPlayer, attach, velocity, ShellVelocity, ShellOrigin, angles, forwardScale, upScale, rightScale, bReverseDirection)
	local forward, right, up = angles:Forward(), angles:Right(), angles:Up()
	local fR = math.Rand(50, 70)
	local fU = math.Rand(75, 175)
	local fF = math.Rand(25, 250)
	local fDirection = rightScale > 0 and -1 or 1

	if bReverseDirection then
		ShellVelocity = velocity * 0.5 - right * fR * fDirection + up * fU + forward * fF
	else
		ShellVelocity = velocity * 0.5 + right * fR * fDirection + up * fU + forward * fF
	end

	ShellOrigin = attach.Pos //velocity * 0.1 + view_ofs + (upScale * up) + (forwardScale * forward)  + (rightScale * right)
	
	return ShellVelocity, ShellOrigin
end

function EFFECT:Init(data)
	self.ShellType = data:GetSurfaceProp()
	self.StartTime = CurTime()
	self.Weapon = data:GetEntity()
	self._Weapon = self.Weapon
	
	if !self.Shells[self.ShellType] then
		return
	end

	if !IsValid(self.Weapon) then 
		return 
	end

	self.BounceSound = self.Shells[self.ShellType][2] or Sound("OldHit.PShell")
	self.Attachment = data:GetAttachment()
	self.Dir = data:GetNormal()

	local model = self.Shells[self.ShellType][1]
	local owner = self.Weapon:GetOwner()

	if !IsValid(owner) or !owner:IsPlayer() then
		return
	end

	if owner == GetViewEntity() and !owner:ShouldDrawLocalPlayer() then
		self.Weapon = owner:GetViewModel()

		if !IsValid(self.Weapon) then return end
	else
		return
	end

	local attach = self.Weapon:GetAttachment(self.Weapon:LookupAttachment(self.Attachment))

	if !attach or !attach.Pos then
		attach = {
			Pos = vector_origin,
			Ang = angle_zero
		}
	end

	local ang = IsValid(owner) and owner:EyeAngles() or Angle()
	local pos, velocity, ang = self._Weapon:GetShellDir(attach)
	local min, max = Vector(-0.5, -0.15, -0.5), Vector(0.5, 0.15, 0.5)

	self:SetModel(model)
	self:SetModelScale(1.3, 0)
	self:SetPos(pos)
	self:SetAngles(Angle(0, ang, 0))
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetCollisionBounds(min, max)
	self:PhysicsInitBox(min, max)
	local physObj = self:GetPhysicsObject()

	if physObj:IsValid() then
		physObj:SetDamping(1, 0)
		physObj:SetMass(1)
		physObj:SetMaterial("gmod_silent")
		physObj:SetVelocity(velocity)
		physObj:AddAngleVelocity(VectorRand() * math.random(1000, 4000))
	end

	self.CanRender = true

	if (self._Weapon:GetClass() == CS16_WEAPON_G3SG1 or self._Weapon:GetClass() == CS16_WEAPON_SG550) and self._Weapon:GetScopeZoom() > 0 then
		self.CanRender = false
	end
end

function EFFECT:PhysicsCollide(data)
	if self:WaterLevel() > 0 then return end

	if data.Speed > 60 then
		self.LifeTime = 0.9
		sound.Play(self.BounceSound, self:GetPos())
		
		local impulse = (data.OurOldVelocity - 2 * data.OurOldVelocity:Dot(data.HitNormal) * data.HitNormal) * 0.33
		local phys = self:GetPhysicsObject()

		if phys:IsValid() then
			phys:ApplyForceCenter(impulse)
		end
	end
end

function EFFECT:Think()
	if self:WaterLevel() > 0 and not self.WaterSplashed then
		self.WaterSplashed = true
		local ef = EffectData()
		ef:SetOrigin(self:GetPos())
		ef:SetScale(1)
		util.Effect("watersplash", ef)
	end

	if CurTime() > self.StartTime + self.LifeTime then
		return false
	else
		return true
	end
end

function EFFECT:Render()
	if !self.CanRender then return end

	self:SetColor(ColorAlpha(color_white, (1 - math.Clamp(CurTime() - (self.StartTime + self.LifeTime - self.FadeTime), 0, self.FadeTime) / self.FadeTime) * 255))
	self:SetupBones()
	self:DrawModel()
end