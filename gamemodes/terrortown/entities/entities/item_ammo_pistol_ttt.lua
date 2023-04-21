-- Pistol ammo override

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "ammo_new_9mm"
ENT.AmmoAmount = 20
ENT.AmmoMax = 40
ENT.Model = Model("models/halflife_new/w_9mmclip.mdl")
ENT.AutoSpawnable = true
