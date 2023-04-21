AddCSLuaFile()

SWEP.HoldType              = "revolver"

if CLIENT then
   SWEP.PrintName          = "revolver_name"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 90

   SWEP.Icon               = "vgui/ttt/icon_revolver"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_REVOLVER

SWEP.Primary.Ammo          = "ammo_new_50"
SWEP.Primary.Caliber       = "new_cs_50"
SWEP.Primary.Recoil        = 6
SWEP.Primary.Damage        = 39
SWEP.Primary.Delay         = 0.6
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 6
SWEP.Primary.ClipMax       = 24
SWEP.Primary.DefaultClip   = 24
SWEP.Primary.Automatic     = true

SWEP.HeadshotMultiplier    = 2.5

SWEP.AutoSpawnable         = false
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = Model("models/hl1/c_357.mdl")
SWEP.WorldModel            = Model("models/hl1/p_357.mdl")

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 21
SWEP.MuzzleFlashSize2 = 15

function SWEP:PrimaryAttack(worldsnd)
   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   self.Primary.Sound = "weapons/357/357_shot"..math.random(1,2)..".wav"

   if not worldsnd then
      self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel, 100, 0.4, CHAN_WEAPON)
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end
