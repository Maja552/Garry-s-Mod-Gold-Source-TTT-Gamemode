AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "goldendeagle_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "goldendeagle_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_goldendeagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.WeaponID              = AMMO_GDEAGLE
SWEP.LimitedStock          = true

SWEP.Primary.Ammo          = "ammo_gld"
SWEP.Primary.Caliber       = "new_cs_50"
SWEP.Primary.Recoil        = 6
SWEP.Primary.Damage        = 200
SWEP.Primary.Delay         = 1
SWEP.Primary.Cone          = 0.01
SWEP.Primary.ClipSize      = 5
SWEP.Primary.ClipMax       = 5
SWEP.Primary.DefaultClip   = 5
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_CS_DEagle.Single")

SWEP.HeadshotMultiplier    = 1

SWEP.UseHands              = true
SWEP.ViewModel             = "models/v_deagle_gold.mdl"
SWEP.WorldModel            = "models/cs/p_deagle.mdl"

SWEP.IronSightsPos       = Vector(3, -1, 3)
SWEP.IronSightsAng       = Vector(0, 0, 0)

SWEP.IsGoldenDeagle      = true

function SWEP:PrimaryAttack(worldsnd)
/*
   local ist = self.Owner:IsTraitor()
   local trc_ent = self.Owner:GetEyeTrace().Entity
   if !IsValid(trc_ent) or !trc_ent:IsPlayer() or ((!ist and trc_ent:IsDetective()) or (ist and trc_ent:IsTraitor())) then
      return
   end
*/

   self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:TakePrimaryAmmo(1)

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0))

   self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
end


function SWEP:PreDrop()
   self:SetMaterial("cs/models/p_deagle_gold/deserteagle_skin")
   return self.BaseClass.PreDrop(self)
end
