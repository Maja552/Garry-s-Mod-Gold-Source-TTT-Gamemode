AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "sipistol_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "sipistol_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_silenced"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 1.35
SWEP.Primary.Damage        = 23
SWEP.Primary.Delay         = 0.2
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = false
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "ammo_new_45"
SWEP.Primary.Caliber       = "new_cs_45"
SWEP.Primary.Sound         = Sound( "Weapon_CS_USP.SingleSilenced" )
SWEP.Primary.SoundLevel    = 50

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID              = AMMO_SIPISTOL

SWEP.AmmoEnt               = "item_ammo_new_45_ttt"
SWEP.IsSilent              = true

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_usp.mdl"
SWEP.WorldModel            = "models/cs/p_usp.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.PrimaryAnim           = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim            = ACT_VM_RELOAD_SILENCED

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return self.BaseClass.Deploy(self)
end

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self:GetOwner()
      buyer:GiveAmmo( 20, "ammo_new_45" )
   end
end

function SWEP:SecondaryAttack()
end

SWEP.MuzzleFlashSize1 = 11
SWEP.MuzzleFlashSize2 = 10
