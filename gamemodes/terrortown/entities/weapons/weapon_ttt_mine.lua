
-- traitor equipment: c4 bomb

AddCSLuaFile()

SWEP.HoldType               = "slam"

if CLIENT then
   SWEP.PrintName           = "Trip Mine"
   SWEP.Slot                = 6
   
   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80
   SWEP.DrawCrosshair      = false

   SWEP.EquipMenuData = {
      type  = "item_weapon",
      desc  = "tripmine_desc"
   };

   SWEP.Icon                = "vgui/ttt/icon_tripmine"
   SWEP.IconLetter          = "I"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.Kind                   = WEAPON_EQUIP
SWEP.CanBuy                 = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID               = AMMO_C4

SWEP.UseHands               = true
SWEP.ViewModel              = Model("models/hl1/c_tripmine.mdl")
SWEP.WorldModel             = Model("models/hl1/p_tripmine.mdl")

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.NoSights               = true

SWEP.RemovingSwep = false
SWEP.NextStripWep = 0

function SWEP:Think()
   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   if SERVER and self.RemovingSwep and self.NextStripWep < CurTime() then
      self:Remove()
      return
   end
end

function SWEP:PrimaryAttack()
	local vecSrc = self.Owner:GetShootPos()
	local vecAiming = self.Owner:GetAimVector():Angle():Forward()

	local tr = util.TraceLine({
		start = vecSrc,
		endpos = vecSrc + vecAiming * 128,
		filter = self.Owner
	})
	
	if tr.Fraction < 1 then
		local pEntity = tr.Entity
		if pEntity && !pEntity:IsFlagSet(FL_CONVEYOR) then
			local angles = tr.HitNormal:Angle()			
			if SERVER then
				local pEnt = ents.Create("ttt_hl1_monster_tripmine")
				if IsValid(pEnt) then
					pEnt:SetPos(tr.HitPos + tr.HitNormal * 8)
					pEnt:SetAngles(angles)
					pEnt:SetOwner(self.Owner)
					pEnt.WeaponClass = self:GetClass()
					pEnt:Spawn()
				end
			end			
			--if self:rgAmmo() > 0 then
			--	self:SendWeaponAnim(ACT_VM_DRAW)
			--else
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			--end
         self.Owner:SetAnimation(PLAYER_ATTACK1)

         self.RemovingSwep = true
         self.NextStripWep = CurTime() + 0.5
		end
	end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW)

   return true
end

