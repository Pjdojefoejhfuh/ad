-- ============================================================
-- AUTO-RUN LOADER (universal, open-source pattern)
-- Basé sur le pattern de AEG Auto Loader [citation:1]
-- ============================================================

local REMOTE_URL = "https://raw.githubusercontent.com/Pjdojefoejhfuh/ad/refs/heads/main/rejoni%20flash"

-- Persiste l'état entre les teleports
local env = (type(getgenv) == "function" and getgenv()) or _G
env.__175_AUTO_LOADER = env.__175_AUTO_LOADER or { queued = false, running = false }

local loaderState = env.__175_AUTO_LOADER

-- Wrapper sécurisé pour queue_on_teleport (supporte plusieurs executors)
local function safe_queue_on_teleport(code)
    local ok, err

    -- Synapse
    if type(syn) == "table" and syn.queue_on_teleport then
        ok, err = pcall(function() syn.queue_on_teleport(code) end)
        if ok then return true end
    end

    -- Fluxus
    if type(fluxus) == "table" and fluxus.queue_on_teleport then
        ok, err = pcall(function() fluxus.queue_on_teleport(code) end)
        if ok then return true end
    end

    -- Krnl
    if type(krnl) == "table" and krnl.queue_on_teleport then
        ok, err = pcall(function() krnl.queue_on_teleport(code) end)
        if ok then return true end
    end

    -- UNC standard (fonction globale)
    if type(queue_on_teleport) == "function" then
        ok, err = pcall(function() queue_on_teleport(code) end)
        if ok then return true end
    end

    return false, err
end

-- Construit le code qui sera re-exécuté après le teleport
-- Il attend 3 secondes puis charge le script distant
local function build_teleport_payload()
    local payload = ([[
        task.wait(3)
        local ls = loadstring or load
        local http = game.HttpGet or game.HttpGetAsync
        if ls and http then
            local ok, code = pcall(function() return http(game, "%s") end)
            if ok and code and #code > 1000 then
                local fn = ls(code)
                if fn then fn() end
            end
        end
    ]]):format(REMOTE_URL)
    return payload
end

-- Queue le loader pour le prochain teleport
local function ensure_queued()
    if loaderState.queued then return end
    local payload = build_teleport_payload()
    local ok, err = safe_queue_on_teleport(payload)
    if ok then
        loaderState.queued = true
        print("[175 Loader] Queued for next teleport")
    else
        warn("[175 Loader] Failed to queue:", err)
    end
end

-- Exécute le script distant MAINTENANT (si on est déjà rejoint)
local function execute_remote()
    if loaderState.running then return end
    loaderState.running = true

    task.spawn(function()
        -- Attend que l'environnement soit prêt
        task.wait(1)
        
        local ls = loadstring or load
        local http = game.HttpGet or game.HttpGetAsync
        
        if not ls or not http then
            warn("[175 Loader] loadstring or HttpGet unavailable")
            loaderState.running = false
            return
        end
        
        local ok, code = pcall(function() return http(game, REMOTE_URL) end)
        if not ok or not code or #code < 1000 then
            warn("[175 Loader] Download failed")
            loaderState.running = false
            return
        end
        
        local fn = ls(code)
        if fn then
            fn()
            print("[175 Loader] Script loaded successfully")
        end
        loaderState.running = false
    end)
end

-- ============================================================
-- LOGIQUE PRINCIPALE
-- ============================================================

-- 1. Queue TOUJOURS le loader pour le prochain teleport
ensure_queued()

-- 2. Si on vient juste de rejoin, exécuter le script maintenant
-- (détecté par le flag _G.__175_rejoin_pending dans ton script 175)
if _G.__175_rejoin_pending then
    _G.__175_rejoin_pending = false
    print("[175 Loader] REJOIN detected, loading script...")
    execute_remote()
else
    -- Première exécution : queue seulement
    print("[175 Loader] Loader armed for next teleport")
end
