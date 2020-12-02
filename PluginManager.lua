local toolbar = plugin:CreateToolbar("Sound Volblox")

local build = require(script.ChartBuilder)

local newScriptButton = toolbar:CreateButton(
	"SDVB Asset Compiler",
	"For use only by official SOUND VOLBLOX editor staff.",
	"rbxassetid://610224182"
)

local difficulties = {
	'NORMAL', 'MEGA', 'HYPER', 'SUPER', 'ULTRA', 'OMEGA', 'SHD'
}

newScriptButton.Click:connect(function()
	warn("WARNING: THIS PLUGIN FOR USE ONLY BY TRUSTED SOUND VOLBLOX CHARTING STAFF.")
	warn('Checking all folders...')
	local folders = require(game.ReplicatedStorage.Songs.FolderList)
	warn('There are '..#folders..' song folders.')
	local numSongs = 0
	local numDiff = 0
	local songInfo = {}
	for i = 1, #folders do
		warn('FOLDER: '..folders[i].FOLDER)
		warn('SONGS: '..#folders[i].SONGS)
		numSongs = numSongs+#folders[i].SONGS
		for j = 1, #folders[i].SONGS do
			warn('SONG: '..folders[i].SONGS[j].METADATA.TITLE)
			local songDiffs = {}
			local difficultiesList = ''
			for k = 1, #difficulties do
				if folders[i].SONGS[j].CHARTS[difficulties[k]] then
					table.insert(songDiffs, difficulties[k])
				end
			end
			for k = 1, #songDiffs do
				if (k < #songDiffs) then
					difficultiesList = difficultiesList..songDiffs[k]..', '
				else
					difficultiesList = difficultiesList..songDiffs[k]
				end
			end
			warn('DIFFICULTIES: '..difficultiesList)
			numDiff = numDiff + #songDiffs
			for k = 1, #difficulties do
				if folders[i].SONGS[j].CHARTS[difficulties[k]] then
					warn('DIFFICULTY: '..difficulties[k])
					local success, pass = pcall(function()
						return build.GetNotes(folders[i].SONGS[j].CHARTS[difficulties[k]].CHARTDATA, folders[i].SONGS[j].CHARTS[difficulties[k]].METADATA.BASE32)
					end)
					if success then
						warn('NOTES: '..pass)
						table.insert(songInfo, {song = folders[i].SONGS[j].METADATA.CODE..'/'..(k-1), score = pass*2})
					else
						warn('FAILURE: '..pass)
						table.insert(songInfo, {song = folders[i].SONGS[j].METADATA.CODE..'/'..(k-1), score = 0})
					end
				end
			end
		end
	end
	warn('TOTAL SONGS: '..numSongs)
	warn('TOTAL CHARTS: '..numDiff)
	local container = Instance.new("ModuleScript")
	container.Name = 'ChartScores'
	container.Parent = game.ServerStorage
	local finalSource = 'local module = {\n'
	for i = 1, #songInfo do
		finalSource = finalSource..'\t[\''..songInfo[i].song..'\'] = '..songInfo[i].score..',\n'
	end
	finalSource = finalSource..'}\n\nreturn module'
	container.Source = finalSource
end)