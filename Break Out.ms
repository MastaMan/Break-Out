/*  
[INFO] 

NAME = Break Out
VERSION = 1.0.2
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

global _rBreakOut
global _rBreakOutStart

try(destroyDialog _rBreakOut)catch()
try(destroyDialog _rBreakOutStart)catch()

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
global brickWidth = 40
global brick = #()
global score = 0
global lives = 3
global paddleDirection = 0
global brickCount = 0
global level = 0
global iniFile = ""

rollout _rBreakOut "Break Out - Game" width:600 height:623
(
	checkbutton 'ball' " " pos:[242,345] width:20 height:20 enabled:true checked:true align:#left
	checkbutton 'paddle' "" pos:[103,614] width:100 height:9 checked:true align:#left
	checkbutton 'paddle_ramp' "" pos:[103,608] width:30 height:2 checked:false align:#left
	Timer 'tmrAnimate' "" pos:[13,380] width:24 height:24 interval:2 align:#left
	Timer 'tmrAnimatePaddle' "" pos:[13,380] width:24 height:24 interval:5 align:#left
	Timer 'tmrReset' "" pos:[13,605] width:24 height:24 interval:1000 active:false align:#left
	label 'lblScore' "Score: 0 | Lives: 3" pos:[5,5] width:150 height:13 align:#left
	label 'lblSpeed' "Speed: Normal" pos:[5,25] width:95 height:13 align:#left
	

	button 'brick_29' "" pos:[8,64] width:40 height:20 align:#left
	button 'brick_33' "" pos:[8,88] width:40 height:20 align:#left
	button 'brick_34' "" pos:[8,112] width:40 height:20 align:#left
	button 'brick_35' "" pos:[88,64] width:40 height:20 align:#left
	button 'brick_36' "" pos:[88,88] width:40 height:20 align:#left
	button 'brick_37' "" pos:[88,112] width:40 height:20 align:#left
	button 'brick_38' "" pos:[24,136] width:40 height:20 align:#left
	button 'brick_39' "" pos:[72,136] width:40 height:20 align:#left
	button 'brick_40' "" pos:[48,160] width:40 height:20 align:#left
	button 'brick_41' "" pos:[160,64] width:40 height:20 align:#left
	button 'brick_42' "" pos:[160,88] width:40 height:20 align:#left
	button 'brick_43' "" pos:[160,112] width:40 height:20 align:#left
	button 'brick_44' "" pos:[160,136] width:40 height:20 align:#left
	button 'brick_45' "" pos:[160,160] width:40 height:20 align:#left
	button 'brick_47' "" pos:[272,64] width:40 height:20 align:#left
	button 'brick_48' "" pos:[224,64] width:40 height:20 align:#left
	button 'brick_49' "" pos:[224,88] width:40 height:20 align:#left
	button 'brick_50' "" pos:[224,112] width:40 height:20 align:#left
	button 'brick_51' "" pos:[272,112] width:40 height:20 align:#left
	button 'brick_52' "" pos:[272,136] width:40 height:20 align:#left
	button 'brick_53' "" pos:[272,160] width:40 height:20 align:#left
	button 'brick_54' "" pos:[224,160] width:40 height:20 align:#left
	button 'brick_55' "" pos:[344,64] width:40 height:20 align:#left
	button 'brick_56' "" pos:[344,88] width:40 height:20 align:#left
	button 'brick_57' "" pos:[344,112] width:40 height:20 align:#left
	button 'brick_58' "" pos:[344,136] width:40 height:20 align:#left
	button 'brick_59' "" pos:[344,160] width:40 height:20 align:#left
	button 'brick_60' "" pos:[392,64] width:40 height:20 align:#left
	button 'brick_61' "" pos:[392,160] width:40 height:20 align:#left
	button 'brick_62' "" pos:[456,64] width:40 height:20 align:#left
	button 'brick_63' "" pos:[456,88] width:40 height:20 align:#left
	button 'brick_64' "" pos:[456,112] width:40 height:20 align:#left
	button 'brick_65' "" pos:[456,136] width:40 height:20 align:#left
	button 'brick_66' "" pos:[456,160] width:40 height:20 align:#left
	button 'brick_67' "" pos:[504,64] width:40 height:20 align:#left
	button 'brick_71' "" pos:[504,160] width:40 height:20 align:#left
	button 'brick_72' "" pos:[552,64] width:40 height:20 align:#left
	button 'brick_73' "" pos:[552,88] width:40 height:20 align:#left
	button 'brick_74' "" pos:[552,112] width:40 height:20 align:#left
	button 'brick_75' "" pos:[552,136] width:40 height:20 align:#left
	button 'brick_76' "" pos:[552,160] width:40 height:20 align:#left	
	
	fn resetSettings = 
	(
		 hCanvas = 0
		 wCanvas = 0
		 hBall = 20
		 wBall = 20
		 wPaddle = 100
		 paddleX = 0
		 x = 0
		 y = 0
		 dx = 4
		 dy = -4
		 brickHeight = 20
		 brickWidth = 40
		 brick = #()
		 score = 0
		 lives = 3
		 paddleDirection = 0
		 brickCount = 0
		 level = 0
		 iniFile = ""
	)
	
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
		paddle_ramp.pos.x = paddle.pos.x + (wPaddle / 2) - 15
	)
	
	fn DisplayInfo =
	(
		m = "Score: " + ((level * 100.0) as integer) as string + " | Lives: " + lives as string
		lblScore.caption = m
	)
	
	fn Padding = wBall / 2
	fn PaddlePadding = wPaddle / 2
	
	fn resetState = 
	(
		tmrAnimate.active = true
		tmrAnimatePaddle.active = true
		
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
	global lastHit = 0
		
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
					
					
					f = findItem brick b
					if(f != 0) do deleteItem brick f
					
					a = #()
					a[1] = random -3 -1
					a[2] = random 1 3
					dx += a[random 1 2]
					
					score += 1
					
					if(lastHit == 0) do lastHit = timeStamp()
					
					hit = timeStamp() - lastHit
					lastHit = timeStamp()
					if(hit == 0) do hit = 1000.0
					
					level += (1.0 / (hit / 100.0)) * lives
					
					DisplayInfo()
								
					if(score >= brickCount) do
					(	
						level = level * 100.0
						o = (getIniSetting iniFile "SCOREBOARD" (sysInfo.username)) as float
						if(o == "" or o < level)  do setINISetting iniFile "SCOREBOARD" (sysInfo.username) (level as string)
						
						tmrAnimate.active = false
						tmrAnimatePaddle.active = false
							
						messageBox ("You are win!\n\nLevel: " + (level as integer) as string)  title: "Break Out" beep: false						
						fileIn (getThisScriptFileName())
					) 
				)
			)
		)
		catch()
	)
		
	global oldPaddleX = 0
		
	global currentSpeed = 0.0
	
	on _rBreakOut open do
	(
		resetSettings()
		
		hCanvas = _rBreakOut.height
		wCanvas = _rBreakOut.width
		
		resetState()
		DisplayInfo()
		
		brick = for i in _rBreakOut.controls where matchPattern i.name pattern: "brick_*" collect i
		brickCount = brick.count
		
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
		if(x + dx > wCanvas - Padding() - 10 or x + dx < Padding() + 10) do dx = -dx
	
		if(y + dy < Padding()) do dy = -dy
		if(y + dy > hCanvas - Padding()) do 
		(					
			if(x > paddleX - PaddlePadding() - 10 and x < paddleX + wPaddle - PaddlePadding() + 10) then
			(	
				
				
				if(x > paddleX - 25 and x < paddleX + 25) then 
				(
					currentSpeed -= -1					
					lblSpeed.caption = "Speed: " + abs(currentSpeed) as string
				)
				else
				(
					dy = 3
					currentSpeed = -1
					lblSpeed.caption = "Speed: Normal"
				)
				
				dy = -dy - currentSpeed
				print paddleDirection
				
				dx += paddleDirection				
			)
			else
			(			
				lives -= 1
				
				DisplayInfo()
				
				tmrAnimate.active = false
				tmrAnimatePaddle.active = false
				tmrReset.active = false
				
				if(lives == 0) then
				(
					messageBox "Game Over!" title: "Break Out"					
					fileIn (getThisScriptFileName())
				)
				else
				(
					tmrReset.active = true	
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
			
			if(paddleX > oldPaddleX and oldPaddleX != 0) do paddleDirection = 1
			if(paddleX < oldPaddleX and oldPaddleX != 0) do paddleDirection = -1		
			oldPaddleX = paddleX		
		)
			
		PaddlePos paddleX
	)
	on tmrReset tick do
	(
		resetState()
		tmrReset.active = false
	)
)




rollout _rBreakOutStart "BreakOut - Main Menu" width:600 height:600
(
	button 'btnStart' "Start" pos:[225,437] width:150 height:40 align:#left  
	button 'btnAbout' "About" pos:[225,482] width:150 height:40 align:#left    
	--button 'btnExit' "Exit" pos:[226,526] width:150 height:40 align:#left 
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
		m += "v.1.0.2"
		
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
		uCnt = 1
		for i in scores.count to 1 by -1 do
		(
			z = findItem userScores scores[i]
			if(z != 0 and userScores[z] != undefined) do
			(
				m += uCnt as string + ".  " + users[z] + ": " + (userScores[z] as integer) as string + "\n"	
				uCnt	+= 1
			)
		)
		
		lblScoreBoard.caption = m				
	)
)

createDialog _rBreakOutStart