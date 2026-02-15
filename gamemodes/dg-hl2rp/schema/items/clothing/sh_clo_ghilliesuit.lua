local ITEM = {}

ITEM.UniqueID = "clo_ghilliesuit"
ITEM.Name = "Ghillie Suit (Deprecated (2/10/25))"
ITEM.Desc =  "A camouflaged suit that looks like foliage, differs based on the outlands of each sector."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_junk/cardboard_box002a.mdl")
ITEM.FOV = 50.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true 
ITEM.CanStack = true   

impulse.RegisterItem(ITEM)
