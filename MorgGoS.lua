if GetObjectName(myHero) ~= "Morgana" then return end

local ver = "0.02"
local MorgQ = {delay = 0.45, speed = 1200, width = 60, range = 1175}

require("Analytics")

Analytics("Troopgana", "trooperhdx")


require("OpenPredict")

require("DamageLib")


function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        print("New version found! " .. data)
        print("Downloading update, wait a moment...")
        DownloadFileAsync("https://raw.githubusercontent.com/TrooperHDxLeagueSharp/GoS/master/MorgGoS.lua", SCRIPT_PATH .. "MorgGoS.lua", function() print("Update Complete, please 2x F6!") return end)
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/TrooperHDxLeagueSharp/GoS/master/MorgGoS.lua", AutoUpdate)

local MorganaGoS = Menu("Morgana", "Morgana")
MorganaGoS("Combo", "Combo")
MorganaGoS:Boolean("QComb", "Use Q", true)
MorganaGoS:Boolean("WCom", "Use W", true)
MorganaGoS:Boolean("RComb", "Use R", true)
MorganaGoS:Slider("MinMana", "Min Mana To Combo",50,0,100,1)

MorganaGoS:SubMenu("Harass", "Harass", true)
MorganaGoS.Harass:Boolean("WHarass", "Use W", true)
MorganaGoS.Harass:Slider("MinManaHarass", "Min Mana To Harass",50,0,100,1)

MorganaGoS:SubMenu("LaneClear", "LaneClear", true)
MorganaGoS.LaneClear:Boolean("Qlc", "Use Q", true)
MorganaGoS.LaneClear:Boolean("Wlc", "Use W", true)
MorganaGoS.LaneClear:Slider("WMin", "Min Minions To R",9,1,15,1)
MorganaGoS.LaneClear:Slider("MinManaLC", "Min Mana To LaneClear",50,0,100,1)

MorganaGoS:SubMenu("Misc", "Misc")
MorganaGoS:Boolean("UltX", "Auto R on X Enemies", true)
MorganaGoS.Misc:Slider("EnemieR", "Min Enemies to Auto R",3,1,6,1)
MorganaGoS.Misc:Boolean("Lvlup", "Use Auto Level", true)
MorganaGoS.Misc:Boolean("Ig", "Use Auto Ignite", true)

MorganaGoS:SubMenu("SkinChanger", "SkinChanger")

local skinMeta = {["Morgana"] = {"Classic", "Blade-Mistress", "Blackthorn", "Ghost-Bridge", "Exiled", "Sinful-Succulence", "Lumar-Wraith", "Bewitchintg", "Victorious"}}
MorganaGoS.SkinChanger:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], HeroSkinChanger, true)
MorganaGoS.SkinChanger.skin.callback = function(model) HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") end

MorganaGoS:SubMenu("Draw", "Drawings")
MorganaGoS.Draw:Boolean("DrawQ", "Draw Q Range", true)
MorganaGoS.Draw:Boolean("DrawW", "Draw W Range", true)
MorganaGoS.Draw:Boolean("DrawE", "Draw E Range", true)
MorganaGoS.Draw:Boolean("DrawR", "Draw R Range", true)

OnTick(function ()
	
	local IgDamage = (50 + (20 * GetLevel(myHero)))
	local RStats = {delay = 0.050, range = 1000, radius = 300, speed = 1500 + GetMoveSpeed(myHero)}
	local GetPercentMana = (GetCurrentMana(myHero) / GetMaxMana(myHero)) * 100
	local target = GetCurrentTarget()
	
	if MorganaGoS.Misc.Lvlup:Value() then
		spellorder = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}	
		if GetLevelPoints(myHero) > 0 then
			LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
		end
	end

	if Mode() == "Combo" then
		
		if MorganaGoS.Combo.QComb:Value() and Ready(_Q) and ValidTarget(target, 1175) then
				if MorganaGoS.Combo.MinMana:Value() <= GetPercentMana then 
					CastSkillShot(target, _Q)	
				end
			end
		end	

		if MorganaGoS.Combo.WComb:Value() and Ready(_W) and ValidTarget(target, 900) then
			if MorganaGoS.Combo.MinMana:Value() <= GetPercentMana then
					CastTargetSpell(_W)
				end	
			end
		end

		if MorganaGoS.Combo.RComb:Value() and Ready(_R) and ValidTarget(target, 400) then
				if MorganaGoS.Combo.MinMana:Value() <= GetPercentMana then 
					CastSpell(target, _R)	
				end
			end
		end	
	end
	
	if Mode() == "Harass" then
		
		if MorganaGoS.Harass.WHarass:Value() and Ready(_W) and ValidTarget(target, 900) then
			if MorganaGoS.Harass.MinManaHarass:Value() <= GetPercentMana then
				CastTargetSpell(target, _W)
			end
		end
	
	end

if Mode() == "LaneClear" then
		
		for _, closeminion in pairs(minionManager.objects) do
			if MorganaGoS.LaneClear.Qlc:Value() and ValidTarget(closeminion, 1125) then
				if GetPercentMP(myHero) >= MorganaGoS.LaneClear.MinManaLC:Value() then
					CastSkillShot(_Q, closeminion)
				end
			end
			

			if MorganaGoS.LaneClear.Wlc:Value() and ValidTarget(closeminion, 900) >= MorganaGoS.LaneClear.WMin:Value() then
				if GetPercentMP(myHero) >= MorganaGoS.LaneClear.MinManaLC:Value() then
					CastSkillShot(_W, closeminion)
				end
			end
		end
		
end


	for _, enemy in pairs(GetEnemyHeroes()) do
			--AutoR
		if MorganaGoS.Misc.UltX:Value() and Ready(_R) and ValidTarget(enemy, 1000) and EnemiesAround(enemy, 300) >= MorganaGoS.Misc.EnemirR:Value() then
				CastTargetSpell(enemy, _R)
			end	
		end
			--Auto Ignite 
		if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
			if MorganaGoS.Misc.Ig:Value() and Ready(SUMMONER_1) and ValidTarget(enemy, 600) then
				if GetCurrentHP(enemy) < IgDamage then
					CastTargetSpell(enemy, SUMMONER_1)
				end
			end
		end
	
		if GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
			if MorganaGoS.Misc.Ig:Value() and Ready(SUMMONER_2) and ValidTarget(enemy, 600) then
				if GetCurrentHP(enemy) < IDamage then
					CastTargetSpell(enemy, SUMMONER_2)
				end
			end
		end
	end

end)


OnDraw(function(myHero)
	local pos = GetOrigin(myHero)
	local mpos = GetMousePos()
	if MorganaGoS.Draw.DrawQ:Value() then DrawCircle(pos, 1125, 1, 25, GoS.Red) end
	if MorganaGoS.Draw.DrawW:Value() then DrawCircle(pos, 900, 1, 25, GoS.Blue) end
	if MorganaGoS.Draw.DrawE:Value() then DrawCircle(pos, 600, 1, 25, GoS.Blue) end
	if MorganaGoS.Draw.DrawR:Value() then DrawCircle(pos, 600, 1, 25, GoS.Green) end
end)	



print("Well thats my first GoS Script , have fun!!")