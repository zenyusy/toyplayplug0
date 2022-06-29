local function setup_view()
    -- create a scratch unlisted buffer
    local bufnr = vim.api.nvim_create_buf(false, true)

    -- delete buffer when window is closed / buffer is hidden
    vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'delete')
    -- create a split
    vim.cmd'botright vs'
    -- resize to a % of the current window size
    vim.cmd('vertical resize ' .. math.ceil(vim.o.columns * 0.7))

    -- get current (outline) window and attach our buffer to it
    local winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winnr, bufnr)

    -- window stuff
    vim.api.nvim_win_set_option(winnr, 'number', false)
    vim.api.nvim_win_set_option(winnr, 'relativenumber', false)
    vim.api.nvim_win_set_option(winnr, 'winfixwidth', true)
    -- buffer stuff
    vim.api.nvim_buf_set_name(bufnr, 'ToyPlayPlug0')
    vim.api.nvim_buf_set_option(bufnr, 'filetype', 'ToyPlayPlug0')
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

    vim.api.nvim_win_set_option(winnr, 'nu', true)
    vim.api.nvim_win_set_option(winnr, 'rnu', true)

    return bufnr, winnr
end

local function write_it(bufnr, lines)
    if vim.api.nvim_buf_is_valid(bufnr) and string.match(vim.api.nvim_buf_get_name(bufnr), 'ToyPlayPlug0') ~= nil and vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'ToyPlayPlug0' then
        vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
    end
end

local function fexist(name)
    local f = io.open(name,"r")
    if f ~= nil then io.close(f) return true else return false end
end

local function mysplit(inputstr)
    -- if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^\r\n]+)") do
        table.insert(t, str)
    end
    return t
end

local function getdata()
    local curd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
    local upcnt = 20
    repeat 
        if fexist(curd .. '/go.mod') then
            curd = curd .. '/'
            break
        end
        curd = curd .. '/..'
        upcnt = upcnt - 1
    until upcnt == 0
    upcnt = nil
    -- go root path

    -- TODO subproc
    local p = assert(io.popen("ls " .. curd, "r"))
    if not p then
        return {"error process"}
    end
    local s = assert(p:read('*a'))
    p:close()
    if not s then
        return {"error read"}
    end
    --s = string.gsub(s,'[\n\r]+',' ')
    -- print(vim.inspect(s))
    -- print(type(s))
    --return {"OK", curd }
    return mysplit(s)
end

local function setup()
    local d = {buff=nil,winn=nil}
    d.buff, d.winn = setup_view()
    write_it(d.buff, getdata())
    -- print(1+2)
end

return {setup=setup}