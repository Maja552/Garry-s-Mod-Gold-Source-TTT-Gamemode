AddCSLuaFile()

SWEP.HoldType              = "ar2"

if CLIENT then
   SWEP.PrintName          = "sg552_name"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = true
   SWEP.ViewModelFOV       = 80

   SWEP.Icon               = "vgui/ttt/icon_sg552"
   SWEP.IconLetter         = "n"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_SG552

SWEP.Primary.Delay         = 0.095
SWEP.Primary.Recoil        = 2.2
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "ammo_new_556"
SWEP.Primary.Caliber       = "new_cs_556"
SWEP.Primary.Damage        = 11
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 30
SWEP.Primary.ClipMax       = 90 -- keep mirrored to ammo
SWEP.Primary.DefaultClip   = 30
SWEP.Primary.Sound         = Sound( "Weapon_CS_SG552.Single" )

SWEP.Secondary.Sound       = Sound("Default.Zoom")

SWEP.HeadshotMultiplier    = 1.7

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_new_556_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = Model("models/cs/v_sg552.mdl")
SWEP.WorldModel            = Model("models/cs/p_sg552.mdl")

SWEP.IronSightsPos         = Vector(5, -15, -2)
SWEP.IronSightsAng         = Vector(2.6, 1.37, 3.5)

SWEP.FiringMode = 2

function SWEP:SetFiringMode1()
   self.FiringMode = 1
   self.Primary.Delay = 0.22
   self.Primary.Damage = 23
   self.HeadshotMultiplier = 2.2
   self.Primary.Cone = 0.01
   self.Primary.Recoil = 2
end

function SWEP:SetFiringMode2()
   self.FiringMode = 2
   self.Primary.Delay = 0.095
   self.Primary.Damage = 11
   self.HeadshotMultiplier = 1.7
   self.Primary.Cone = 0.02
   self.Primary.Recoil = 2.2
end

function SWEP:SetZoom(state)
   if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
      if state then
         self:GetOwner():SetFOV(40, 0.3)
         self:SetFiringMode1()
      else
         self:GetOwner():SetFOV(0, 0.2)
         self:SetFiringMode2()
      end
   end
end

function SWEP:Deploy()
   self:SetFiringMode2()
end

function SWEP:PrimaryAttack( worldsnd )
   self.BaseClass.PrimaryAttack( self.Weapon, worldsnd )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetZoom(bIronsights)
   if (CLIENT) then
      self:EmitSound(self.Secondary.Sound)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   self:SetZoom( false )
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   self:SetFiringMode1()
   return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

SWEP.MuzzleFlashSize1 = 22
SWEP.MuzzleFlashSize2 = 30
