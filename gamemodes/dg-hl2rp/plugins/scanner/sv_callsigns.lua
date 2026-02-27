function impulse.MakeScannerTagline(scannerType)
    if scannerType == "claw" then
        return "AW:CLW-" .. tostring(math.random(1,99))
    elseif scannerType == "disp" then
        return "[DISPATCH]"
    else
        return "AW:SCN-" .. tostring(math.random(1,99))
    end
end
