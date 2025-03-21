local Job = require("plenary.job")
local cwd = vim.fn.getcwd()
local dirChangeCommand = 'cd'
local terminalClearCommand = 'clear'

local sessionStatus = os.getenv("TMUX")
local mysplit = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local sessionId = mysplit(sessionStatus, ",")[3]
local termianlWindowId = string.format("%s:%s.%s", sessionId, 2, 1)

local tmuxWindows = Job:new({ 'tmux', 'list-windows', cwd = cwd }):sync()

vim.notify('resut:' .. #tmuxWindows)
if #tmuxWindows == 1 then
    Job:new({ 'tmux', 'rename-window', '-t', '1', 'main:NVIM', cwd = cwd }):sync()
    Job:new({ 'tmux', 'new-window', '-n', 'terminal', cwd = cwd }):sync()
    Job:new({ 'tmux', 'select-window', '-t', '1', cwd = cwd }):sync()
end

local sendKeys = function(command)
    Job:new({ 'tmux', 'send-keys', '-t', termianlWindowId, command, 'Enter', cwd = cwd }):sync()
end

local clear_terminal = function()
    local command = string.format("%s", terminalClearCommand)
    sendKeys(command)
end

local dir_change_function = function(dir)
    vim.notify('changing to:' .. dir)
    local command = string.format("%s %s", dirChangeCommand, dir)
    sendKeys(command)
    clear_terminal()
end

return {
    dir_change = dir_change_function
}
