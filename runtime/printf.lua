-- runtime/printf.lua
-- Simple printf/puts helpers to be required by generated Lua
-- Usage:
--   local rt = require("runtime.printf")
--   rt.rt_printf("Value: %d and %f", a, b)
--   rt.rt_puts("ok")

local M = {}

local function validate_arity(fmt, argc)
  -- very light arity check (counts % specifiers excluding %%)
  local count = 0
  local i = 1
  while true do
    local s, e = string.find(fmt, "%%.", i)
    if not s then break end
    local spec = string.sub(fmt, e, e)
    if spec ~= "%%" then
      count = count + 1
    end
    i = e + 1
  end
  if count ~= argc then
    -- not fatal, but helpful during development
    io.stderr:write(string.format("[printf warn] format expects %d args, got %d\n", count, argc))
  end
end

-- Convert booleans for %d and %s where needed: we expect codegen to handle it,
-- but these helpers are tolerant and will coerce basic cases.
local function coerce_arg(spec, v)
  if spec == "d" or spec == "i" then
    if type(v) == "boolean" then return v and 1 or 0 end
    if type(v) == "number" then return math.floor(v) end
    return v
  elseif spec == "f" or spec == "g" then
    if type(v) == "boolean" then return v and 1.0 or 0.0 end
    return v
  elseif spec == "s" then
    if type(v) == "boolean" then return v and "true" or "false" end
    return v
  elseif spec == "c" then
    if type(v) == "number" then
      return string.char((v // 1) % 256)
    end
    if type(v) == "string" and #v > 0 then
      return string.sub(v, 1, 1)
    end
    return v
  else
    return v
  end
end

local function coerce_args(fmt, args)
  local out = {}
  local specs = {}
  -- collect specs in order (again ignoring %%)
  local i = 1
  while true do
    local s, e = string.find(fmt, "%%.", i)
    if not s then break end
    local spec = string.sub(fmt, e, e)
    if spec ~= "%%" then table.insert(specs, spec) end
    i = e + 1
  end
  for idx, v in ipairs(args) do
    local spec = specs[idx]
    if spec then
      out[idx] = coerce_arg(spec, v)
    else
      out[idx] = v
    end
  end
  return out
end

function M.rt_printf(fmt, ...)
  local args = {...}
  validate_arity(fmt, #args)
  local coerced = coerce_args(fmt, args)
  local ok, s = pcall(string.format, fmt, table.unpack(coerced))
  if not ok then
    io.stderr:write("[printf error] "..tostring(s).."\n")
    return
  end
  print(s)
end

function M.rt_puts(s)
  -- puts prints the string followed by a newline
  print(s)
end

return M
