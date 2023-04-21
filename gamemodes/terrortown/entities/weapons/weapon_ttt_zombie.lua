AddCSLuaFile()

SWEP.HoldType                = "knife"

if CLIENT then
   SWEP.PrintName            = "zombie_name"
   SWEP.Slot                 = 0

   SWEP.DrawCrosshair        = false
   SWEP.ViewModelFlip        = false
   SWEP.ViewModelFOV         = 80

   SWEP.Icon                 = "vgui/ttt/icon_zombie"
end

SWEP.Base                    = "weapon_tttbase"

SWEP.UseHands                = true
--SWEP.ViewModel               = Model("models/weapons/v_zombiearms.mdl")
SWEP.ViewModel               = Model("models/v_knife_zombie.mdl")
SWEP.WorldModel              = "models/hl1/p_crowbar.mdl"

SWEP.Primary.Damage          = 35
SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip     = -1
SWEP.Primary.Automatic       = true
SWEP.Primary.Delay           = 0.4
SWEP.Primary.Ammo            = "none"

SWEP.Secondary.ClipSize      = -1
SWEP.Secondary.DefaultClip   = -1
SWEP.Secondary.Automatic     = true
SWEP.Secondary.Ammo          = "none"
SWEP.Secondary.Delay         = 5

SWEP.Kind                    = WEAPON_MELEE
SWEP.WeaponID                = AMMO_ZOMBIE
SWEP.InLoadoutFor            = {ROLE_ZOMBIE}

SWEP.NoSights                = true
SWEP.IsSilent                = true

SWEP.Weight                  = 5
SWEP.AutoSpawnable           = false

SWEP.AllowDelete             = false -- never removed for weapon reduction
SWEP.AllowDrop               = false

SWEP.UseHands                = false

SWEP.MissSound = Sound("hl1/weapons/cbar_miss1.wav")

local flesh_mats = {
   MAT_FLESH,
   MAT_BLOODYFLESH,
   MAT_ALIENFLESH,
   MAT_ANTLION
}

SWEP.ViewModel_AnimSpeed = 1
SWEP.WorldModel_AnimSpeed = 2
SWEP.Next3DAnim = 0

function SWEP:DrawWorldModel()
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

   if not IsValid(self:GetOwner()) then return end

   if self:GetOwner().LagCompensation then -- for some reason not always true
      self:GetOwner():LagCompensation(true)
   end

   self:SetHoldType("knife")
   self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

   self:GetOwner():SetAnimation(PLAYER_ATTACK1)

   if self.Next3DAnim < CurTime() then
      --self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)
      self.Next3DAnim = CurTime() + 1.1
   end

   self.Owner:GetViewModel():SetPlaybackRate(self.ViewModel_AnimSpeed)
   --self:GetWeaponWorldModel():SetPlaybackRate(self.WorldModel_AnimSpeed)

   local spos = self:GetOwner():GetShootPos()
   local sdest = spos + (self:GetOwner():GetAimVector() * 70)

   local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT_HULL})
   local hitEnt = tr_main.Entity

   if IsValid(hitEnt) or tr_main.HitWorld then

      local player_or_body = hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll"

      self.Weapon:EmitSound("zombie/claw_strike"..math.random(1,3)..".wav")

      if not (CLIENT and (not IsFirstTimePredicted())) then
         local edata = EffectData()
         edata:SetStart(spos)
         edata:SetOrigin(tr_main.HitPos)
         edata:SetNormal(tr_main.Normal)
         edata:SetSurfaceProp(tr_main.SurfaceProps)
         edata:SetHitBox(tr_main.HitBox)
         --edata:SetDamageType(DMG_CLUB)
         edata:SetEntity(hitEnt)

         if player_or_body then
            util.Effect("BloodImpact", edata)

            self:GetOwner():LagCompensation(false)
            self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
         --else
            --util.Effect("Impact", edata)
         end
      end
   else
      self.Weapon:EmitSound("zombie/claw_miss"..math.random(1,2)..".wav")
   end


   if SERVER then
      local tr_all = nil
      tr_all = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner()})
   
      if hitEnt and hitEnt:IsValid() then
         local dmg = DamageInfo()
         dmg:SetDamage(self.Primary.Damage)
         dmg:SetAttacker(self:GetOwner())
         dmg:SetInflictor(self.Weapon)
         dmg:SetDamageForce(self:GetOwner():GetAimVector() * 1500)
         dmg:SetDamagePosition(self:GetOwner():GetPos())
         dmg:SetDamageType(DMG_CLUB)

         hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
      end
   end

   if self:GetOwner().LagCompensation then
      self:GetOwner():LagCompensation(false)
   end

   self.NextIdleAnim = CurTime() + self.Owner:GetViewModel():SequenceDuration() + math.Rand(1,2)
end

function SWEP:SecondaryAttack()
end

function SWEP:GetClass()
	return "weapont_ttt_zombie"
end

SWEP.IdleSounds = {
   "gsttt/zombie/zombie_brains1.wav",
   "gsttt/zombie/zombie_brains2.wav",
   "npc/zombie/zombie_alert1.wav",
   "npc/zombie/zombie_alert2.wav",
   "npc/zombie/zombie_alert3.wav",
   "npc/zombie/zombie_voice_idle5.wav",
   "npc/zombie/zombie_voice_idle7.wav",
   "npc/zombie/zombie_voice_idle8.wav",
   "npc/zombie/zombie_voice_idle11.wav",
   "npc/zombie/zombie_voice_idle14.wav"
}

SWEP.NextZSound = 0

function SWEP:Deploy()
   self.NextZSound = CurTime() + 5
   self.NextIdleAnim = CurTime() + 2
end

SWEP.NextIdleAnim = 0


function SWEP:Think()
   if SERVER and self.NextZSound < CurTime() then
      local pl = self.Owner
      local zsound = ""
      local znext = 0
      if pl:IsFlagSet(FL_ONFIRE) then
         zsound = "gsttt/zombie/zombie_burn"..math.random(3,7)..".wav"
         znext = math.random(1, 2)
      else
         zsound = table.Random(self.IdleSounds)
         znext = math.random(8, 18)
      end
      pl:EmitSound(zsound)

      --print("zsound", CurTime())

      self.NextZSound = CurTime() + znext
   end

   if SERVER and self.NextIdleAnim < CurTime() then
      self.NextIdleAnim = CurTime() + self.Owner:GetViewModel():SequenceDuration() + math.Rand(2,3)
      self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
   end
end


function SWEP:OnDrop()
	self:Remove()
end
