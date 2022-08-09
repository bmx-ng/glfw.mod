' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow
Import "../shader.bmx"

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.JpgLoader
Import BRL.PngLoader
Import BRL.StandardIO

Local app_name:String = "Camera Keyboard DT"

Const SCR_WIDTH:UInt	= 800
Const SCR_HEIGHT:UInt	= 600

' camera
Global cameraPos:SVec3F= New SVec3F(0.0, 0.0, 3.0)
Global cameraFront:SVec3F= New SVec3F(0.0, 0.0, -1.0)
Global cameraUp:SVec3F= New SVec3F(0.0, 1.0, 0.0)

' timing
Global deltaTime:Float ' time between current frame and last frame
Global lastFrame:Float


Type TGameWindow Extends TGLFWWindow
	
	' whenever the window size changed (by OS or user resize) this callback method executes
	Method OnFrameBufferSize (width:Int, height:Int)
		' make sure the viewport matches the new window dimensions; note that width and 
		' height will be significantly larger than specified on retina displays.
		glViewport (0, 0, width, height)
	EndMethod
	
EndType

' process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
Function ProcessInput (window:TGLFWWindow)
	
	If window.IsKeyDown (GLFW_KEY_ESCAPE)
		window.SetShouldClose (True)
	EndIf
	
	Local cameraSpeed:Float = 2.5 * deltaTime
	If window.IsKeyDown(GLFW_KEY_W) Then
		cameraPos = cameraPos + (cameraFront * cameraSpeed)
	End If
	If window.IsKeyDown(GLFW_KEY_S) Then
		cameraPos = cameraPos - (cameraFront * cameraSpeed)
	End If
	If window.IsKeyDown(GLFW_KEY_A) Then
		cameraPos = cameraPos - (cameraFront.Cross(cameraUp).Normal() * cameraSpeed)
	End If
	If window.IsKeyDown(GLFW_KEY_D) Then
		cameraPos = cameraPos + (cameraFront.Cross(cameraUp).Normal() * cameraSpeed)
	End If
EndFunction

' glfw: initialize and configure
TGLFWWindow.Hint (GLFW_CONTEXT_VERSION_MAJOR, 3)
TGLFWWindow.Hint (GLFW_CONTEXT_VERSION_MINOR, 3)
TGLFWWindow.Hint (GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)

?MacOS ' Ewww...
	TGLFWWindow.Hint (GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)
?

' glfw window creation
Local window:TGLFWWindow = New TGameWindow.Create (SCR_WIDTH, SCR_HEIGHT, app_name)

If Not window
	Print "Failed to create GLFW window!"
	End
EndIf

window.MakeContextCurrent ()

' glad: load all OpenGL function pointers
gladLoadGL (glfwGetProcAddress)

' configure global opengl state
glEnable(GL_DEPTH_TEST)

' build and compile our shader program
Local ourShader:TShader = New TShader("7.2.camera.vs", "7.2.camera.fs")

' set up vertex data (and buffer(s)) and configure vertex attributes
Local vertices:Float [] = [..
	-0.5, -0.5, -0.5,  0.0, 0.0, ..
	 0.5, -0.5, -0.5,  1.0, 0.0, ..
	 0.5,  0.5, -0.5,  1.0, 1.0, ..
	 0.5,  0.5, -0.5,  1.0, 1.0, ..
	-0.5,  0.5, -0.5,  0.0, 1.0, ..
	-0.5, -0.5, -0.5,  0.0, 0.0, ..
	 ..
	-0.5, -0.5,  0.5,  0.0, 0.0, ..
	 0.5, -0.5,  0.5,  1.0, 0.0, ..
	 0.5,  0.5,  0.5,  1.0, 1.0, ..
	 0.5,  0.5,  0.5,  1.0, 1.0, ..
	-0.5,  0.5,  0.5,  0.0, 1.0, ..
	-0.5, -0.5,  0.5,  0.0, 0.0, ..
	 ..
	-0.5,  0.5,  0.5,  1.0, 0.0, ..
	-0.5,  0.5, -0.5,  1.0, 1.0, ..
	-0.5, -0.5, -0.5,  0.0, 1.0, ..
	-0.5, -0.5, -0.5,  0.0, 1.0, ..
	-0.5, -0.5,  0.5,  0.0, 0.0, ..
	-0.5,  0.5,  0.5,  1.0, 0.0, ..
	 ..
	 0.5,  0.5,  0.5,  1.0, 0.0, ..
	 0.5,  0.5, -0.5,  1.0, 1.0, ..
	 0.5, -0.5, -0.5,  0.0, 1.0, ..
	 0.5, -0.5, -0.5,  0.0, 1.0, ..
	 0.5, -0.5,  0.5,  0.0, 0.0, ..
	 0.5,  0.5,  0.5,  1.0, 0.0, ..
	 ..
	-0.5, -0.5, -0.5,  0.0, 1.0, ..
	 0.5, -0.5, -0.5,  1.0, 1.0, ..
	 0.5, -0.5,  0.5,  1.0, 0.0, ..
	 0.5, -0.5,  0.5,  1.0, 0.0, ..
	-0.5, -0.5,  0.5,  0.0, 0.0, ..
	-0.5, -0.5, -0.5,  0.0, 1.0, ..
	 ..
	-0.5,  0.5, -0.5,  0.0, 1.0, ..
	 0.5,  0.5, -0.5,  1.0, 1.0, ..
	 0.5,  0.5,  0.5,  1.0, 0.0, ..
	 0.5,  0.5,  0.5,  1.0, 0.0, ..
	-0.5,  0.5,  0.5,  0.0, 0.0, ..
	-0.5,  0.5, -0.5,  0.0, 1.0]

' world space positions of our cubes
Local cubePositions:SVec3F[] = [ ..
	New SVec3F( 0.0,  0.0,  0.0), ..
	New SVec3F( 2.0,  5.0, -15.0), ..
	New SVec3F(-1.5, -2.2, -2.5), ..
	New SVec3F(-3.8, -2.0, -12.3), ..
	New SVec3F( 2.4, -0.4, -3.5), ..
	New SVec3F(-1.7,  3.0, -7.5), ..
	New SVec3F( 1.3, -2.0, -2.5), ..
	New SVec3F( 1.5,  2.0, -2.5), ..
	New SVec3F( 1.5,  0.2, -1.5), ..
	New SVec3F(-1.3,  1.0, -1.5) ..
]

Local VBO:UInt
Local VAO:UInt

glGenVertexArrays (1, Varptr VAO)
glGenBuffers (1, Varptr VBO)

' bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
glBindVertexArray (VAO)

glBindBuffer (GL_ARRAY_BUFFER, VBO)
glBufferData (GL_ARRAY_BUFFER, Int(vertices.length * SizeOf (0:Float)), vertices, GL_STATIC_DRAW)

' position attribute
glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, Int(5 * SizeOf (0:Float)), 0:Byte Ptr)
glEnableVertexAttribArray (0)

Local attribute_offset:Int = 3 * SizeOf (0:Float)

' texture coord attribute
glVertexAttribPointer (1, 2, GL_FLOAT, GL_FALSE, Int(5 * SizeOf (0:Float)), Byte Ptr (attribute_offset))
glEnableVertexAttribArray (1)

' load and create a texture
' -------------------------
Local texture1:UInt
Local texture2:UInt

' texture 1
' ---------
glGenTextures(1, Varptr texture1)
glBindTexture(GL_TEXTURE_2D, texture1)

' set the texture wrapping parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)

' set texture filtering parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

' load image, create texture and generate mipmaps
Local pixmap:TPixmap = LoadPixmap(PATH_PREFIX + "../resources/textures/container.jpg")
If pixmap Then
	pixmap = YFlipPixmap(pixmap)
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, pixmap.width, pixmap.height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixmap.pixels)
	glGenerateMipmap(GL_TEXTURE_2D)
Else
	Print "Failed to load texture"
	End
End If

' texture 2
' ---------
glGenTextures(1, Varptr texture2)
glBindTexture(GL_TEXTURE_2D, texture2)

' set the texture wrapping parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)

' set texture filtering parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

' load image, create texture and generate mipmaps
pixmap = LoadPixmap(PATH_PREFIX + "../resources/textures/awesomeface.png")
If pixmap Then
	pixmap = YFlipPixmap(pixmap)
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, pixmap.width, pixmap.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixmap.pixels)
	glGenerateMipmap(GL_TEXTURE_2D)
Else
	Print "Failed to load texture"
	End
End If

pixmap = Null

' tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
ourShader.use()
ourShader.setInt("texture1", 0)
ourShader.setInt("texture2", 1)

' pass projection matrix to shader (as projection matrix rarely changes there's no need to do this per frame)
Local projection:SMat4F = SMat4F.Perspective(45.0, SCR_WIDTH, SCR_HEIGHT, 0.1, 100.0)
ourShader.setMat4("projection", projection)


' render loop
' -----------
While Not window.ShouldClose ()

	' per-frame time logic
	Local currentFrame:Float = MilliSecs() / 1000.0
	deltaTime = currentFrame - lastFrame
	lastFrame = currentFrame
	
	' input
	' -----
	ProcessInput (window)

	' render
	' ------
	glClearColor (0.2, 0.3, 0.3, 1.0)
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ' also clear the depth buffer now!
	
	' bind textures on corresponding texture units
	glActiveTexture(GL_TEXTURE0)
	glBindTexture(GL_TEXTURE_2D, texture1)
	glActiveTexture(GL_TEXTURE1)
	glBindTexture(GL_TEXTURE_2D, texture2)
	
	' activate shader
	ourShader.use()
	
	' camera/view transformation
	Local view:SMat4F = SMat4F.LookAt(cameraPos, cameraPos + cameraFront, cameraUp)
	ourShader.setMat4("view", view)
	
	' render boxes
	glBindVertexArray (VAO)
	
	For Local i:Int = 0 Until 10
		' calculate the model matrix for each object and pass it to shader before drawing
		Local model:SMat4F = SMat4F.Identity()
		model = model.Translate(cubePositions[i])
		Local angle:Float = 20.0 * i
		
		model = model.Rotate(New SVec3F(1.0, 0.3, 0.5), angle)
		ourShader.setMat4("model", model)
		
		glDrawArrays(GL_TRIANGLES, 0, 36)
	Next
	

	' glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers ()
	PollSystem ()
	
Wend

' optional: de-allocate all resources once they've outlived their purpose
glDeleteVertexArrays (1, Varptr VAO)
glDeleteBuffers (1, Varptr VBO)

End
