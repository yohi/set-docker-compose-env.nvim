vim.notify = require("notify")
vim.opt.termguicolors = true

local function set_docker_compose_env()
    -- print('export docker environment')
    -- print(os.execute('docker compose config --format json | jq ".services.app.environment" > /dev/null'))
        local handle = io.popen('docker compose config --format json | jq ".services.app.environment" &> /dev/null')
        -- local handle = io.popen('docker compose config --format json | jq ".services.app.environment" > /dev/null')
        -- print(handle)
        if handle ~= nil then
            local result = handle:read("*a")
            local docker_env = vim.fn.json_decode(result)
            for key, value in pairs(docker_env) do
                -- print('-----')
                -- print(key)
                -- print(value)
                vim.fn.setenv(key, value)
                vim.notify('export ' .. key .. '=' .. value, 'info')
            end
        end
    -- end
end

return {
    setup = set_docker_compose_env
}
