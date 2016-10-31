/*  
[INFO] 

NAME = Break Out
VERSION = 1.0.0
AUTHOR = Vasily Lukyanenko
DEV = VISCO
HELP = 

[INSTALL]

MACRO=BreakOut
CAT=VISCO
TEXT=Break Out
ICON=

[1.0.0]

* First release =

[ABOUT]

Simple small game=

[TEST]

[SCRIPT]
*/	

try(destroyDialog _rBreakOut)catch()
try(destroyDialog _rBreakOutStart)catch()

rollout _rBreakOut "Break Out - Game" width:600 height:604
(
	checkbutton 'ball' "^" pos:[242,345] width:20 height:20 enabled:true checked:true align:#left
	checkbutton 'paddle' "" pos:[103,591] width:100 height:9 checked:true align:#left
	Timer 'tmrAnimate' "" pos:[13,380] width:24 height:24 interval:2 align:#left
	Timer 'tmrAnimatePaddle' "" pos:[13,380] width:24 height:24 interval:5 align:#left
	label 'lblScore' "Score: 0 | Lives: 3" pos:[5,5] width:300 height:13 align:#left
			
	button 'brick_86' "" pos:[67,135] width:90 height:20 align:#left
	button 'brick_87' "" pos:[205,135] width:90 height:20 align:#left
	button 'brick_88' "" pos:[305,135] width:90 height:20 align:#left
	button 'brick_89' "" pos:[444,135] width:90 height:20 align:#left
	button 'brick_92' "" pos:[67,161] width:90 height:20 align:#left
	button 'brick_93' "" pos:[205,161] width:90 height:20 align:#left
	button 'brick_94' "" pos:[305,161] width:90 height:20 align:#left
	button 'brick_95' "" pos:[444,161] width:90 height:20 align:#left
	button 'brick_98' "" pos:[67,187] width:90 height:20 align:#left
	button 'brick_99' "" pos:[205,187] width:90 height:20 align:#left
	button 'brick_100' "" pos:[305,187] width:90 height:20 align:#left
	button 'brick_101' "" pos:[444,187] width:90 height:20 align:#left
	button 'brick_122' "" pos:[67,57] width:90 height:20 align:#left
	button 'brick_123' "" pos:[205,57] width:90 height:20 align:#left
	button 'brick_124' "" pos:[305,57] width:90 height:20 align:#left
	button 'brick_125' "" pos:[444,57] width:90 height:20 align:#left
	button 'brick_128' "" pos:[67,83] width:90 height:20 align:#left
	button 'brick_129' "" pos:[205,83] width:90 height:20 align:#left
	button 'brick_130' "" pos:[305,83] width:90 height:20 align:#left
	button 'brick_131' "" pos:[444,83] width:90 height:20 align:#left
	button 'brick_134' "" pos:[67,109] width:90 height:20 align:#left
	button 'brick_135' "" pos:[205,109] width:90 height:20 align:#left
	button 'brick_136' "" pos:[305,109] width:90 height:20 align:#left
	button 'brick_137' "" pos:[444,109] width:90 height:20 align:#left
	
	global hCanvas = 0
	global wCanvas = 0
	global hBall = 20
	global wBall = 20
	global wPaddle = 100
	global paddleX = 0
	global x = 0
	global y = 0
	global dx = 4
	global dy = -4
	global brickHeight = 20
	global brickWidth = 90
	global brick = #()
	global score = 0
	global lives = 3
	global paddleDirection = 0
	
	global iniFile = ""
	
	fn BallPos x y = 
	(
		try
		(
			ball.pos.x = x - wBall / 2
			ball.pos.y = y - hBall / 2
		)
		catch()
	)
	
	fn PaddlePos x = 
	(
		paddle.pos.x = x - wPaddle / 2
	)
	
	fn DisplayInfo =
	(
		m = "Score: " + score as string + " | Lives: " + lives as string
		lblScore.caption = m
	)
	
	fn Padding = wBall / 2
	fn PaddlePadding = wPaddle / 2
	
	fn resetState = 
	(
		x = random 50 (wCanvas - 50)
		y = hCanvas - 15

		BallPos x y

		paddleX = wCanvas / 2
		PaddlePos paddleX

		a = #()
		a[1] = random -5 -1
		a[2] = random  1 5
		dx = a[random 1 2]
		
		dy = -4
	)

	global hit = 0
	global lastHit = timeStamp()
	fn CollisionDetect =
	(
		try(
			for b in brick do
			(
				if((x > b.pos.x or x + 10 > b.pos.x or x - 10 > b.pos.x) and 
				(x < b.pos.x + brickWidth or x + 10 < b.pos.x + brickWidth or x - 10 < b.pos.x + brickWidth) and 
				(y > b.pos.y or y + 10 > b.pos.y or y - 10 > b.pos.y) and 
				(y < b.pos.y + brickHeight or y - 10 < b.pos.y + brickHeight or y + 10 < b.pos.y + brickHeight)) do
				(
					dy = -dy
					b.pos.y = -1000
					a = #()
					a[1] = random -3 -1
					a[2] = random 1 3
					dx += a[random 1 2]
					print dx
					score += 1
					if(lastHit == 0) then lastHit = timeStamp() else hit += timeStamp() - lastHit
								
					
					level = abs((1000.0 - (hit / 1000.0)) * lives)
									
					DisplayInfo()
								
					if(score >= brick.count) do
					(				
						o = (getIniSetting iniFile "SCOREBOARD" (sysInfo.username)) as float
						if(o == "" or o < level)  do setINISetting iniFile "SCOREBOARD" (sysInfo.username) (level as string)
						
						messageBox ("You are win!\n\nLevel: " + (level as integer) as string)  title: "Break Out" beep: false
						resetState()
						fileIn (getThisScriptFileName())
					) 
				)
			)
		)
		catch()
	)
		
	global oldPaddleX = 0
	
	on _rBreakOut open do
	(
		hCanvas = _rBreakOut.height
		wCanvas = _rBreakOut.width
		
		resetState()
		DisplayInfo()
		
		brick = for i in _rBreakOut.controls where matchPattern i.name pattern: "brick_*" collect i
			
		d = getFilenamePath  (getThisScriptFilename())
		n = filenameFromPath (getThisScriptFilename())			
		iniFile = d + @"ini\" + n + ".ini"
	)
	on _rBreakOut close do
	(
		tmrAnimate.active = false
		tmrAnimatePaddle.active = false
		createDialog _rBreakOutStart
	)
	on tmrAnimate tick do
	(	
		if(x + dx > wCanvas - Padding() or x + dx < Padding()) do dx = -dx
	
		if(y + dy < Padding()) do dy = -dy
		if(y + dy > hCanvas - Padding()) do 
		(					
			if(x > paddleX - PaddlePadding() and x < paddleX + wPaddle - PaddlePadding()) then
			(				
				dy = -dy
				dx += paddleDirection
			)
			else
			(			
				lives -= 1
				
				DisplayInfo()
				
				resetState()
								
				if(lives == 0) do
				(
					messageBox "Game Over!" title: "Break Out"
					fileIn (getThisScriptFileName())
				)
			)
		)	
			
		x += dx
		y += dy
		
		CollisionDetect()
		
		BallPos x y
	)
	on tmrAnimatePaddle tick do
	(
		dialogPos = getDialogPos _rBreakOut			
		t = mouse.screenpos.x - dialogPos.x
		
		if(t > 0 and t < wCanvas)  do 
		(	
			paddleX = t
	
			if(paddleX > oldPaddleX) do paddleDirection = 1
			if(paddleX < oldPaddleX) do paddleDirection = -1
			
			
		)
	
		PaddlePos paddleX
	)
)




rollout _rBreakOutStart "BreakOut - Main Menu" width:600 height:600
(
	button 'btnStart' "Start" pos:[225,437] width:150 height:40 align:#left  
	button 'btnAbout' "About" pos:[225,482] width:150 height:40 align:#left    
	button 'btnExit' "Exit" pos:[226,526] width:150 height:40 align:#left 
	label 'lblInfo' "BreakOut by Vasily Lukyanenko" pos:[227,577] width:150 height:13 align:#left
	groupBox 'grp1' "Leader Board" pos:[11,10] width:578 height:411 align:#left
	label 'lblScoreBoard' "" pos:[26,31] width:553 height:378 align:#left
	
	on btnExit pressed do
	(
		try(destroyDialog _rBreakOut)catch()
		try(destroyDialog _rBreakOutStart)catch()
	)
	
	on btnAbout pressed do
	(
		n = "\n"
		m = "BreakOut" + n + n
		m += "by Vasily Lukyanenko" +n
		m += "v.1.0.0"
		
		messageBox m title: "BreakOut" beep: false
	)
	
	on btnStart pressed do
	(
		createDialog _rBreakOut
		try(destroyDialog _rBreakOutStart)catch()
	)
	
	on _rBreakOutStart open do
	(
		d = getFilenamePath  (getThisScriptFilename())
		n = filenameFromPath (getThisScriptFilename())			
		iniFile = d + @"ini\" + n + ".ini"
			
		users = getIniSetting iniFile "SCOREBOARD"
		
		scores = #()
		userScores = #()
		
		for u in users do
		(	
			s = (getIniSetting iniFile "SCOREBOARD" u) as float
			append scores s
			append userScores s
		)
		
		sort scores
		m = ""	
		
		for i in scores.count to 1 by -1 do
		(
			z = findItem userScores scores[i]
			if(z != 0) do
			(
				m += users[i] + ": " + (scores[i] as integer) as string + "\n"								
			)
		)
		
		lblScoreBoard.caption = m
		
		print m
	)
)

createDialog _rBreakOutStart