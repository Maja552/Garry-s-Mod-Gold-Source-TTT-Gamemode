AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "fiveseven_name"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.Icon               = "vgui/ttt/icon_pistol"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Damage        = 13
SWEP.Primary.Delay         = 0.25
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "ammo_new_57"
SWEP.Primary.Caliber       = "new_cs_57"
SWEP.Primary.Sound         = Sound( "Weapon_CS_FiveSeven.Single" )

SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_ammo_new_57_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_fiveseven.mdl"
SWEP.WorldModel            = "models/cs/p_fiveseven.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 11
SWEP.MuzzleFlashSize2 = 10
