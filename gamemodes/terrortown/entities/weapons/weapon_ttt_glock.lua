AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "glock_name"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.Icon               = "vgui/ttt/icon_glock"
   SWEP.IconLetter         = "c"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 0.9
SWEP.Primary.Damage        = 12
SWEP.Primary.Delay         = 0.10
SWEP.Primary.Cone          = 0.028
SWEP.Primary.NumShots      = 1
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "ammo_new_9mm"
SWEP.Primary.Caliber       = "new_cs_9mm"
SWEP.Primary.Sound         = Sound("Weapon_CS_Glock.Single")

SWEP.AutoSpawnable         = true

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_GLOCK

SWEP.HeadshotMultiplier    = 1.75

SWEP.UseHands              = true
--SWEP.ViewModel             = "models/cs/v_glock18.mdl"
SWEP.ViewModel             = "models/weapons/cs16/c_glock18.mdl"
SWEP.WorldModel            = "models/cs/p_glock18.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.MuzzleFlashSize1 = 15
SWEP.MuzzleFlashSize2 = 10

SWEP.FiringMode = 1
SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK

SWEP.NextBurst = 0
SWEP.BurstNum = 0
SWEP.IsBursting = false
SWEP.BurstDelay = 0.1

SWEP.Secondary.Sound = Sound("Weapon_CS_Glock.Single2")
SWEP.Secondary.Delay = 0.6
SWEP.Secondary.Damage = 12
SWEP.Secondary.Cone = 0.04
SWEP.Secondary.Recoil = 1.3

function SWEP:PrimaryShoot()
   if !self.IsBursting then
      self.NextBurst = CurTime() + self.BurstDelay
      self.BurstNum = 2
      self.IsBursting = true
   end

   self:ShootBullet(self.Secondary.Damage, self.Secondary.Recoil, 1, self.Secondary.Cone)
   self:TakePrimaryAmmo(1)

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self.Secondary.Recoil, util.SharedRandom(self:GetClass(), -0.1, 0.1, 1) * self.Primary.Recoil, 0))
end

function SWEP:Think()
   if self.IsBursting and self.NextBurst < CurTime() and self:Clip1() > 0 then
      self.BurstNum = self.BurstNum - 1
      self.NextBurst = CurTime() + self.BurstDelay
      self:PrimaryShoot()

      if self.BurstNum < 1 then
         self.IsBursting = false
         self.NextBurst = 0
         self.BurstNum = 0
         return
      end
   end
end

function SWEP:PrimaryAttack()
   if self.FiringMode == 1 then
      self.BaseClass.PrimaryAttack(self)
      return
   end

   if not self:CanPrimaryAttack() then return end

   self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
   self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)

   self:PrimaryShoot()
   self:EmitSound(self.Secondary.Sound, self.Secondary.SoundLevel)
end

function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   if self.FiringMode == 1 then
      self.FiringMode = 2
      self.SecondaryAnim = ACT_VM_SECONDARYATTACK
      self.Primary.Cone = self.Secondary.Cone
      self.HeadshotMultiplier = 2
   else
      self.FiringMode = 1
      self.SecondaryAnim = ACT_VM_PRIMARYATTACK
      self.Primary.Cone = 0.028
      self.HeadshotMultiplier = 2.2
   end

   self:SetNextSecondaryFire(CurTime() + 0.2)
end
