AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "m4a1_name"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.Icon               = "vgui/ttt/icon_m16"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M16

SWEP.Primary.Delay         = 0.1
SWEP.Primary.Recoil        = 1.4
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "ammo_new_556"
SWEP.Primary.Caliber       = "new_cs_556"
SWEP.Primary.Damage        = 13
SWEP.Primary.Cone          = 0.019
SWEP.Primary.ClipSize      = 30
SWEP.Primary.ClipMax       = 90
SWEP.Primary.DefaultClip   = 30
SWEP.Primary.Sound         = Sound("Weapon_CS_M4A1.Single")

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_new_556_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/cs/v_m4a1.mdl"
SWEP.WorldModel            = "models/cs/p_m4a1.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.HeadshotMultiplier    = 1.7

function SWEP:SetZoom(state)
   if not (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer()) then return end
   if state then
      self:GetOwner():SetFOV(35, 0.5)
   else
      self:GetOwner():SetFOV(0, 0.2)
   end
end

-- Add some zoom to ironsights for this gun

SWEP.NextSilencerChange = 0

SWEP.Silencer = 0
SWEP.Secondary.Delay = 2.5

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.DeployAnim = ACT_VM_DRAW

function SWEP:SecondaryAttack()
   if !IsFirstTimePredicted() or self.NextSilencerChange > CurTime() or self.Owner:GetRole() == ROLE_INNOCENT or GetRoundState() == ROUND_PREP then return end

   self.NextSilencerChange = CurTime() + self.Secondary.Delay

   if self.Silencer == 0 then
      self.Weapon:SendWeaponAnim( ACT_VM_ATTACH_SILENCER )
      self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
      self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

      self.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
      self.ReloadAnim = ACT_VM_RELOAD_SILENCED
      self.DeployAnim = ACT_VM_DRAW_SILENCED
      self.Primary.SoundLevel = 50
      self.Primary.Sound = Sound("Weapon_CS_M4A1.SingleSilenced")

      self.MuzzleFlashSize1 = 11
      self.Silencer = 1
   else
      self.Weapon:SendWeaponAnim( ACT_VM_DETACH_SILENCER )
      self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
      self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

      self.PrimaryAnim = ACT_VM_PRIMARYATTACK
      self.ReloadAnim = ACT_VM_RELOAD
      self.DeployAnim = ACT_VM_DRAW
      self.Primary.SoundLevel = nil
      self.Primary.Sound = Sound("Weapon_CS_M4A1.Single")

      self.MuzzleFlashSize1 = 22
      self.Silencer = 0
   end
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
   if (self:Clip1() == self.Primary.ClipSize or
      self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0) then
      return
   end
   self:DefaultReload(self.ReloadAnim)
   self:SetIronsights(false)
   self:SetZoom(false)

   self.NextSilencerChange = CurTime() + self.Secondary.Delay
end

function SWEP:Deploy()
   self:SendWeaponAnim(self.DeployAnim)
   self.NextSilencerChange = 0
   self:SetIronsights(false)
   return true
end

function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

SWEP.MuzzleFlashSize1 = 22
SWEP.MuzzleFlashSize2 = 30
