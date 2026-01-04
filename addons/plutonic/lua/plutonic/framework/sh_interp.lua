function Plutonic.Interpolation.Lerp(a, b, c)
	return a + (b - a) * c
end

function Plutonic.Interpolation.BezierCurve(t, p0, p1, p2)
	local l1 = Plutonic.Interpolation.Lerp(p0, p1, t)
	local l2 = Plutonic.Interpolation.Lerp(p1, p2, t)
	local quad = Plutonic.Interpolation.Lerp(l1, l2, t)

	return quad
end

function Plutonic.Interpolation.VectorBezierCurve(t, v0, v1, v2)
	return Vector(Plutonic.Interpolation.BezierCurve(t, v0.x, v1.x, v2.x), Plutonic.Interpolation.BezierCurve(t, v0.y, v1.y, v2.y), Plutonic.Interpolation.BezierCurve(t, v0.z, v1.z, v2.z))
end

function Plutonic.Interpolation.AngleBezierCurve(t, a0, a1, a2)
	return Angle(Plutonic.Interpolation.BezierCurve(t, a0.p, a1.p, a2.p), Plutonic.Interpolation.BezierCurve(t, a0.y, a1.y, a2.y), Plutonic.Interpolation.BezierCurve(t, a0.r, a1.r, a2.r))
end