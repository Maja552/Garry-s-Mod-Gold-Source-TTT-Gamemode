
AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "confgrenade_name"
   SWEP.Slot            = 3

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 80

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "h"
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.WeaponID           = AMMO_DISCOMB
SWEP.Kind               = WEAPON_NADE

SWEP.Spawnable          = true
SWEP.AutoSpawnable      = true

SWEP.UseHands           = true
SWEP.ViewModel          = "models/hl1/c_grenade.mdl"
SWEP.WorldModel         = "models/hl1/p_grenade.mdl"

SWEP.Weight             = 5


function SWEP:PullPin()
   if self:GetPin() then return end

   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   self:SendWeaponAnim(ACT_VM_PULLPIN)

   if self.SetHoldType then
      self:SetHoldType(self.HoldReady)
   end

   self:SetPin(true)

   self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

   --if CLIENT and !IsFirstTimePredicted() then
   if SERVER and self.ShoutEnabled then
      self.Owner:EmitSound("cstrike/radio/ct_fireinhole.wav")
   end

   self:SetDetTime(CurTime() + self.detonate_timer)
end

function SWEP:Throw()
   if CLIENT then
      self:SetThrowTime(0)
   elseif SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.was_thrown then return end

      self.was_thrown = true

		local angThrow = self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()

		if angThrow.x < 0 then
			angThrow.x = -10 + angThrow.x * ( ( 90 - 10 ) / 90.0 )
		else
			angThrow.x = -10 + angThrow.x * ( ( 90 + 10 ) / 90.0 )
		end
		local flVel = ( 90 - angThrow.x ) * 4
		if flVel > 500 then
			flVel = 500
      end
      
		local vecSrc = self.Owner:GetShootPos() + angThrow:Forward() * 16
		local vecThrow = angThrow:Forward() * flVel + self.Owner:GetVelocity()

		local flTime = 2

      local entGrenade = ents.Create("ttt_hl1_confgrenade")
      entGrenade:SetOwner(ply)
      entGrenade:SetThrower(ply)
      entGrenade:SetPos(vecSrc)
      entGrenade:SetAngles(vecThrow:Angle())
      entGrenade:Spawn()
      entGrenade:ShootTimed(self.Owner, vecThrow, flTime)

      self:SendWeaponAnim(ACT_HANDGRENADE_THROW1)

      self:SetThrowTime(0)
      --self:Remove()
      self.RemovingSwep = true
      self.NextStripWep = CurTime() + 0.5
      self.IsIdling = false
   end
end

function SWEP:Deploy()

   if self.SetHoldType then
      self:SetHoldType(self.HoldNormal)
   end

   self:SendWeaponAnim(ACT_VM_DRAW)

   self.NextIdleAnim = CurTime() + 0.5
   self.IsIdling = true

   self:SetThrowTime(0)
   self:SetPin(false)
   return true
end

SWEP.RemovingSwep = false
SWEP.NextStripWep = 0

SWEP.IsIdling = true
SWEP.NextIdleAnim = 0

function SWEP:Think()
   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   if self.RemovingSwep and self.NextStripWep < CurTime() then
      self:Remove()
      return
   end

   if self.IsIdling and self.NextIdleAnim < CurTime() then
      self:SendWeaponAnim(ACT_VM_IDLE)
      self.IsIdling = false
   end

   -- pin pulled and attack loose = throw
   if self:GetPin() then
      -- we will throw now
      if not ply:KeyDown(IN_ATTACK) then
         self:StartThrow()

         self:SetPin(false)
         self:SendWeaponAnim(ACT_VM_THROW)

         if SERVER then
            self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
         end
      else
         -- still cooking it, see if our time is up
         if SERVER and self:GetDetTime() < CurTime() then
            self:BlowInFace()
         end
      end
   elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
      self:Throw()
   end
end

function SWEP:GetGrenadeName()
   return "ttt_confgrenade_proj"
end
