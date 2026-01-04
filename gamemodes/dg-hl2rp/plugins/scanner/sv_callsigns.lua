function impulse.MakeScannerTagline(scannerType)
    if scannerType == "claw" then
        return "AW:CLW-" .. tostring(math.random(1,99))
    else
        return "AW:SCN-" .. tostring(math.random(1,99))
    end
end
