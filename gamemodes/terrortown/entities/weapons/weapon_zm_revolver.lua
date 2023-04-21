AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "deagle_name"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE

SWEP.Primary.Ammo          = "ammo_new_50"
SWEP.Primary.Caliber       = "new_cs_50"
SWEP.Primary.Recoil        = 6
SWEP.Primary.Damage        = 33
SWEP.Primary.Delay         = 0.5
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 32
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound( "Weapon_CS_DEagle.Single" )

SWEP.HeadshotMultiplier    = 2.5

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_deagle.mdl"
SWEP.WorldModel            = "models/cs/p_deagle.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 21
SWEP.MuzzleFlashSize2 = 15
