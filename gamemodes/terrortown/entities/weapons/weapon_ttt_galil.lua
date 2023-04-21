AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "galil_name"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 70

   SWEP.Icon               = "vgui/ttt/icon_galil"
   SWEP.IconLetter         = "g"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_GALIL

SWEP.Primary.Delay         = 0.11
SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "ammo_new_556"
SWEP.Primary.Caliber       = "new_cs_556"
SWEP.Primary.Damage        = 12
SWEP.Primary.Cone          = 0.023
SWEP.Primary.ClipSize      = 40
SWEP.Primary.ClipMax       = 120
SWEP.Primary.DefaultClip   = 40
SWEP.Primary.Sound         = Sound("Weapon_CS_GALIL.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_new_556_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_galil.mdl"
SWEP.WorldModel            = "models/cs/p_galil.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 1.7

SWEP.MuzzleFlashSize1 = 22
SWEP.MuzzleFlashSize2 = 30

function SWEP:SecondaryAttack()
end
