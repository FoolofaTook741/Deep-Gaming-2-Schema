print("physgun_sh - hello world!")
-- simple exploit fix by anthony and billy <3
local _, C_Material = debug.getupvalue(Material, 1)
local patch_convar = CreateConVar("enable_block_large_materials", "1", FCVAR_REPLICATED, "Enable blocking of large materials being loaded form the data folder.")

if SERVER then return end

if not patch_convar:GetBool() then
    print("Large material blocking was not disabled.")
    return
end

local getImageDimensions do
    local max_image_search = 1024 -- we'll search this many bytes for the image dimensions

    local function getPNGDimensions(f)
        f:Skip(4)

        while not f:EndOfFile() and f:Tell() <= max_image_search do
            local chunkLength = f:ReadULong()
            local chunkType = f:Read(4)

            if chunkType == "IHDR" then
                local width = bit.bswap(f:ReadULong())
                local height = bit.bswap(f:ReadULong())
                return width, height
            end

            f:Skip(chunkLength) -- skip chunk data
            f:Skip(4) -- skip CRC
        end
    end

    local function getJPEGDimensions(f)
        local byte1, byte2

        while not f:EndOfFile() and f:Tell() <= max_image_search do
            byte1 = f:ReadByte()

            if byte1 == 0xFF then
                byte2 = f:ReadByte()

                if byte2 >= 0xC0 and byte2 <= 0xCF and byte2 ~= 0xC4 and byte2 ~= 0xC8 then
                    f:Skip(3)

                    local height = bit.bswap(bit.lshift(f:ReadUShort(), 16))
                    local width = bit.bswap(bit.lshift(f:ReadUShort(), 16))
                    return width, height
                end
            end
        end
    end

    function getImageDimensions(path)
        local f = file.Open(path, "rb", "DATA")
        if not f then return end

        local succ, width, height

        local sig = f:Read(4)
        if sig == "\xff\xd8\xff\xe0" then
            succ, width, height = pcall(getJPEGDimensions, f)
        elseif sig == "\x89\x50\x4e\x47" then
            succ, width, height = pcall(getPNGDimensions, f)
        end

        f:Close()

        if not succ then return end
        return width, height
    end
end

__originalMaterial = __originalMaterial or Material

function Material(name, words)
    if false then C_Material() end

    if not patch_convar:GetBool() then
        return __originalMaterial(name, words)
    end

    if name:find("../data") then
        local path = string.Replace(name, "../data/", "")
        local width, height = getImageDimensions(path)

        if not width or not height then
            return __originalMaterial("error")
        end

        if (width * height) > 33177600 then
            return __originalMaterial("error")
        end
    end

    return __originalMaterial(name, words)
end
