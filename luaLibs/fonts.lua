require("basic2")

function convertCharacterToGlyph(char)

	return string.byte(char) - 32
end

Fonts = {glypthHeight = nil, fontsImg = nil, fontsBitmap = nil}

function Fonts:new(o)
	local o = o or {}
	o.glyphHeight=8

	o.fontsImg = {width=6, height=760, data={0,0,0,0,0,0,0,"⠿",0,0,"⠉",0,0,"⠃","⠃",0,0,0,"⣺","⣒","⣗","⠈",0,"⠁","⢔","⣺","⡂","⠐","⠺","⠊","⢁","⠔","⠁","⠁",0,"⠁","⡏","⠉","⢹","⠉","⠉","⠉",0,"⠘",0,0,0,0,"⢰","⠁",0,0,"⠁",0,"⠈","⡆",0,"⠈",0,0,"⢵","⢴","⠅","⠁",0,"⠁","⠤","⡧","⠄",0,"⠁",0,0,0,0,"⠠","⠟",0,"⠤","⠤","⠄",0,0,0,0,0,0,0,"⠛",0,0,"⡠","⠊","⠁",0,0,"⣎","⠝","⡆","⠈","⠉",0,"⠐","⡇",0,"⠈","⠉",0,"⠊","⡩","⠂","⠉","⠉","⠁","⡊","⠩","⢵","⠈","⠉","⠁","⠧","⢼","⠤",0,"⠈",0,"⠯","⠭","⡉","⠉","⠉",0,"⡠","⠮","⡀","⠈","⠉",0,"⠉","⡩","⠋","⠈",0,0,"⡪","⠭","⢕","⠈","⠉","⠁","⠪","⡭","⠂","⠈",0,0,0,"⠛",0,0,"⠛",0,0,"⠛",0,"⠠","⠟",0,"⠠","⡊",0,0,"⠈",0,"⠐","⠒","⠂","⠈","⠉","⠁","⠈","⡢",0,"⠈",0,0,"⠊","⢉","⠆",0,"⠅",0,"⡎","⡩","⢵","⠑","⠚","⠋","⡴","⠭","⢦","⠁",0,"⠈","⡯","⠭","⡂","⠉","⠉",0,"⡎","⠉","⡂","⠈","⠉",0,"⡏","⢑","⠄","⠉","⠁",0,"⡯","⠭","⠁","⠉","⠉","⠁","⡯","⠭","⠁","⠁",0,0,"⡎","⠩","⢥","⠈","⠉","⠁","⡧","⠤","⢼","⠁",0,"⠈","⠉","⡏","⠁","⠉","⠉","⠁","⡈","⢹","⠁","⠈","⠁",0,"⡧","⢔","⠁","⠁",0,"⠁","⡇",0,0,"⠉","⠉","⠁","⡗","⠤","⢺","⠁",0,"⠈","⡗","⢄","⢸","⠁",0,"⠉","⡎","⠉","⢱","⠈","⠉","⠁","⡮","⠭","⠂","⠁",0,0,"⡎","⠩","⣱","⠈","⠉","⠈","⡮","⢭","⠂","⠁",0,"⠁","⠪","⠭","⢍","⠉","⠉","⠁","⠉","⡏","⠁",0,"⠁",0,"⡇",0,"⢸","⠈","⠉","⠁","⢣",0,"⡜",0,"⠉",0,"⡇","⣀","⢸","⠉",0,"⠉","⠻","⡸","⠃","⠾","⠸","⠆","⠑","⡤","⠊","⠈",0,0,"⢉","⠝","⠁","⠉","⠉","⠁","⢸","⠉",0,"⠈","⠉",0,"⠑","⢄",0,0,0,"⠁","⠈","⢹",0,"⠈","⠉",0,"⠐","⠑",0,0,0,0,0,0,0,"⠈","⠉","⠁","⡏","⠉","⢹","⠉","⠉","⠉","⡠","⠭","⡆","⠈","⠉","⠁","⡧","⢄",0,"⠉","⠁",0,"⢰","⠒",0,"⠈","⠉",0,"⡠","⢼",0,"⠈","⠉",0,"⢰","⠕",0,0,"⠉",0,"⣔","⠂",0,"⠃",0,0,"⡠","⢄",0,"⠨","⠝",0,"⡧","⡀",0,"⠁","⠁",0,0,"⡁",0,0,"⠁",0,0,"⠂",0,"⠤","⠃",0,"⣆","⠄",0,"⠁","⠁",0,0,"⡇",0,"⠈","⠉",0,"⡔","⠔","⡄","⠁",0,"⠁","⡖","⠒","⡄","⠁",0,"⠁","⢠","⠒","⡄",0,"⠉",0,"⡠","⢄",0,"⡏","⠁",0,"⢀","⠤","⡀",0,"⠉","⡇","⢠","⠒","⠂","⠈",0,0,"⢔","⣒",0,"⠐","⠒","⠁","⠒","⡗","⠂",0,"⠁",0,"⢰",0,"⡆",0,"⠉","⠁","⠰","⡀","⡰",0,"⠈",0,"⡄","⣀","⢠","⠉",0,"⠉","⢑","⢔","⠁","⠁",0,"⠁","⢄","⢀","⠄","⠔","⠁",0,"⢒","⠖",0,"⠉","⠉",0,"⡏","⠉","⢹","⠉","⠉","⠉","⡏","⠉","⢹","⠉","⠉","⠉","⡏","⠉","⢹","⠉","⠉","⠉","⡏","⠉","⢹","⠉","⠉","⠉"}}

	o.fontsBitmap = Bitmap:new(o.fontsImg.width, o.fontsImg.height)
	o.fontsBitmap.core.data = o.fontsImg.data

	setmetatable(o, self)
	self.__index = self
	return o
end

function Fonts:printText(destinationBitmap, destinationCoordinate, str)
	local x = destinationCoordinate.x
	local y = destinationCoordinate.y

	for c in str:gmatch(".") do
		destinationBitmap:blitSection(self.fontsBitmap, {x=x, y=y}, {x=0, y=self.glyphHeight*convertCharacterToGlyph(c), width=self.fontsImg.width, height=self.glyphHeight})
		x = x + self.fontsImg.width
	end
end

function Fonts:getCharacterWidth()
	return self.fontsImg.width
end

function Fonts:getCharacterHeight()
	return self.glyphHeight
end
