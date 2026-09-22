task.wait(2)

-- Vérifie que les fonctions existent
local ls = loadstring or load
local httpget = game.HttpGet or game.HttpGetAsync

if not ls then
    warn("[175 Loader] ❌ loadstring est nil")
    return
end

if not httpget then
    warn("[175 Loader] ❌ HttpGet est nil")
    return
end

-- Télécharge le script
local ok, code = pcall(function()
    return httpget(game, "https://raw.githubusercontent.com/Pjdojefoejhfuh/ad/refs/heads/main/rejoni%20flash")
end)

if not ok or not code then
    warn("[175 Loader] ❌ Téléchargement échoué :", tostring(code))
    return
end

print("[175 Loader] Téléchargé :", #code, "octets")

-- Compile
local fn, err = ls(code)
if not fn then
    warn("[175 Loader] ❌ Compilation échouée :", tostring(err))
    return
end

-- Exécute
local ok2, err2 = pcall(fn)
if not ok2 then
    warn("[175 Loader] ❌ Exécution échouée :", tostring(err2))
    return
end

print("[175 Loader] ✅ Script rechargé avec succès !")
