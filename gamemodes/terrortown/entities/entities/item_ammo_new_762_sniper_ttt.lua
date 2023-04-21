-- Pistol ammo override

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "ammo_new_762"
ENT.AmmoAmount = 10
ENT.AmmoMax = 20
ENT.Model = Model("models/halflife_new/w_m40a1clip.mdl")
ENT.AutoSpawnable = true
