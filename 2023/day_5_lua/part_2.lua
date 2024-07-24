local FILENAME = "input"

local to_range
local read_input
local get_maps
local map_ranges
local get_seed_locations
local get_location_ranges


--- @param start number
--- @param length number
--- @return table
function to_range(start, length)
    return {
        start = start,
        rend = start + length - 1,
    }
end

--- @param filename any
--- @return string[]
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

--- @param map table
--- @param ranges table[]
function map_ranges(map, ranges)
    local new_ranges = {}
    for _, range in ipairs(ranges) do
        for _, mapping in ipairs(map) do
            local map_range = to_range(mapping.source, mapping.range)
            local map_change = mapping.dest - mapping.source

            if map_range.start > map_range.rend then error("Bad map_range") end
            if range.start > range.rend then error("Bad range") end

            -- Range intersection and difference
            if range.start <= map_range.rend and range.rend >= map_range.start then
                local new_start = math.max(range.start, map_range.start)
                local new_rend = math.min(range.rend, map_range.rend)
                new_ranges[#new_ranges + 1] = {
                    start = new_start + map_change,
                    rend = new_rend + map_change,
                }

                if range.start < new_start then
                    ranges[#ranges + 1] = {
                        start = range.start,
                        rend = new_start - 1,
                    }
                end

                if new_rend < range.rend then
                    ranges[#ranges + 1] = {
                        start = new_rend + 1,
                        rend = range.rend,
                    }
                end

                -- tombstone
                range.start = -1
                range.rend = -1
            end
        end
    end
    -- Add the remaining ranges
    for _, range in ipairs(ranges) do
        if range.start ~= -1 and range.rend ~= -1 then
            new_ranges[#new_ranges + 1] = range
        end
    end
    return new_ranges
end

--- @returns number
--- @param maps table
--- @param ranges table[]
function get_location_ranges(maps, ranges)
    local value_name = "seed"
    for _, map in ipairs(maps) do
        if map.source_name ~= value_name then error("Tables in wrong order") end
        value_name = map.dest_name
        ranges = map_ranges(map, ranges)
    end
    if value_name ~= "location" then error("Did not end with location") end
    return ranges
end

--- @param lines string[]
function get_seed_locations(lines)
    local maps = get_maps(lines)
    local ranges = {}
    for seed_start, length in lines[1]:gmatch("(%d+) (%d+)") do
        ranges[#ranges + 1] = to_range(tonumber(seed_start) or error("parsing"), tonumber(length) or error("parsing"))
    end
    local location_ranges = get_location_ranges(maps, ranges)
    return location_ranges
end

local function main()
    local input = read_input(FILENAME)
    local location_ranges = get_seed_locations(input)
    local min = math.huge
    for _, range in ipairs(location_ranges) do
        if range.start < min then
            min = range.start
        end
    end
    print("Minimum seed location: " .. tostring(min))
end

main()
