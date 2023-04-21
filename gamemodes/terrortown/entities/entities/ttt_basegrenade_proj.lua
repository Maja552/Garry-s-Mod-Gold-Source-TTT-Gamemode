-- common grenade projectile code

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")


AccessorFunc( ENT, "thrower", "Thrower")

ENT.ExplosionSounds = {
	Sound("hl1/weapons/explode3.wav"),
	Sound("hl1/weapons/explode4.wav"),
	Sound("hl1/weapons/explode5.wav")
}
ENT.DebrisSounds = {
	Sound("weapons/debris1.wav"),
	Sound("weapons/debris2.wav"),
	Sound("weapons/debris3.wav")
}

function ENT:SetupDataTables()
   self:NetworkVar("Float", 0, "ExplodeTime")
end

function ENT:Initialize()
   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

   if SERVER then
      self:SetExplodeTime(0)
   end
end

function ENT:ExplosionEffects(pos, norm, scale)
	pos = pos or self:GetPos()
	norm = norm or Vector()
	scale = scale or 33

	local effPos = pos + norm * (scale / 2 + 28)
	local tr = util.QuickTrace(effPos, Vector(0,0,10), self)
	effPos = tr.HitPos
	tr = util.QuickTrace(effPos, Vector(0,0,5), self)
	if norm[3] > 0 and !tr.Hit then
		effPos = tr.HitPos
	end

	local explosion = EffectData()
	explosion:SetOrigin(effPos)
	explosion:SetNormal(norm)
	explosion:SetScale(scale)
	explosion:SetFlags(1)
	util.Effect("hl1_explosion", explosion)
	util.Effect("hl1_explosionsmoke", explosion)
	
	if self:WaterLevel() == 0 then
		for i = 0, math.random(0,3) do
			local sparks = ents.Create("spark_shower")
			if IsValid(sparks) then
				sparks:SetPos(pos + Vector(0,0,40))
				sparks:SetAngles(AngleRand())
				sparks:Spawn()
			end
		end
		self:EmitSound(self.DebrisSounds[math.random(1,3)], 80, 100, 1, CHAN_VOICE)
	end
	
	self:EmitSound(self.ExplosionSounds[math.random(1,3)], 400, 100, 1, CHAN_ITEM)
end

function ENT:SetDetonateTimer(length)
   self:SetDetonateExact( CurTime() + length )
end

function ENT:SetDetonateExact(t)
   self:SetExplodeTime(t or CurTime())
end

-- override to describe what happens when the nade explodes
function ENT:Explode(tr)
   ErrorNoHalt("ERROR: BaseGrenadeProjectile explosion code not overridden!\n")
end

function ENT:Think()
   local etime = self:GetExplodeTime() or 0
   if etime != 0 and etime < CurTime() then
      -- if thrower disconnects before grenade explodes, just don't explode
      if SERVER and (not IsValid(self:GetThrower())) then
         self:Remove()
         etime = 0
         return
      end

      -- find the ground if it's near and pass it to the explosion
      local spos = self:GetPos()
      local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.thrower})

      local success, err = pcall(self.Explode, self, tr)
      if not success then
         -- prevent effect spam on Lua error
         self:Remove()
         ErrorNoHalt("ERROR CAUGHT: ttt_basegrenade_proj: " .. err .. "\n")
      end
   end
end
