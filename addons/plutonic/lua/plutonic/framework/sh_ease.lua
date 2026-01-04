-- for those with broken easing
-- src: https://github.com/Facepunch/garrysmod/blob/787c83a122720d0536ebf0b420b21cbf60b98550/garrysmod/lua/includes/extensions/math/ease.lua#L4

Plutonic = Plutonic or {}
Plutonic.Ease = Plutonic.Ease or {}

local c1 = 1.70158
local c3 = c1 + 1
local c2 = c1 * 1.525
local c4 = (2 * math.pi) / 3
local c5 = (2 * math.pi) / 4.5
local n1 = 7.5625
local d1 = 2.75
local pi = math.pi
local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt

function Plutonic.Ease.InSine(x)
	return 1 - cos((x * pi) / 2)
end

function Plutonic.Ease.OutSine(x)
	return sin((x * pi) / 2)
end

function Plutonic.Ease.InOutSine(x)
	return -(cos(pi * x) - 1) / 2
end

function Plutonic.Ease.InQuad(x)
	return x ^ 2
end

function Plutonic.Ease.OutQuad(x)
	return 1 - (1 - x) * (1 - x)
end

function Plutonic.Ease.InOutQuad(x)
	return x < 0.5 && 2 * x ^ 2 || 1 - ((-2 * x + 2) ^ 2) / 2
end

function Plutonic.Ease.InCubic(x)
	return x ^ 3
end

function Plutonic.Ease.OutCubic(x)
	return 1 - ((1 - x) ^ 3)
end

function Plutonic.Ease.InOutCubic(x)
	return x < 0.5 && 4 * x ^ 3 || 1 - ((-2 * x + 2) ^ 3) / 2
end

function Plutonic.Ease.InQuart(x)
	return x ^ 4
end

function Plutonic.Ease.OutQuart(x)
	return 1 - ((1 - x) ^ 4)
end

function Plutonic.Ease.InOutQuart(x)
	return x < 0.5 && 8 * x ^ 4 || 1 - ((-2 * x + 2) ^ 4) / 2
end

function Plutonic.Ease.InQuint(x)
	return x ^ 5
end

function Plutonic.Ease.OutQuint(x)
	return 1 - ((1 - x) ^ 5)
end

function Plutonic.Ease.InOutQuint(x)
	return x < 0.5 && 16 * x ^ 5 || 1 - ((-2 * x + 2) ^ 5) / 2
end

function Plutonic.Ease.InExpo(x)
	return x == 0 && 0 || (2 ^ (10 * x - 10))
end

function Plutonic.Ease.OutExpo(x)
	return x == 1 && 1 || 1 - (2 ^ (-10 * x))
end

function Plutonic.Ease.InOutExpo(x)
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| x < 0.5 && (2 ^ (20 * x - 10)) / 2
		|| (2 - (2 ^ (-20 * x + 10))) / 2
end

function Plutonic.Ease.InCirc(x)
	return 1 - sqrt(1 - (x ^ 2))
end

function Plutonic.Ease.OutCirc(x)
	return sqrt(1 - ((x - 1) ^ 2))
end

function Plutonic.Ease.InOutCirc(x)
	return x < 0.5
		&& (1 - sqrt(1 - ((2 * x) ^ 2))) / 2
		|| (sqrt(1 - ((-2 * x + 2) ^ 2)) + 1) / 2
end

function Plutonic.Ease.InBack(x)
	return c3 * x ^ 3 - c1 * x ^ 2
end

function Plutonic.Ease.OutBack(x)
	return 1 + c3 * ((x - 1) ^ 3) + c1 * ((x - 1) ^ 2)
end

function Plutonic.Ease.InOutBack(x)
	return x < 0.5
		&& (((2 * x) ^ 2) * ((c2 + 1) * 2 * x - c2)) / 2
		|| (((2 * x - 2) ^ 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
end

function Plutonic.Ease.InElastic(x)
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| -(2 ^ (10 * x - 10)) * sin((x * 10 - 10.75) * c4)
end

function Plutonic.Ease.OutElastic(x)
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| (2 ^ (-10 * x)) * sin((x * 10 - 0.75) * c4) + 1
end

function Plutonic.Ease.InOutElastic(x)
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| x < 0.5
		&& -((2 ^ (20 * x - 10)) * sin((20 * x - 11.125) * c5)) / 2
		|| ((2 ^ (-20 * x + 10)) * sin((20 * x - 11.125) * c5)) / 2 + 1
end

function Plutonic.Ease.InBounce(x)
	return 1 - OutBounce(1 - x)
end

function Plutonic.Ease.OutBounce(x)
	if (x < 1 / d1) then
		return n1 * x ^ 2
	elseif (x < 2 / d1) then
		x = x - (1.5 / d1)
		return n1 * x ^ 2 + 0.75
	elseif (x < 2.5 / d1) then
		x = x - (2.25 / d1)
		return n1 * x ^ 2 + 0.9375
	else
		x = x - (2.625 / d1)
		return n1 * x ^ 2 + 0.984375
	end
end

function Plutonic.Ease.InOutBounce(x)
	return x < 0.5
		&& (1 - OutBounce(1 - 2 * x)) / 2
		|| (1 + OutBounce(2 * x - 1)) / 2
end
