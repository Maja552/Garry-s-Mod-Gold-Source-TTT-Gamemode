AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "famas_name"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = true
   SWEP.ViewModelFOV     = 80

   SWEP.Icon             = "vgui/ttt/icon_famas"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_FAMAS

SWEP.Primary.Damage      = 17
SWEP.Primary.Delay       = 0.4
SWEP.Primary.Cone        = 0.02
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "ammo_new_556"
SWEP.Primary.Caliber     = "new_cs_556"
SWEP.Primary.Recoil      = 1
SWEP.Primary.Sound       = Sound("Weapon_CS_FAMAS.Single")

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_new_556_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/cs/v_famas.mdl"
SWEP.WorldModel          = "models/cs/p_famas.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 1.6

SWEP.NextBurst = 0
SWEP.BurstNum = 0
SWEP.IsBursting = false

SWEP.BurstDelay = 0.1

function SWEP:CanPrimaryAttack()
   if not IsValid(self:GetOwner()) then return end

   if self:Clip1() <= 0 then
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end

   --if self.IsBursting and self.NextBurst > CurTime() then return end

   return true
end

function SWEP:PrimaryAttack()
   self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

   if not self:CanPrimaryAttack() then return end

   self:PrimaryShoot()
end

function SWEP:PrimaryShoot()

   if !self.IsBursting then
      self.NextBurst = CurTime() + self.BurstDelay
      self.BurstNum = 2
      self.IsBursting = true
   end

   self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)

   self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
   self:TakePrimaryAmmo(1)

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(), -0.1, 0.1, 1) * self.Primary.Recoil, 0))
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

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 22
SWEP.MuzzleFlashSize2 = 30
