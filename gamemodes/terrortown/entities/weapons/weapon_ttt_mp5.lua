AddCSLuaFile()

SWEP.HoldType            = "smg"

if CLIENT then
   SWEP.PrintName        = "mp5_name"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = true
   SWEP.ViewModelFOV     = 80

   SWEP.Icon             = "vgui/ttt/icon_mp5"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_MP5

SWEP.Primary.Damage      = 12
SWEP.Primary.Delay       = 0.09
SWEP.Primary.Cone        = 0.019
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "ammo_new_9mm"
SWEP.Primary.Caliber     = "new_cs_9mm"
SWEP.Primary.Recoil      = 1.25
SWEP.Primary.Sound       = Sound( "Weapon_CS_MP5Navy.Single" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/cs/v_mp5.mdl"
SWEP.WorldModel          = "models/cs/p_mp5.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 1.4

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 11
SWEP.MuzzleFlashSize2 = 30
