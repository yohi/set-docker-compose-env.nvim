vim.notify = require("notify")
vim.opt.termguicolors = true

local function set_docker_compose_env()
    local handle = io.popen('docker compose config --format json | jq ".services.app.environment" &> /dev/null')
    if handle ~= nil then
        local result = handle:read("*a")
        if result ~= '' then
            -- docker compose config のenvironmentを取得できた場合
            local docker_env = vim.fn.json_decode(result)
            local notify_list = {}
            for key, value in pairs(docker_env) do
                vim.fn.setenv(key, value)
                table.insert(notify_list, 'export ' .. key .. '=' .. value)
            end
            vim.notify(table.concat(notify_list, "\n"), 'info')
        end
    end
end

return {
    setup = set_docker_compose_env
}
