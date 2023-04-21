AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "ak47_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "ak47_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_ak47"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 2
SWEP.Primary.Damage        = 18
SWEP.Primary.Delay         = 0.11
SWEP.Primary.Cone          = 0.021
SWEP.Primary.ClipSize      = 30
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 30
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "ammo_new_762"
SWEP.Primary.Caliber       = "new_cs_762"
SWEP.Primary.Sound         = Sound("Weapon_CS_AK47.Single")

SWEP.HeadshotMultiplier    = 2

SWEP.DeploySpeed         = 2

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.WeaponID              = AMMO_AK47

SWEP.AmmoEnt             = "item_ammo_new_762_auto_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_ak47.mdl"
SWEP.WorldModel            = "models/cs/p_ak47.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
   return self.BaseClass.Deploy(self)
end

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self:GetOwner()
      buyer:GiveAmmo(60, "ammo_new_762")
   end
end

SWEP.MuzzleFlashSize1 = 22
SWEP.MuzzleFlashSize2 = 40
