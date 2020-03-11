SuperStrict

Framework GLFW.GLFWWindow
Import GLFW.GLFWOpenGL


' settings
Const SCR_WIDTH:Int = 800
Const SCR_HEIGHT:Int = 600

' glfw: initialize and configure
TGLFWWindow.Hint(GLFW_CONTEXT_VERSION_MAJOR, 3)
TGLFWWindow.Hint(GLFW_CONTEXT_VERSION_MINOR, 3)
TGLFWWindow.Hint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)

' glfw window creation
Local window:TGLFWWindow = New TMyWindow.Create(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL")

If Not window Then
	Throw "Failed to create GLFW window"
End If

window.MakeContextCurrent()

' glad: load all OpenGL function pointers
gladLoadGL(glfwGetProcAddress)


' render loop
While Not window.ShouldClose()

	' input
	ProcessInput(window)

	' render
	glClearColor(0.2, 0.3, 0.3, 1.0)
	glClear(GL_COLOR_BUFFER_BIT)

	' glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers()
	PollSystem

Wend

' process all input: query GLFW whether relevant keys are pressed/released this frame and react accordingly
Function ProcessInput(window:TGLFWWindow)
	If window.IsKeyDown(GLFW_KEY_ESCAPE) Then
		window.SetShouldClose(True)
	End If
End Function

Type TMyWindow Extends TGLFWWindow

	' glfw: whenever the window size changed (by OS or user resize) this callback function executes
	Method OnFramebufferSize(width:Int, height:Int) Override
	
		' make sure the viewport matches the new window dimensions; note that width and
		' height will be significantly larger than specified on retina displays.
		glViewport(0, 0, width, height)
	End Method

End Type
