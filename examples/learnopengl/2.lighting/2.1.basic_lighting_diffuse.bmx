' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow
Import "../shader.bmx"
Import "../camera.bmx"

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.JpgLoader
Import BRL.PngLoader
Import BRL.StandardIO

Local app_name:String = "Basic Lighting Diffuse"

Const SCR_WIDTH:UInt	= 800
Const SCR_HEIGHT:UInt	= 600

' camera
Global camera:TCamera = New TCamera(New SVec3F(0.0, 0.0, 3.0))

Global firstMouse:Int = True
Global lastX:Float = SCR_WIDTH / 2.0
Global lastY:Float = SCR_HEIGHT / 2.0

' timing
Global deltaTime:Float ' time between current frame and last frame
Global lastFrame:Float

' lighting
Global lightPos:SVec3F = New SVec3F(1.2, 1.0, 2.0)


Type TGameWindow Extends TGLFWWindow
	
	' whenever the window size changed (by OS or user resize) this callback method executes
	Method OnFrameBufferSize (width:Int, height:Int)
		' make sure the viewport matches the new window dimensions; note that width and 
		' height will be significantly larger than specified on retina displays.
		glViewport (0, 0, width, height)
	EndMethod

	Method OnCursorPosition(x:Double, y:Double)
		If firstMouse Then
			lastX = x
			lastY = y
			firstMouse = False
		End If
		
		Local xoffset:Float = x - lastX
		Local yoffset:Float = lastY - y ' reversed since y-coordinates go from bottom To top
		lastX = x
		lastY = y

		camera.ProcessMouseMovement(xoffset, yoffset)
	End Method

	Method OnScroll(xOffset:Double, yOffset:Double)
		camera.ProcessMouseScroll(Float(yoffset))
	End Method

EndType

' process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
Function ProcessInput (window:TGLFWWindow)
	
	If window.IsKeyDown (GLFW_KEY_ESCAPE)
		window.SetShouldClose (True)
	EndIf
	
	If window.IsKeyDown(GLFW_KEY_W) Then
		camera.ProcessKeyboard(ECameraMovement.Forward, deltaTime)
	End If
	If window.IsKeyDown(GLFW_KEY_S) Then
		camera.ProcessKeyboard(ECameraMovement.Backward, deltaTime)
	End If
	If window.IsKeyDown(GLFW_KEY_A) Then
		camera.ProcessKeyboard(ECameraMovement.Left, deltaTime)
	End If
	If window.IsKeyDown(GLFW_KEY_D) Then
		camera.ProcessKeyboard(ECameraMovement.Right, deltaTime)
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

' tell GLFW to capture our mouse
window.SetInputMode(GLFW_CURSOR, GLFW_CURSOR_DISABLED)

' glad: load all OpenGL function pointers
gladLoadGL (glfwGetProcAddress)

' configure global opengl state
glEnable(GL_DEPTH_TEST)

' build and compile our shader program
Local lightingShader:TShader = New TShader("2.1.basic_lighting.vs", "2.1.basic_lighting.fs")
Local lampShader:TShader = New TShader("2.1.lamp.vs", "2.1.lamp.fs")

' set up vertex data (and buffer(s)) and configure vertex attributes
Local vertices:Float [] = [..
		-0.5, -0.5, -0.5,  0.0,  0.0, -1.0, ..
		 0.5, -0.5, -0.5,  0.0,  0.0, -1.0, ..
		 0.5,  0.5, -0.5,  0.0,  0.0, -1.0, ..
		 0.5,  0.5, -0.5,  0.0,  0.0, -1.0, ..
		-0.5,  0.5, -0.5,  0.0,  0.0, -1.0, ..
		-0.5, -0.5, -0.5,  0.0,  0.0, -1.0, ..
		 ..
		-0.5, -0.5,  0.5,  0.0,  0.0,  1.0, ..
		 0.5, -0.5,  0.5,  0.0,  0.0,  1.0, ..
		 0.5,  0.5,  0.5,  0.0,  0.0,  1.0, ..
		 0.5,  0.5,  0.5,  0.0,  0.0,  1.0, ..
		-0.5,  0.5,  0.5,  0.0,  0.0,  1.0, ..
		-0.5, -0.5,  0.5,  0.0,  0.0,  1.0, ..
		 ..
		-0.5,  0.5,  0.5, -1.0,  0.0,  0.0, ..
		-0.5,  0.5, -0.5, -1.0,  0.0,  0.0, ..
		-0.5, -0.5, -0.5, -1.0,  0.0,  0.0, ..
		-0.5, -0.5, -0.5, -1.0,  0.0,  0.0, ..
		-0.5, -0.5,  0.5, -1.0,  0.0,  0.0, ..
		-0.5,  0.5,  0.5, -1.0,  0.0,  0.0, ..
		 ..
		 0.5,  0.5,  0.5,  1.0,  0.0,  0.0, ..
		 0.5,  0.5, -0.5,  1.0,  0.0,  0.0, ..
		 0.5, -0.5, -0.5,  1.0,  0.0,  0.0, ..
		 0.5, -0.5, -0.5,  1.0,  0.0,  0.0, ..
		 0.5, -0.5,  0.5,  1.0,  0.0,  0.0, ..
		 0.5,  0.5,  0.5,  1.0,  0.0,  0.0, ..
		 ..
		-0.5, -0.5, -0.5,  0.0, -1.0,  0.0, ..
		 0.5, -0.5, -0.5,  0.0, -1.0,  0.0, ..
		 0.5, -0.5,  0.5,  0.0, -1.0,  0.0, ..
		 0.5, -0.5,  0.5,  0.0, -1.0,  0.0, ..
		-0.5, -0.5,  0.5,  0.0, -1.0,  0.0, ..
		-0.5, -0.5, -0.5,  0.0, -1.0,  0.0, ..
		 ..
		-0.5,  0.5, -0.5,  0.0,  1.0,  0.0, ..
		 0.5,  0.5, -0.5,  0.0,  1.0,  0.0, ..
		 0.5,  0.5,  0.5,  0.0,  1.0,  0.0, ..
		 0.5,  0.5,  0.5,  0.0,  1.0,  0.0, ..
		-0.5,  0.5,  0.5,  0.0,  1.0,  0.0, ..
		-0.5,  0.5, -0.5,  0.0,  1.0,  0.0]

Local VBO:UInt
Local cubeVAO:UInt

glGenVertexArrays (1, Varptr cubeVAO)
glGenBuffers (1, Varptr VBO)

glBindVertexArray (cubeVAO)

glBindBuffer (GL_ARRAY_BUFFER, VBO)
glBufferData (GL_ARRAY_BUFFER, Int(vertices.length * SizeOf (0:Float)), vertices, GL_STATIC_DRAW)

' position attribute
glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, Int(6 * SizeOf (0:Float)), 0:Byte Ptr)
glEnableVertexAttribArray (0)

Local attribute_offset:Int = 3 * SizeOf (0:Float)

' normal attribute
glVertexAttribPointer (1, 3, GL_FLOAT, GL_FALSE, Int(6 * SizeOf (0:Float)), Byte Ptr (attribute_offset))
glEnableVertexAttribArray (1)

' second, configure the light's VAO (VBO stays the same; the vertices are the same for the light object which is also a 3D cube)
Local lightVAO:UInt
glGenVertexArrays(1, Varptr lightVAO)
glBindVertexArray(lightVAO)

glBindBuffer (GL_ARRAY_BUFFER, VBO)
' note that we update the lamp's position attribute's stride to reflect the updated buffer data
glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, Int(6 * SizeOf (0:Float)), 0:Byte Ptr)
glEnableVertexAttribArray (0)


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
	glClearColor (0.1, 0.1, 0.1, 1.0)
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
	' be sure to activate shader when setting uniforms/drawing objects
	lightingShader.use()
	lightingShader.setVec3("objectColor", 1.0, 0.5, 0.31)
	lightingShader.setVec3("lightColor",  1.0, 1.0, 1.0)
	lightingShader.setVec3("lightPos",  lightPos)
	
	' view/projection transformations
	Local projection:SMat4F = SMat4F.Perspective(camera.Zoom, SCR_WIDTH, SCR_HEIGHT, 0.1, 100.0)
	Local view:SMat4F = camera.GetViewMatrix()
	lightingShader.setMat4("projection", projection)
	lightingShader.setMat4("view", view)
	
	' world transformation
	Local model:SMat4F = SMat4F.Identity()
	lightingShader.setMat4("model", model)
	
	' render the cube
	glBindVertexArray(cubeVAO)
	glDrawArrays(GL_TRIANGLES, 0, 36)
	
	' also draw the lamp object
	lampShader.use()
	lampShader.setMat4("projection", projection)
	lampShader.setMat4("view", view)
	model = SMat4F.Identity()
	model = model.Translate(lightPos)
	model = model.Scale(New SVec3F(0.2, 0.2, 0.2)) ' a smaller cube
	lampShader.setMat4("model", model)

	glBindVertexArray(lightVAO)
	glDrawArrays(GL_TRIANGLES, 0, 36)

	' glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers ()
	PollSystem ()
	
Wend

' optional: de-allocate all resources once they've outlived their purpose
glDeleteVertexArrays(1, Varptr cubeVAO)
glDeleteVertexArrays (1, Varptr lightVAO)
glDeleteBuffers (1, Varptr VBO)

End
