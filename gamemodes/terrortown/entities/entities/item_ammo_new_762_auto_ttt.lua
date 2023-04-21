-- Pistol ammo override

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "ammo_new_762"
ENT.AmmoAmount = 30
ENT.AmmoMax = 60
ENT.Model = Model("models/halflife_new/w_9mmar2clip.mdl")
ENT.AutoSpawnable = true


function ENT:Initialize()
    self:SetColor(Color(255, 100, 100, 255))
 
    return self.BaseClass.Initialize(self)
 end
 
