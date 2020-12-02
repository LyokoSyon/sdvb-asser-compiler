local module = {}

local function getBinaryBeatFromHex(beat)
	local result = ""
	local this = beat
	local step = 0
	repeat
		step = step + 1
		local thisChar = string.sub(this, 1, 1)
		if (thisChar == "0") then
			result = result .. "0000"
		elseif (thisChar == "1") then
			result = result .. "0001"
		elseif (thisChar == "2") then
			result = result .. "0010"
		elseif (thisChar == "3") then
			result = result .. "0011"
		elseif (thisChar == "4") then
			result = result .. "0100"
		elseif (thisChar == "5") then
			result = result .. "0101"
		elseif (thisChar == "6") then
			result = result .. "0110"
		elseif (thisChar == "7") then
			result = result .. "0111"
		elseif (thisChar == "8") then
			result = result .. "1000"
		elseif (thisChar == "9") then
			result = result .. "1001"
		elseif (thisChar == "A") then
			result = result .. "1010"
		elseif (thisChar == "B") then
			result = result .. "1011"
		elseif (thisChar == "C") then
			result = result .. "1100"
		elseif (thisChar == "D") then
			result = result .. "1101"
		elseif (thisChar == "E") then
			result = result .. "1110"
		elseif (thisChar == "F") then
			result = result .. "1111"
		end
		this = string.sub(this, 2)
	until string.len(this) <= 0
	
	return result
end

local function getBinaryBeatFrom32(beat)
	local result = ""
	local this = beat
	local step = 0
	repeat
		step = step + 1
		local thisChar = string.sub(this, 1, 1)
		if (thisChar == "0") then
			result = result .. "00000"
		elseif (thisChar == "1") then
			result = result .. "00001"
		elseif (thisChar == "2") then
			result = result .. "00010"
		elseif (thisChar == "3") then
			result = result .. "00011"
		elseif (thisChar == "4") then
			result = result .. "00100"
		elseif (thisChar == "5") then
			result = result .. "00101"
		elseif (thisChar == "6") then
			result = result .. "00110"
		elseif (thisChar == "7") then
			result = result .. "00111"
		elseif (thisChar == "8") then
			result = result .. "01000"
		elseif (thisChar == "9") then
			result = result .. "01001"
		elseif (thisChar == "A") then
			result = result .. "01010"
		elseif (thisChar == "B") then
			result = result .. "01011"
		elseif (thisChar == "C") then
			result = result .. "01100"
		elseif (thisChar == "D") then
			result = result .. "01101"
		elseif (thisChar == "E") then
			result = result .. "01110"
		elseif (thisChar == "F") then
			result = result .. "01111"
		elseif (thisChar == "G") then
			result = result .. "10000"
		elseif (thisChar == "H") then
			result = result .. "10001"
		elseif (thisChar == "I") then
			result = result .. "10010"
		elseif (thisChar == "J") then
			result = result .. "10011"
		elseif (thisChar == "K") then
			result = result .. "10100"
		elseif (thisChar == "L") then
			result = result .. "10101"
		elseif (thisChar == "M") then
			result = result .. "10110"
		elseif (thisChar == "N") then
			result = result .. "10111"
		elseif (thisChar == "O") then
			result = result .. "11000"
		elseif (thisChar == "P") then
			result = result .. "11001"
		elseif (thisChar == "Q") then
			result = result .. "11010"
		elseif (thisChar == "R") then
			result = result .. "11011"
		elseif (thisChar == "S") then
			result = result .. "11100"
		elseif (thisChar == "T") then
			result = result .. "11101"
		elseif (thisChar == "U") then
			result = result .. "11110"
		elseif (thisChar == "V") then
			result = result .. "11111"
		end
		this = string.sub(this, 2)
	until string.len(this) <= 0
	
	return result
end

local function getBeatFromBinary(bitstream)
	local beat = {
		tonumber(string.sub(bitstream, 3, 5), 2),
		tonumber(string.sub(bitstream, 6, 8), 2),
		tonumber(string.sub(bitstream, 9, 11), 2),
		tonumber(string.sub(bitstream, 12, 14), 2),
		
		tonumber(string.sub(bitstream, 15, 17), 2),
		tonumber(string.sub(bitstream, 18, 21), 2),
		
		tonumber(string.sub(bitstream, 22, 24), 2),
		tonumber(string.sub(bitstream, 25, 25), 2),
		tonumber(string.sub(bitstream, 26, 26), 2),
		tonumber(string.sub(bitstream, 27, 30), 2),
		tonumber(string.sub(bitstream, 31, 38), 2),
		tonumber(string.sub(bitstream, 39, 46), 2),
		
		tonumber(string.sub(bitstream, 47, 63), 2),
		
		tonumber(string.sub(bitstream, 64, 70), 2),
		tonumber(string.sub(bitstream, 71, 77), 2),
		
		tonumber(string.sub(bitstream, 78, 93), 2),
		
		tonumber(string.sub(bitstream, 94, 100), 2)
	}
	return beat
end

local function getBeatsFromBinary(bitstream, baseType)
	local chart = {}
	local stream = bitstream
	local step = 0
	repeat
		if (baseType == 16) then
			table.insert(chart, getBeatFromBinary(getBinaryBeatFromHex(string.sub(stream, 1, 25))))
			stream = string.sub(stream, 26)
		elseif (baseType == 32) then
			table.insert(chart, getBeatFromBinary(getBinaryBeatFrom32(string.sub(stream, 1, 20))))
			stream = string.sub(stream, 21)
		end
	until string.len(stream) <= 0
	return chart
end

local function buildTap()
	return 1
end

local function buildHold()
	return 1
end

local function buildHoldEnd()
	return 1
end

local function buildSlam(data)
	if data.duration > 0 then return 2 else return 1 end
end

local function buildChart(chart, isBase32)
	print('building...')
	local baseType = 16
	if isBase32 then
		baseType = 32
	end
	local beats = getBeatsFromBinary(chart, baseType)
	local notes = {}
	
	local timeMap = {}
	local meterMap = {}
	
	local timeBuild = 0
	local lastTime = 0
	local lastMeasureTime = 0
	local measureTime = 0
	local timeSinceLastBPMChange = 0
	local currentBPM = beats[1][13]/100
	local currentMeter = beats[1][17]
	local timePerBeat = ((60/currentBPM)/12)
	
	local beatTime = 0
	
	local latestNoteTime = 0
	
	local holdStatus = {
		l = {mTime = 0, rTime = 0, duration = 0, holding = false}, 
		cl = {mTime = 0, rTime = 0, duration = 0, holding = false}, 
		cr = {mTime = 0, rTime = 0, duration = 0, holding = false}, 
		r = {mTime = 0, rTime = 0, duration = 0, holding = false}, 
		fx = {mTime = 0, rTime = 0, filter = 0, duration = 0, holding = false}, 
		sl = {mTime = 0, rTime = 0, startPos = 0, endPos = 0, direction = 0, spin = 0, duration = 0, holding = false}, 
	}
	
	for i = 1, #beats do
		
		if (beats[i][1] == 1) then
			table.insert(notes, buildTap({lane = 1, variant = 1, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][2] == 1) then
			table.insert(notes, buildTap({lane = 2, variant = 1, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][3] == 1) then
			table.insert(notes, buildTap({lane = 3, variant = 1, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][4] == 1) then
			table.insert(notes, buildTap({lane = 4, variant = 1, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][5] == 1) then
			table.insert(notes, buildTap({lane = 5, variant = 1, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		
		if (beats[i][1] == 4) then
			table.insert(notes, buildTap({lane = 1, variant = 4, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][2] == 4) then
			table.insert(notes, buildTap({lane = 2, variant = 4, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][3] == 4) then
			table.insert(notes, buildTap({lane = 3, variant = 4, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][4] == 4) then
			table.insert(notes, buildTap({lane = 4, variant = 4, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][5] == 4) then
			table.insert(notes, buildTap({lane = 5, variant = 4, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		
		if (beats[i][5] == 5) then
			table.insert(notes, buildTap({lane = 5, variant = 5, mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		
		if (beats[i][1] == 2) then
			holdStatus.l.mTime = measureTime/12
			holdStatus.l.rTime = timeBuild
			holdStatus.l.holding = true
		end
		if (beats[i][2] == 2) then
			holdStatus.cl.mTime = measureTime/12
			holdStatus.cl.rTime = timeBuild
			holdStatus.cl.holding = true
		end
		if (beats[i][3] == 2) then
			holdStatus.cr.mTime = measureTime/12
			holdStatus.cr.rTime = timeBuild
			holdStatus.cr.holding = true
		end
		if (beats[i][4] == 2) then
			holdStatus.r.mTime = measureTime/12
			holdStatus.r.rTime = timeBuild
			holdStatus.r.holding = true
		end
		if (beats[i][5] == 2) then
			holdStatus.fx.mTime = measureTime/12
			holdStatus.fx.rTime = timeBuild
			holdStatus.fx.filter = beats[i][6]
			holdStatus.fx.holding = true
		end
		
		if (beats[i][1] == 3) then
			holdStatus.l.holding = false
			table.insert(notes, buildHold({lane = 1, duration = holdStatus.l.duration/12, mTime = holdStatus.l.mTime, rTime = holdStatus.l.rTime}))
			table.insert(notes, buildHoldEnd({lane = 1, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][2] == 3) then
			holdStatus.cl.holding = false
			table.insert(notes, buildHold({lane = 2, duration = holdStatus.cl.duration/12, mTime = holdStatus.cl.mTime, rTime = holdStatus.cl.rTime}))
			table.insert(notes, buildHoldEnd({lane = 2, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][3] == 3) then
			holdStatus.cr.holding = false
			table.insert(notes, buildHold({lane = 3, duration = holdStatus.cr.duration/12, mTime = holdStatus.cr.mTime, rTime = holdStatus.cr.rTime}))
			table.insert(notes, buildHoldEnd({lane = 3, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][4] == 3) then
			holdStatus.r.holding = false
			table.insert(notes, buildHold({lane = 4, duration = holdStatus.r.duration/12, mTime = holdStatus.r.mTime, rTime = holdStatus.r.rTime}))
			table.insert(notes, buildHoldEnd({lane = 4, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][5] == 3) then
			holdStatus.fx.holding = false
			table.insert(notes, buildHold({lane = 5, duration = holdStatus.fx.duration/12, mTime = holdStatus.fx.mTime, rTime = holdStatus.fx.rTime, filter = holdStatus.fx.filter}))
			table.insert(notes, buildHoldEnd({lane = 5, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		
		-- direction, spin, filter, duration, startPos, endPos, measureTime (mTime), realTime (rTime)
		if (beats[i][7] == 1) then
			table.insert(notes, buildSlam({direction = beats[i][8], spin = beats[i][9], filter = beats[i][10], duration = 0, startPos = beats[i][11], endPos = beats[i][12], mTime = measureTime/12, rTime = timeBuild}))
			latestNoteTime = timeBuild
		end
		if (beats[i][7] == 2) then
			if not holdStatus.sl.holding then
				holdStatus.sl.holding = true
				holdStatus.sl.mTime = measureTime/12
				holdStatus.sl.rTime = timeBuild
				holdStatus.sl.filter = beats[i][10]
				holdStatus.sl.direction = beats[i][8]
				holdStatus.sl.spin = beats[i][9]
				holdStatus.sl.startPos = beats[i][11]
				holdStatus.sl.endPos = beats[i][12]
			else
				table.insert(notes, buildSlam({direction = holdStatus.sl.direction, spin = holdStatus.sl.spin, filter = holdStatus.sl.filter, duration = holdStatus.sl.duration/12, startPos = holdStatus.sl.startPos, endPos = holdStatus.sl.endPos, mTime = holdStatus.sl.mTime, rTime = holdStatus.sl.rTime}))
				latestNoteTime = timeBuild
				
				holdStatus.sl.mTime = measureTime/12
				holdStatus.sl.rTime = timeBuild
				holdStatus.sl.filter = beats[i][10]
				holdStatus.sl.direction = beats[i][8]
				holdStatus.sl.spin = beats[i][9]
				holdStatus.sl.startPos = beats[i][11]
				holdStatus.sl.endPos = beats[i][12]
				holdStatus.sl.duration = 0
			end
		end
		if (beats[i][7] == 3) then
			holdStatus.sl.holding = false
			table.insert(notes, buildSlam({direction = holdStatus.sl.direction, spin = holdStatus.sl.spin, filter = holdStatus.sl.filter, duration = math.floor(holdStatus.sl.duration/12), startPos = holdStatus.sl.startPos, endPos = holdStatus.sl.endPos, mTime = holdStatus.sl.mTime, rTime = holdStatus.sl.rTime}))
			if (holdStatus.sl.direction == 1) then
				table.insert(notes, buildHoldEnd({lane = 7, rTime = timeBuild}))
			else
				table.insert(notes, buildHoldEnd({lane = 6, rTime = timeBuild}))
			end
			latestNoteTime = timeBuild
		end
		
		if (holdStatus.l.holding) then
			holdStatus.l.duration = holdStatus.l.duration + 1
		else
			holdStatus.l.duration = 0
		end
		
		if (holdStatus.cl.holding) then
			holdStatus.cl.duration = holdStatus.cl.duration + 1
		else
			holdStatus.cl.duration = 0
		end
		
		if (holdStatus.cr.holding) then
			holdStatus.cr.duration = holdStatus.cr.duration + 1
		else
			holdStatus.cr.duration = 0
		end
		
		if (holdStatus.r.holding) then
			holdStatus.r.duration = holdStatus.r.duration + 1
		else
			holdStatus.r.duration = 0
		end
		
		if (holdStatus.fx.holding) then
			holdStatus.fx.duration = holdStatus.fx.duration + 1
		else
			holdStatus.fx.duration = 0
		end
		
		if (holdStatus.sl.holding) then
			holdStatus.sl.duration = holdStatus.sl.duration + 1
		else
			holdStatus.sl.duration = 0
		end
		
		if ((beats[i][13]/100 ~= currentBPM) and (beats[i][13] ~= 0) and (beats[i][13]/100 <= 1000)) or (beats[i][16] ~= 0) then
			if ((beats[i][13]/100 ~= currentBPM) and (beats[i][13]/100 ~= 0) and (beats[i][13]/100 <= 1000)) then
				local change = {
					lastTime = lastTime,
					changeTime = timeBuild,
					measureTime = lastMeasureTime/12,
					changeMeasure = measureTime/12,
					lastBPM = currentBPM,
					timeBPM = beats[i][13]/100,
					timeBetween = timeSinceLastBPMChange/12
				}
				currentBPM = beats[i][13]/100
				timePerBeat = ((60/currentBPM)/12)
				--print('change built: '..change.lastTime.." | "..change.changeTime.." | "..change.measureTime.." | "..change.changeMeasure.." | "..change.timeBPM.." | "..change.timeBetween)
				lastTime = timeBuild
				lastMeasureTime = measureTime
				table.insert(timeMap, change)
				timeSinceLastBPMChange = 0
			end
			if (beats[i][16] ~= 0) then
				local BPMchange = {
					lastTime = lastTime,
					changeTime = timeBuild,
					measureTime = lastMeasureTime/12,
					changeMeasure = measureTime/12,
					timeBPM = currentBPM,
					lastBPM = currentBPM,
					timeBetween = timeSinceLastBPMChange/12
				}
				--print('change built: '..BPMchange.lastTime.." | "..BPMchange.changeTime.." | "..BPMchange.measureTime.." | "..BPMchange.changeMeasure.." | "..BPMchange.timeBPM.." | "..BPMchange.timeBetween)
				
				local STOPchange = {
					lastTime = timeBuild,
					changeTime = timeBuild+(beats[i][16]/1000),
					measureTime = measureTime/12,
					changeMeasure = measureTime/12,
					timeBPM = currentBPM,
					lastBPM = 0,
					timeBetween = 0
				}
				--print('stop built: '..STOPchange.lastTime.." | "..STOPchange.changeTime.." | "..STOPchange.measureTime.." | "..STOPchange.changeMeasure.." | "..STOPchange.timeBPM.." | "..STOPchange.timeBetween)
				
				timeBuild = timeBuild + (beats[i][16]/1000)
				lastTime = timeBuild
				lastMeasureTime = measureTime
				timeSinceLastBPMChange = 0
				table.insert(timeMap, BPMchange)
				table.insert(timeMap, STOPchange)
			end
		end
		
		if (beats[i][17] ~= currentMeter) and (beats[i][17] ~= 0) then
			currentMeter = beats[i][17]
			table.insert(meterMap, i)
		end
		
		timeBuild = timeBuild + timePerBeat
		measureTime = measureTime + 1
		timeSinceLastBPMChange = timeSinceLastBPMChange + 1
	end
	
	--print('latest time in chart: '..latestNoteTime)
	
	local timeBuild = 0
	local lastTime = 0
	local lastMeasureTime = 0
	local measureTime = 0
	local timeSinceLastBPMChange = 0
	local currentBPM = beats[1][13]/100
	local currentMeter = beats[1][17]
	local timePerBeat = ((60/currentBPM)/12)
	
	local beatTime = 0
	
	for i = 1, #beats do
		
		if ((beats[i][13]/100 ~= currentBPM) and (beats[i][13] ~= 0)) or (beats[i][16] ~= 0) then
			if ((beats[i][13]/100 ~= currentBPM) and (beats[i][13]/100 ~= 0)) then
				currentBPM = beats[i][13]/100
				timePerBeat = ((60/currentBPM)/12)
				lastTime = timeBuild
				lastMeasureTime = measureTime
				timeSinceLastBPMChange = 0
			end
			if (beats[i][16] ~= 0) then
				timeBuild = timeBuild + beats[i][16]/1000
				lastTime = timeBuild
				lastMeasureTime = measureTime
				timeSinceLastBPMChange = 0
			end
		end
		
		if (beats[i][17] ~= currentMeter) and (beats[i][17] ~= 0) then
			currentMeter = beats[i][17]
		end
		
		timeBuild = timeBuild + timePerBeat
		measureTime = measureTime + 1
		timeSinceLastBPMChange = timeSinceLastBPMChange + 1
		
	end
	
	print('build complete')
	
	return notes
	
end

module.GetNotes = function(chart, isBase32)
	local notes = buildChart(chart, isBase32)
	local totalNotes = 0
	for i = 1, #notes do
		totalNotes = totalNotes + notes[i]
	end
	return totalNotes
end

return module
