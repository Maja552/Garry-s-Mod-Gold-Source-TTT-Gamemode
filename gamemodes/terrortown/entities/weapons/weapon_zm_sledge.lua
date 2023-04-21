AddCSLuaFile()

SWEP.HoldType              = "crossbow"

if CLIENT then
   SWEP.PrintName          = "m249_name"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.Icon               = "vgui/ttt/icon_m249"
   SWEP.IconLetter         = "z"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Spawnable             = true
SWEP.AutoSpawnable         = true

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M249

SWEP.Primary.Damage        = 9
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Cone          = 0.035
SWEP.Primary.ClipSize      = 100
SWEP.Primary.ClipMax       = 0
SWEP.Primary.DefaultClip   = 100
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "ammo_new_556"
SWEP.Primary.Recoil        = 1.7
SWEP.Primary.Sound         = Sound( "Weapon_CS_M249.Single" )

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_m249.mdl"
--SWEP.WorldModel            = "models/weapons/w_mach_m249para.mdl"
SWEP.WorldModel            = "models/cs/p_m249.mdl"

SWEP.HeadshotMultiplier    = 2.2

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 22
SWEP.MuzzleFlashSize2 = 50
