--- The core level functionality of Plutonic.
-- @module Framework
--- Starts a mask to draw a model to the stencil buffer, this is used for sights
-- @param ent The entity to draw to the stencil buffer
-- @realm client
Plutonic.Framework.Mask = function(...)
	render.SetStencilReferenceValue(0)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(0xF0)
	render.ClearStencilBufferRectangle(0, 0, ScrW(), ScrH(), 0x0F)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilTestMask(0x00)
	render.SetStencilFailOperation(STENCIL_INCR)
	-- Draw the model to the stencil buffer
	local masks = {...}
	for _, ent in ipairs(masks) do
		ent:DrawModel()
	end

	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0x1F)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
end 

--- Ends a mask
-- @realm client
Plutonic.Framework.UnMask = function()
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	render.SetStencilEnable(false)
end