--------------------
--- BadgerVoting ---
--------------------

voteOptions = {}
voteNames = {}
voteInProgress = false
numChoices = 0;
RegisterCommand(Config.StartVoteCommand, function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.StartVoteAcePermission) then 
		-- Can start one 
		if not voteInProgress then 
			voteOptions = {}
			voteNames = {}
			numChoices = 0;
			votedAlready = {}
			-- No current vote in progress, they can start one 
			-- /startVote <seconds> <options>
			-- /startVote 30 Los-Santos Sandy-Shores Grapeseed
			if #args > 2 then 
				if tonumber(args[1]) ~= nil then 
					-- It's a number of seconds for voting 
					local secs = tonumber(args[1]);
					local startMessage = Config.Messages.VoteStarted
					if secs >= 60 then
						local time = secs / 60

						if time > math.floor(time) then
							time = round(time, 1)
						else
							time = math.ceil(time)
						end

						startMessage = startMessage:gsub("{TIME}", time .. ' minute(s)')
					else
						startMessage = startMessage:gsub("{TIME}", secs .. ' second(s)')
					end

					voteInProgress = true;

					sendMsg(-1, startMessage)

					for i=2, #args do 
						TriggerClientEvent('chatMessage', -1, '^6[^7' .. args[i] .. '^6]^3: /vote ' .. (i - 1))
						numChoices = numChoices + 1;
						voteOptions[(i - 1)] = 0;
						voteNames[(i - 1)] = args[i];
					end

					Wait(secs * 1000);

					local highestVoteCount = voteOptions[1]
					local highestVoteName = voteNames[1]

					for i=1, numChoices do 
						if voteOptions[i] > highestVoteCount then 
							highestVoteCount = voteOptions[i]
							highestVoteName = voteNames[i]
						end
					end

					local voteConcluded = Config.Messages.VoteConcluded
					voteConcluded = voteConcluded:gsub("{VOTE}", highestVoteName)
					voteConcluded = voteConcluded:gsub("{VOTE_COUNT}", highestVoteCount)

					sendMsg(-1, voteConcluded)

					voteInProgress = false;
				else 
					-- Not a valid number supplied
					sendMsg(source, '^1ERROR: That is not a valid number...')
				end
			else 
				-- Not enough arguments, need at least 2 choices
				sendMsg(source, '^1ERROR: You need at least 2 choices... /' .. Config.StartVoteCommand .. ' <seconds> Los-Santos Sandy-Shores')
			end
		else
			--There is already a vote in progress.
			sendMsg(source, '^1ERROR: There is already a vote in progress!')
		end
	end
end)

function sendMsg(src, msg) 
	TriggerClientEvent('chatMessage', src, Config.Prefix .. msg);
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end


votedAlready = {}
RegisterCommand('vote', function(source, args, rawCommand)
	if voteInProgress then 
		if not has_value(votedAlready, source) then 
			if #args > 0 then 
				if tonumber(args[1]) ~= nil then 
					-- It's a number 
					voteOptions[tonumber(args[1])] = voteOptions[tonumber(args[1])] + 1;

					local voteRecorded = Config.Messages.VoteRecorded
					voteRecorded = voteRecorded:gsub("{OPTION}", voteNames[tonumber(args[1])])

					sendMsg(source, voteRecorded)
					table.insert(votedAlready, source);
				else 
					-- It's not a number 
					sendMsg(source, '^1ERROR: That is not a valid number...')
				end
			else
				-- They did not supply enough arguments 
				sendMsg(source, '^1ERROR: You need to do /vote <id>')
			end
		else 
			-- Already voted 
			sendMsg(source, Config.Messages.AlreadyVoted)
		end
	else 
		-- There is no vote in progress 
		sendMsg(source, Config.Messages.NoVoteInProgress)
	end
end)