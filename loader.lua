-- loader.lua — Recharge le script 175 après REJOIN
task.wait(1.5)

local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pjdojefoejhfuh/ad/refs/heads/main/rejoni%20flash"))()
end)

if not ok then
    warn("[175 Loader] ❌ Erreur :", tostring(err))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "175 Loader",
            Text = "Erreur de rechargement",
            Duration = 5
        })
    end)
else
    print("[175 Loader] ✅ Script rechargé avec succès")
end
