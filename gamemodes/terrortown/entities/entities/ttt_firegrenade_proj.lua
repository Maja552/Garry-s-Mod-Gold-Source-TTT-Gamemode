-- burning nade projectile

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/cs/w_hegrenade.mdl")


AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )
AccessorFunc( ENT, "dmg", "Dmg", FORCE_NUMBER )

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius(256) end
   if not self:GetDmg() then self:SetDmg(25) end

   return self.BaseClass.Initialize(self)
end

function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()

      if util.PointContents(pos) == CONTENTS_WATER then
         self:Remove()
         return
      end

      
      local explosion = EffectData()
      explosion:SetOrigin(self:GetPos() + Vector(0,0,70))
      explosion:SetScale(33)
      explosion:SetFlags(1)
      util.Effect("hl1_explosion", explosion)
      util.Effect("hl1_explosionsmoke", explosion)

      self:EmitSound(self.ExplosionSounds[math.random(1,3)], 400, 100, 1, CHAN_ITEM)


      util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

      StartFires(pos, tr, 10, 20, false, self:GetThrower())

      self:SetDetonateExact(0)

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)
   end
end

