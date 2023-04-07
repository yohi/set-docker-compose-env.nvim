vim.notify = require("notify")
vim.opt.termguicolors = true

local function set_docker_compose_env()
    -- print('export docker environment')
    -- print(os.execute('docker compose config --format json | jq ".services.app.environment" > /dev/null'))
        local notify_list = {}
        local handle = io.popen('docker compose config --format json | jq ".services.app.environment" &> /dev/null')
        -- local handle = io.popen('docker compose config --format json | jq ".services.app.environment" > /dev/null')
        if handle ~= nil then
            local result = handle:read("*a")
            if result ~= '' then
                local docker_env = vim.fn.json_decode(result)
                for key, value in pairs(docker_env) do
                    -- print('-----')
                    -- print(key)
                    -- print(value)
                    vim.fn.setenv(key, value)
                    -- vim.notify('export ' .. key .. '=' .. value, 'info')
                    table.insert(notify_list, 'export ' .. key .. '=' .. value)
                end
            end
        end
        vim.notify(table.concat(notify_list, "\n"), 'info')
    -- end
end

return {
    setup = set_docker_compose_env
}
