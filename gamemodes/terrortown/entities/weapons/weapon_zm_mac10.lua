AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "mac10_name"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = true
   SWEP.ViewModelFOV     = 80

   SWEP.Icon             = "vgui/ttt/icon_mac"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_MAC10

SWEP.Primary.Damage      = 11
SWEP.Primary.Delay       = 0.065
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "ammo_new_45"
SWEP.Primary.Caliber     = "new_cs_45"
SWEP.Primary.Recoil      = 1.3
SWEP.Primary.Sound       = Sound( "Weapon_CS_MAC10.Single" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_new_45_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/cs/v_mac10.mdl"
SWEP.WorldModel          = "models/cs/p_mac10.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.DeploySpeed         = 3

SWEP.HeadshotMultiplier    = 1.3

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 11
SWEP.MuzzleFlashSize2 = 10
