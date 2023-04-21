AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "tmp_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "tmp_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_tmp"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 1.25
SWEP.Primary.Damage        = 13
SWEP.Primary.Delay         = 0.08
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 40
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 40
SWEP.Primary.ClipMax       = 80
SWEP.Primary.Ammo          = "ammo_new_9mm"
SWEP.Primary.Caliber       = "new_cs_9mm"
SWEP.Primary.Sound         = Sound( "Weapon_CS_TMP.Single" )
SWEP.Primary.SoundLevel    = 50

SWEP.HeadshotMultiplier    = 1.3

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID              = AMMO_TMP

SWEP.AmmoEnt             = "item_ammo_smg1_ttt"
SWEP.IsSilent              = true

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_tmp.mdl"
SWEP.WorldModel            = "models/cs/p_tmp.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.PrimaryAnim           = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim            = ACT_VM_RELOAD

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW)
   return self.BaseClass.Deploy(self)
end

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self:GetOwner()
      buyer:GiveAmmo( 30, "ammo_new_9mm" )
   end
end

SWEP.MuzzleFlashSize1 = 11
SWEP.MuzzleFlashSize2 = 10
