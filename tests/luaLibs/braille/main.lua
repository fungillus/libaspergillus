--[[

this test file is for the library braille.lua

functions to test :

convRawUnicodeValueToUnicode
convBrailleToRawUnicodeValue
convBrailleToUnicode
Bitmap:getPixel
Bitmap:putPixel
Bitmap:marshalRow
Bitmap:renderToString
Bitmap:drawBorder
Bitmap:blit
Bitmap:blitSection

Bitmap:clear
Bitmap:draw
Bitmap:blitReverse
Bitmap:isRectangleEmpty

--]]

function testConvRawUnicodeValueToUnicode()
	local convRawUnicodeValueToUnicodeTests = {
		{"first", convRawUnicodeValueToUnicode, {0x28FF}, "⣿"}
		,{"second", convRawUnicodeValueToUnicode, {0x2807}, "⠇"}
		,{"third", convRawUnicodeValueToUnicode, {0x2847}, "⡇"}
		,{"fourth", convRawUnicodeValueToUnicode, {0x28E1}, "⣡"}
		,{"fifth", convRawUnicodeValueToUnicode, {0x28F0}, "⣰"}
	}

	if not doTests("convRawUnicodeValueToUnicode", convRawUnicodeValueToUnicodeTests) then
		return false
	else
		return true
	end
end

function testConvBrailleToRawUnicodeValue()
	local convBrailleToRawUnicodeValueTests = {
		{"1st", convBrailleToRawUnicodeValue, {0x3333}, 0x28FF}
		,{"2nd", convBrailleToRawUnicodeValue, {0x1110}, 0x2807}
		,{"3rd", convBrailleToRawUnicodeValue, {0x1111}, 0x2847}
		,{"4th", convBrailleToRawUnicodeValue, {0x1023}, 0x28E1}
		,{"5th", convBrailleToRawUnicodeValue, {0x0223}, 0x28F0}
	}

	if not doTests("convBrailleToRawUnicodeValue", convBrailleToRawUnicodeValueTests) then
		return false
	else
		return true
	end
end

function testConvBrailleToUnicode()
	local convBrailleToUnicodeTests = {
		{"1st", convBrailleToUnicode, {0x3333}, "⣿"}
		,{"2nd", convBrailleToUnicode, {0x1110}, "⠇"}
		,{"3rd", convBrailleToUnicode, {0x1111}, "⡇"}
		,{"4th", convBrailleToUnicode, {0x1023}, "⣡"}
		,{"5th", convBrailleToUnicode, {0x0223}, "⣰"}
	}

	if not doTests("convBrailleToUnicode", convBrailleToUnicodeTests) then
		return false
	else
		return true
	end
end

function testBitmapMarshalRow()
	local mainBitmap = Bitmap:new(10, 16)

	for y = 0, 15, 5 do
		for x = 0, 10 - 1 do
			mainBitmap:putPixel(x, y, 1)
		end
	end

	local mainBitmap2 = Bitmap:new(10, 16)

	-- first row 
	-- 0 to 3
	-- all 1000
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 0, 1)
		mainBitmap2:putPixel(x + 1, 0, 0)
	end

	-- second row
	-- 4 to 7
	-- all 0200
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 5, 0)
		mainBitmap2:putPixel(x + 1, 5, 1)
	end

	-- third row
	-- 8 to 11
	-- all 0030
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 10, 1)
		mainBitmap2:putPixel(x + 1, 10, 1)
	end

	-- fourth row
	-- 12 to 15
	-- all 0000
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 15, 0)
		mainBitmap2:putPixel(x + 1, 15, 0)
	end


	local marshalTest = function (bitmap, row)
		return bitmap.core:marshalRow(row)
	end

	local tests = {
		{"first row", marshalTest, {mainBitmap, 0}, [[
⠉⠉⠉⠉⠉]]}
		,{"second row", marshalTest, {mainBitmap, 1}, [[
⠒⠒⠒⠒⠒]]}
		,{"third row", marshalTest, {mainBitmap, 2}, [[
⠤⠤⠤⠤⠤]]}
		,{"fourth row", marshalTest, {mainBitmap, 3}, [[
⣀⣀⣀⣀⣀]]}

		-- mainBitmap2
		,{"first row v2", marshalTest, {mainBitmap2, 0}, [[
⠁⠁⠁⠁⠁]]}
		,{"second row v2", marshalTest, {mainBitmap2, 1}, [[
⠐⠐⠐⠐⠐]]}
		,{"third row v2", marshalTest, {mainBitmap2, 2}, [[
⠤⠤⠤⠤⠤]]}
		,{"fourth row v2", marshalTest, {mainBitmap2, 3}, [[
     ]]}
	}

	if not doTests("Bitmap:marshalRow", tests) then
		return false
	else
		return true
	end
end

function testBitmapRenderToString()
	local mainBitmap = Bitmap:new(10, 16)

	-- first row 
	-- 0 to 3
	-- all 3000
	for x = 0, 10 - 1 do
		mainBitmap:putPixel(x, 0, 1)
	end

	-- second row
	-- 4 to 7
	-- all 0300
	for x = 0, 10 - 1 do
		mainBitmap:putPixel(x, 5, 1)
	end

	-- third row
	-- 8 to 11
	-- all 0030
	for x = 0, 10 - 1 do
		mainBitmap:putPixel(x, 10, 1)
	end

	-- fourth row
	-- 12 to 15
	-- all 0003
	for x = 0, 10 - 1 do
		mainBitmap:putPixel(x, 15, 1)
	end



	local mainBitmap2 = Bitmap:new(10, 16)

	-- first row 
	-- 0 to 3
	-- all 1000
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 0, 1)
		mainBitmap2:putPixel(x + 1, 0, 0)
	end

	-- second row
	-- 4 to 7
	-- all 0200
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 5, 0)
		mainBitmap2:putPixel(x + 1, 5, 1)
	end

	-- third row
	-- 8 to 11
	-- all 0030
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 10, 1)
		mainBitmap2:putPixel(x + 1, 10, 1)
	end

	-- fourth row
	-- 12 to 15
	-- all 0000
	for x = 0, 10 - 1, 2 do
		mainBitmap2:putPixel(x, 15, 0)
		mainBitmap2:putPixel(x + 1, 15, 0)
	end


	local renderToStringTest = function (bitmap)
		return bitmap:renderToString()
	end

	local tests = {
		{"mainBitmap", renderToStringTest, {mainBitmap}, [[
⠉⠉⠉⠉⠉
⠒⠒⠒⠒⠒
⠤⠤⠤⠤⠤
⣀⣀⣀⣀⣀
]]}

		,{"mainBitmap2", renderToStringTest, {mainBitmap2}, [[
⠁⠁⠁⠁⠁
⠐⠐⠐⠐⠐
⠤⠤⠤⠤⠤
     
]]}
	}

	if not doTests("Bitmap:renderToString", tests) then
		return false
	else
		return true
	end
end

function testBitmapDrawBorder()
	function bitmapDrawBorder(width, height, borderThickness)
		local bmp = Bitmap:new(width, height)

		bmp:drawBorder(borderThickness)

		return bmp:renderToString()
	end

	-- Bitmap:drawBorder
	local BitmapDrawBorderTests = {
		{"four by four", bitmapDrawBorder, {4, 4, 1}, [[
⣏⣹
]]}
		,{"eight by eight", bitmapDrawBorder, {8, 8, 1}, [[
⡏⠉⠉⢹
⣇⣀⣀⣸
]]}
		,{"twenty by twenty", bitmapDrawBorder, {20, 20, 1}, [[
⡏⠉⠉⠉⠉⠉⠉⠉⠉⢹
⡇        ⢸
⡇        ⢸
⡇        ⢸
⣇⣀⣀⣀⣀⣀⣀⣀⣀⣸
]]}

		,{"twenty by twenty 2 pixels thick", bitmapDrawBorder, {20, 20, 2}, [[
⣿⠛⠛⠛⠛⠛⠛⠛⠛⣿
⣿        ⣿
⣿        ⣿
⣿        ⣿
⣿⣤⣤⣤⣤⣤⣤⣤⣤⣿
]]}

		,{"twenty by twenty 3 pixels thick", bitmapDrawBorder, {20, 20, 3}, [[
⣿⡿⠿⠿⠿⠿⠿⠿⢿⣿
⣿⡇      ⢸⣿
⣿⡇      ⢸⣿
⣿⡇      ⢸⣿
⣿⣷⣶⣶⣶⣶⣶⣶⣾⣿
]]}
	}

	if not doTests("Bitmap:drawBorder", BitmapDrawBorderTests) then
		return false
	else
		return true
	end
end

function testBitmapGetPixel()
	function bitmapGetPixel(x, y, width, height, dataBuffer)
		local bmp = Bitmap:new(width, height)

		bmp.core.data = dataBuffer

		return bmp:getPixel(x, y)
	end

	-- for the braille renderer, the data buffer encodes pixels inside 2x4 elements
	-- we use this function to inject test entries for all coordinates in the dataBuffer
	-- and expect only a single coordinate to have the value 1, the rest must have the value 0
	function injectGetPixelTests(testList, description, width, height, dataBuffer, coordinateOfSetPixel)
		local expectedValue = 0
		for y = 0, height - 1 do
			for x = 0, width - 1 do
				if coordinateOfSetPixel.x == x and coordinateOfSetPixel.y == y then
					expectedValue = 1
				else
					expectedValue = 0
				end
				table.insert(testList
					, {
						string.format("%s (%d,%d)", description, x, y)
						, bitmapGetPixel
						, {x, y, width, height, dataBuffer}
						, expectedValue
					})
			end
		end
	end

	local BitmapGetPixelTests = {}

	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x1000", 2, 4, {"⠁"}, {x=0, y=0})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x2000", 2, 4, {"⠈"}, {x=1, y=0})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x0100", 2, 4, {"⠂"}, {x=0, y=1})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x0200", 2, 4, {"⠐"}, {x=1, y=1})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x0010", 2, 4, {"⠄"}, {x=0, y=2})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x0020", 2, 4, {"⠠"}, {x=1, y=2})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x0001", 2, 4, {"⡀"}, {x=0, y=3})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 2x4 0x0002", 2, 4, {"⢀"}, {x=1, y=3})

	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x1000", 4, 8,
		{0, 0, 0, "⠁"}, {x=2, y=4})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x2000", 4, 8,
		{0, 0, 0, "⠈"}, {x=3, y=4})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x0100", 4, 8,
		{0, 0, 0, "⠂"}, {x=2, y=5})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x0200", 4, 8,
		{0, 0, 0, "⠐"}, {x=3, y=5})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x0010", 4, 8,
		{0, 0, 0, "⠄"}, {x=2, y=6})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x0020", 4, 8,
		{0, 0, 0, "⠠"}, {x=3, y=6})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x0001", 4, 8,
		{0, 0, 0, "⡀"}, {x=2, y=7})
	injectGetPixelTests(BitmapGetPixelTests, "braille pixel 4x8 0x0002", 4, 8,
		{0, 0, 0, "⢀"}, {x=3, y=7})

	table.insert(BitmapGetPixelTests, {"on nil dataBuffer", bitmapGetPixel, {0, 0, 2, 4, {}}, 0})
	table.insert(BitmapGetPixelTests, {"spot check 1", bitmapGetPixel, {0, 0, 2, 4, {"⣌"}}, 0})
	table.insert(BitmapGetPixelTests, {"spot check 2", bitmapGetPixel, {1, 0, 2, 4, {"⣌"}}, 1})
	table.insert(BitmapGetPixelTests, {"spot check 3", bitmapGetPixel, {0, 1, 2, 4, {"⣌"}}, 0})
	table.insert(BitmapGetPixelTests, {"spot check 4", bitmapGetPixel, {0, 2, 2, 4, {"⣌"}}, 1})
	table.insert(BitmapGetPixelTests, {"spot check 5", bitmapGetPixel, {0, 3, 2, 4, {"⣌"}}, 1})
	table.insert(BitmapGetPixelTests, {"spot check 6", bitmapGetPixel, {1, 3, 2, 4, {"⣌"}}, 1})

	table.insert(BitmapGetPixelTests, {"spot check 7", bitmapGetPixel, {3, 5, 4, 8, {"⣌", 0, "⠋", "⡤"}}, 0})
	table.insert(BitmapGetPixelTests, {"spot check 8", bitmapGetPixel, {3, 6, 4, 8, {"⣌", 0, "⠋", "⡤"}}, 1})
	table.insert(BitmapGetPixelTests, {"spot check 9", bitmapGetPixel, {2, 6, 4, 8, {"⣌", 0, "⠋", "⡤"}}, 1})
	table.insert(BitmapGetPixelTests, {"spot check 10", bitmapGetPixel, {1, 6, 4, 8, {"⣌", 0, "⠋", "⡤"}}, 0})

	if not doTests("Bitmap:getPixel", BitmapGetPixelTests) then
		return false
	else
		return true
	end
end

function testBitmapPutPixel()
	-- at this point, we know that getPixel works according to specs so we can use it.
	local width = 30
	local height = 30
	local bmp = Bitmap:new(width, height)

	function testPutPixel(bmp, toCheckCoord)
		local result = true
		local pixelValue = 0
		local foundCheckCoord = false
		local bmpSize = bmp:getSize()
		bmp:putPixel(toCheckCoord.x, toCheckCoord.y, 1)
		for y = 0, bmpSize.height - 1 do
			for x = 0, bmpSize.width - 1 do
				pixelValue = bmp:getPixel(x, y)

				if toCheckCoord.x == x and toCheckCoord.y == y then
					if pixelValue == 0 then
						result = false
					else
						foundCheckCoord = true
					end
				else
					if pixelValue == 1 then result = false end
				end
			end
		end
		bmp:putPixel(toCheckCoord.x, toCheckCoord.y, 0)

		if foundCheckCoord == false then
			result = false
		end

		return result
	end

	local tests = {
		{"Spot check 1", testPutPixel, {bmp, {x = 20, y = 20}}, true}
		,{"Spot check 2", testPutPixel, {bmp, {x = 29, y = 29}}, true}
		,{"Out of bound check", testPutPixel, {bmp, {x = 60, y = 60}}, false}
		,{"Out of bound check 2", testPutPixel, {bmp, {x = 30, y = 30}}, false}
		,{"X check", testPutPixel, {bmp, {x = 29, y = 0}}, true}
		,{"X check out of bound", testPutPixel, {bmp, {x = 30, y = 0}}, false}
		,{"Y check", testPutPixel, {bmp, {x = 0, y = 29}}, true}
		,{"Y check out of bound", testPutPixel, {bmp, {x = 0, y = 30}}, false}
		,{"Single block check 0,0", testPutPixel, {bmp, {x = 0, y = 0}}, true}
		,{"Single block check 1,0", testPutPixel, {bmp, {x = 1, y = 0}}, true}
		,{"Single block check 0,1", testPutPixel, {bmp, {x = 0, y = 1}}, true}
		,{"Single block check 1,1", testPutPixel, {bmp, {x = 1, y = 1}}, true}
		,{"Single block check 0,2", testPutPixel, {bmp, {x = 0, y = 2}}, true}
		,{"Single block check 1,2", testPutPixel, {bmp, {x = 1, y = 2}}, true}
		,{"Single block check 0,3", testPutPixel, {bmp, {x = 0, y = 3}}, true}
		,{"Single block check 1,3", testPutPixel, {bmp, {x = 1, y = 3}}, true}
	}

	if not doTests("Bitmap:putPixel", tests) then
		return false
	else
		return true
	end
end

function testBlit()
	local blitTest = function (width, height, rawTextImage, blitX, blitY)
		local mainBitmap = Bitmap:new(width, height)

		local imgToBlit = convertRawTextToImage(rawTextImage)

		mainBitmap:blit(imgToBlit, blitX, blitY)

		return mainBitmap:renderToString()
	end

	local tests = {
		{"1", blitTest, {20, 20, [[
**
**
**
**
]], 0, 0}, [[
⣿         
          
          
          
          
]]}
		,{"2", blitTest, {20, 20, [[
**
**
**
**
]], 1, 0}, [[
⢸⡇        
          
          
          
          
]]}
		,{"3", blitTest, {20, 20, [[
**
**
**
**
]], 1, 1}, [[
⢰⡆        
⠈⠁        
          
          
          
]]}
		,{"4 half out of bound horizontally", blitTest, {20, 20, [[
**
**
**
**
]], 19, 0}, [[
         ⢸
          
          
          
          
]]}
		,{"5 totally out of bound horizontally", blitTest, {20, 20, [[
**
**
**
**
]], 20, 0}, [[
          
          
          
          
          
]]}
		,{"6 totally out of bound horizontally to the left", blitTest, {20, 20, [[
**
**
**
**
]], -2, 0}, [[
          
          
          
          
          
]]}
		,{"5v2 totally out of bound vertically to the bottom", blitTest, {20, 20, [[
**
**
**
**
]], 0, 20}, [[
          
          
          
          
          
]]}
		,{"6v2 totally out of bound vertically to the top", blitTest, {20, 20, [[
**
**
**
**
]], 0, -4}, [[
          
          
          
          
          
]]}
		,{"7 half out of bound horizontally to the left", blitTest, {20, 20, [[
**
**
**
**
]], -1, 0}, [[
⡇         
          
          
          
          
]]}
		,{"8 half out of bound vertically to the top", blitTest, {20, 20, [[
**
**
**
**
]], 0, -2}, [[
⠛         
          
          
          
          
]]}
		,{"9 half out of bound vertically in the bottom", blitTest, {20, 20, [[
**
**
**
**
]], 0, 18}, [[
          
          
          
          
⣤         
]]}
		,{"10 half out of bound in the bottom right corner", blitTest, {20, 20, [[
**
**
**
**
]], 19, 18}, [[
          
          
          
          
         ⢠
]]}
		,{"11 half out of bound in the top left corner", blitTest, {20, 20, [[
**
**
**
**
]], -1, -2}, [[
⠃         
          
          
          
          
]]}
		,{"12 out of bound in the top left corner", blitTest, {20, 20, [[
**
**
**
**
]], -2, -4}, [[
          
          
          
          
          
]]}
		,{"13 out of bound in the bottom right corner", blitTest, {20, 20, [[
**
**
**
**
]], 20, 20}, [[
          
          
          
          
          
]]}
	}

	if not doTests("Bitmap:blit", tests) then
		return false
	else
		return true
	end
end

function testBlitSection()
	local blitTest = function (width, height, rawTextImage, blitDest, sourceRectangle)
		local mainBitmap = Bitmap:new(width, height)

		local imgToBlit = convertRawTextToImage(rawTextImage)

		local _result = mainBitmap:blitSection(imgToBlit, blitDest, sourceRectangle)

		if _result == 0 then
			return mainBitmap:renderToString()
		else
			return false
		end
	end

	local tests = {
		{"simplest blit", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, y=0, width=2, height=4}}, [[
⣿         
          
          
          
          
]]}
		,{"nil destinationCoordinates", blitTest, {20, 20, [[
**
**
**
**
]], nil, nil}, false}
		,{"nil sourceRectangle", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}}, [[
⣿         
          
          
          
          
]]}
		,{"sourceRectangle missing x", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {y=0, width=2, height=4}}, false}
		,{"sourceRectangle missing y", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, width=2, height=4}}, false}

		,{"sourceRectangle missing width", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, y=0, height=4}}, false}
		,{"sourceRectangle missing height", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, y=0, width=2}}, false}
		,{"source bitmap sourceRectangle horizontally out of bound", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=4, y=0, width=2, height=4}}, false}
		,{"source bitmap sourceRectangle vertically out of bound", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, y=5, width=2, height=4}}, false}
		,{"horizontally out of bound sourceRectangle", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=2, y=0, width=2, height=4}}, false}

		,{"horizontally negative out of bound sourceRectangle", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=-3, y=0, width=2, height=4}}, false}
		,{"vertically out of bound sourceRectangle", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, y=4, width=2, height=4}}, false}
		,{"vertically negative out of bound sourceRectangle", blitTest, {20, 20, [[
**
**
**
**
]], {x = 0, y = 0}, {x=0, y=-5, width=2, height=4}}, false}
		,{"blit whole bitmap", blitTest, {20, 20, [[
******
**  **
**  **
******
]], {x = 0, y = 0}, {x=0, y=0, width=6, height=4}},[[
⣿⣉⣿       
          
          
          
          
]]}
		,{"blit top left part bitmap", blitTest, {20, 20, [[
******
**  **
**  **
******
]], {x = 0, y = 0}, {x=0, y=0, width=3, height=2}},[[
⠛⠁        
          
          
          
          
]]}
		,{"blit bottom left part bitmap", blitTest, {20, 20, [[
******
**  **
**  **
******
]], {x = 0, y = 0}, {x=0, y=2, width=3, height=2}},[[
⠛⠂        
          
          
          
          
]]}
		,{"blit top right part bitmap", blitTest, {20, 20, [[
******
**  **
**  **
******
]], {x = 0, y = 0}, {x=3, y=0, width=3, height=2}},[[
⠙⠃        
          
          
          
          
]]}
		,{"blit bottom right part bitmap", blitTest, {20, 20, [[
******
**  **
**  **
******
]], {x = 0, y = 0}, {x=3, y=2, width=3, height=2}},[[
⠚⠃        
          
          
          
          
]]}
		,{"blit middle part bitmap", blitTest, {20, 20, [[
******
**  **
**  **
******
]], {x = 0, y = 0}, {x=1, y=1, width=4, height=2}},[[
⠃⠘        
          
          
          
          
]]}
		,{"blit part of a big bitmap vertically", blitTest, {20, 20, [[
          
          
          
       
















*   **    
*  * *    
* *  *    
**   *    
          
          
]], {x = 0, y = 0}, {x=0, y=20, width=6, height=4}},[[
⣇⠔⢹       
          
          
          
          
]]}
		,{"blit part of a big bitmap horizontally", blitTest, {20, 20, [[
          
                                                            *   **    
                                                            *  * *    
                                                            * *  *    
                                                            **   *    
          
          
]], {x = 0, y = 0}, {x=60, y=1, width=6, height=4}},[[
⣇⠔⢹       
          
          
          
          
]]}
		,{"blit bigger than destination bitmap horizontally", blitTest, {20, 20, [[
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
]], {x = 0, y = 0}, {x=0, y=0, width=40, height=4}}, [[
⢕⢕⢕⢕⢕⢕⢕⢕⢕⢕
          
          
          
          
]]}
	,{"blit bigger than destination bitmap vertically", blitTest, {20, 20, [[
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
]], {x = 0, y = 0}, {x=0, y=0, width=2, height=40}}, [[
⢕         
⢕         
⢕         
⢕         
⢕         
]]}
	}

	if not doTests("Bitmap:blitSection", tests) then
		return false
	else
		return true
	end
end

function Init()
	if not testConvRawUnicodeValueToUnicode() then return end

	if not testConvBrailleToRawUnicodeValue() then return end

	if not testConvBrailleToUnicode() then return end

	if not testBitmapGetPixel() then return end

	if not testBitmapPutPixel() then return end

	if not testBitmapMarshalRow() then return end

	if not testBitmapRenderToString() then return end

	if not testBitmapDrawBorder() then return end

	if not testBlit() then return end

	if not testBlitSection() then return end
end

function Poll()
	stopGame()
end
