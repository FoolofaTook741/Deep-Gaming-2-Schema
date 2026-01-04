if SERVER then

    util.AddNetworkString("dgQuizRequest")
    util.AddNetworkString("dgQuizData")
    util.AddNetworkString("dgQuizSubmit")
	util.AddNetworkString("dgQuizOpen")
	
	local function lookupQuiz(quizBank)
		local lookup = {}
		for _, question in ipairs(quizBank) do
			if question.id then
				lookup[question.id] = question
			end
		end
		return lookup
	end

    local function SanitizeQuestion(q)
        local safe = {
            id = q.id,
            question = q.question,
            answers = {}
        }
        for i, ans in ipairs(q.answers) do
            table.insert(safe.answers, ans[1])
        end
        return safe
    end

	local function SendQuizData(ply, team)
		local teamData = impulse.Teams.Data[team]
		if not teamData or not teamData.quiz then return end

		local allQuiz = teamData.quiz
		local totalCount = #allQuiz
		local selectedQuiz = {}

		local indices = {}
		for i = 1, totalCount do
			if allQuiz[i].id ~= 998 and allQuiz[i].id ~= 999 then
				table.insert(indices, i)
			end
		end

		for i = #indices, 2, -1 do
			local j = math.random(i)
			indices[i], indices[j] = indices[j], indices[i]
		end

		local count = math.min(10, #indices)
		for i = 1, count do
			local idx = indices[i]
			local question = allQuiz[idx]
			table.insert(selectedQuiz, SanitizeQuestion(question))
		end

		local quizLookup = lookupQuiz(allQuiz)
		table.insert(selectedQuiz, SanitizeQuestion(quizLookup[998]))
		table.insert(selectedQuiz, SanitizeQuestion(quizLookup[999]))
		local sendData = {
			questions = selectedQuiz,
			handbook = teamData.quiz.handbook or ""
		}
		net.Start("dgQuizData")
		net.WriteUInt(team, 8)
		net.WriteTable(sendData)
		net.Send(ply)
	end


    net.Receive("dgQuizRequest", function(len, ply)
        local team = net.ReadUInt(8)
        SendQuizData(ply, team)
    end)

	net.Receive("dgQuizSubmit", function(len, ply)
		ply.quizzing = false

		local teamID = net.ReadUInt(8)
		local selections = net.ReadTable()

		if selections.exit then
			ply:Notify("Quiz exited.")
			return
		end

		local teamData = impulse.Teams.Data[teamID]
		if not teamData or not teamData.quiz then return end

		local quizLookup = lookupQuiz(teamData.quiz)

		local totalQuestions = 0
		local correctAnswers = 0

		for qid, selectedIndex in pairs(selections) do
			local question = quizLookup[qid]
			if question then
				totalQuestions = totalQuestions + 1
				local answerChoice = question.answers[selectedIndex]
				if answerChoice and answerChoice[2] == true then
					correctAnswers = correctAnswers + 1
				end
			end
		end

		local score = totalQuestions > 0 and (correctAnswers / totalQuestions) or 0
		local passed = score >= 0.80

		if passed then
			ply:Notify("Congratulations! You passed the quiz for team " .. (teamData.name or "Unknown"))
			local wlteam = ""
			local steamid = ply:SteamID()
			if teamID == 3 then
				wlteam = "TEAM_CP"
			elseif teamID == 4 then
				wlteam = "TEAM_OTA"
			elseif teamID == 5 then
				wlteam = "TEAM_CA"
			end
			
			if ply:GetTeamWhitelist(wlteam) == 0 then
				ply.impulseData.quiz = ply.impulseData.quiz or {}
				ply.impulseData.quiz[teamID] = { passed = true }
				ply:SaveData()
				ply:Notify("You have passed the quiz. You will not need to retake it again.")

				if ply:CanBecomeTeam(teamID, true) then
					ply:SetTeam(teamID)
					ply:Notify("You have changed your team to "..team.GetName(teamID)..".")
				else
					ply:Notify("You passed the quiz, however "..team.GetName(teamID).." cannot be joined right now. Rejoin the team when it is available to play again.")
				end
			end
		else
			ply.impulseData.quiz = ply.impulseData.quiz or {}
			ply.impulseData.quiz[teamID] = { passed = false, lastAttempt = os.time() }
			ply:SaveData()
			ply:Notify("You failed the quiz for team " .. (teamData.name or "Unknown") .. ". Please wait " .. impulse.Config.QuizWaitTime .. " minutes before trying again.")
		end
	end)
end
