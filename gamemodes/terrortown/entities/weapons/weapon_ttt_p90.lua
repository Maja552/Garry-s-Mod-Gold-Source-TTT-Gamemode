AddCSLuaFile()

SWEP.HoldType            = "smg"

if CLIENT then
   SWEP.PrintName        = "p90_name"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = true
   SWEP.ViewModelFOV     = 80

   SWEP.Icon             = "vgui/ttt/icon_p90"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_P90

SWEP.Primary.Damage      = 11
SWEP.Primary.Delay       = 0.0605
SWEP.Primary.Cone        = 0.027
SWEP.Primary.ClipSize    = 50
SWEP.Primary.ClipMax     = 100
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "ammo_new_9mm"
SWEP.Primary.Caliber     = "new_cs_9mm"
SWEP.Primary.Recoil      = 1.5
SWEP.Primary.Sound       = Sound("Weapon_CS_P90.Single")

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/cs/v_p90.mdl"
SWEP.WorldModel          = "models/cs/p_P90.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 1.2

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 12
SWEP.MuzzleFlashSize2 = 40
