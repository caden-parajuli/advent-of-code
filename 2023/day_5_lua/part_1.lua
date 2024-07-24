local FILENAME = "input"

local read_input
local get_seed_locations
local get_location
local get_maps

---comment
---@param filename any
---@return string[]
function read_input(filename)
    -- Check existence
    local f = io.open(filename, "rb")
    if f == nil then error("Input file does not exist") end
    f:close()

    -- Read lines
    local lines = {}
    for line in io.lines(filename) do
        lines[#lines + 1] = line
    end
    return lines
end

--- @param lines string[]
--- @return table
function get_maps(lines)
    local line_num = 2
    local maps = {}
    local map = nil
    while line_num <= #lines do
        local line = lines[line_num]
        local matched
        if line == "" then goto continue end

        -- End map, start new
        matched = false
        for source_name, dest_name in line:gmatch("(%a+)%-to%-(%a+) map:") do
            matched = true

            if map ~= nil then
                maps[#maps + 1] = map
            end

            map = {
                source_name = source_name,
                dest_name = dest_name,
            }
        end
        if matched then goto continue end

        -- Read map values
        for dest, source, range in line:gmatch("(%d+) (%d+) (%d+)") do
            matched = true
            map[#map + 1] = {
                dest = tonumber(dest),
                source = tonumber(source),
                range = tonumber(range)
            }
        end

        ::continue::
        line_num = line_num + 1
    end

    maps[#maps + 1] = map

    return maps
end

--- @returns number
--- @param maps table
--- @param seed number
function get_location(maps, seed)
    local value = seed
    local value_name = "seed"
    for _, map in ipairs(maps) do
        if map.source_name ~= value_name then error("Tables in wrong order") end
        value_name = map.dest_name
        for _, mapping in ipairs(map) do
            if value >= mapping.source and value < mapping.source + mapping.range then
                value = value + mapping.dest - mapping.source
                break
            end
        end
    end
    if value_name ~= "location" then error("Did not end with location") end
    return value
end

--- @param lines string[]
function get_seed_locations(lines)
    local locations = {}
    local maps = get_maps(lines)
    for seed in lines[1]:gmatch("(%d+)") do
        locations[#locations + 1] = get_location(maps, tonumber(seed) or error("Invalid number"))
    end
    return locations
end

local function main()
    local input = read_input(FILENAME)
    local seed_locations = get_seed_locations(input)
    local min = math.huge
    for _, location in ipairs(seed_locations) do
        if location < min then
            min = location
        end
    end
    print("Minimum seed location: " .. tostring(min))
end

main()

