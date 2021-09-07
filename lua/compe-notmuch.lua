local M = {}

-- TODO: Support nvim-cmp
-- TODO: Support other completions

local headers = { 'Bcc:', 'Cc:', 'From:', 'Reply-To:', 'To:' }
local notmuch = {
    path = '/usr/bin/notmuch',
    config = '~/.notmuch-config',
    tags = {'inbox'}
}

local function build_notmuch_string(input)

    -- Expand and escape the config path
    local config = fn.shellescape(fn.expand(notmuch.config))

    -- Construct base command to append a query to
    local cmd = notmuch.path .. ' --config=' .. config .. ' address -- '

    -- Build first query from input
    local query = 'from:' .. input .. '*'

    -- Add tags to query
    for _,tag in pairs(notmuch.tags) do
        query = query .. ' tag:' .. tag
    end

    return cmd .. fn.shellescape(query)
end

-- Detect if we're in a mail header we care about
local function is_in_header()
    local line = vim.api.nvim_get_current_line()
    for _, header in pairs(headers) do
        if vim.startswith(line, header) then
            return true
        end
    end
    return false
end

-- Get a table of contacts that partially match input
local function get_contacts(input)
    local contacts = {}
    local pipe = io.popen(build_notmuch_string(input))
    for line in pipe:lines() do
        table.insert(contacts, line)
    end
    pipe:close()
    return contacts
end

-- TODO setup config
function M.setup()
    local compe = require('compe')
    local Source = {}

    function Source.get_metadata(_)
        return {
            menu = '[notmuch]',
            priority = 100,
            filetypes = { 'mail' }
        }
    end

    function Source.determine(_, context)
        return compe.helper.determine(context)
    end

    function Source.complete(_, context)
        if is_in_header() then
            context.callback({ items = get_contacts(context.input) })
        end
    end
    compe.register_source('notmuch', Source)
end

return M
