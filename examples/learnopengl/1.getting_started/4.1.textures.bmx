' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow
Import "../shader.bmx"

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.JpgLoader
Import BRL.StandardIO

Local app_name:String = "Textures"

Const SCR_WIDTH:UInt	= 800
Const SCR_HEIGHT:UInt	= 600

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

' build and compile our shader program
Local ourShader:TShader = New TShader("4.1.texture.vs", "4.1.texture.fs")

' set up vertex data (and buffer(s)) and configure vertex attributes
Local vertices:Float [] = [..
	 0.5,  0.5, 0.0,   1.0, 0.0, 0.0,   1.0, 1.0, ..
	 0.5, -0.5, 0.0,   0.0, 1.0, 0.0,   1.0, 0.0, ..
	-0.5, -0.5, 0.0,   0.0, 0.0, 1.0,   0.0, 0.0, ..
	-0.5,  0.5, 0.0,   1.0, 1.0, 0.0,   0.0, 1.0]

Local indices:Int[] = [..
	0, 1, 3, ..
	1, 2, 3 ]

Local VBO:UInt
Local VAO:UInt
Local EBO:UInt

glGenVertexArrays (1, Varptr VAO)
glGenBuffers (1, Varptr VBO)
glGenBuffers (1, Varptr EBO)

' bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
glBindVertexArray (VAO)

glBindBuffer (GL_ARRAY_BUFFER, VBO)
glBufferData (GL_ARRAY_BUFFER, Int(vertices.length * SizeOf (0:Float)), vertices, GL_STATIC_DRAW)

glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, EBO)
glBufferData (GL_ELEMENT_ARRAY_BUFFER, Int(indices.length * SizeOf (0:Int)), indices, GL_STATIC_DRAW)

' position attribute
glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, Int(8 * SizeOf (0:Float)), 0:Byte Ptr)
glEnableVertexAttribArray (0)

Local attribute_offset:Int = 3 * SizeOf (0:Float)

' color attribute
glVertexAttribPointer (1, 3, GL_FLOAT, GL_FALSE, Int(8 * SizeOf (0:Float)), Byte Ptr (attribute_offset))
glEnableVertexAttribArray (1)

attribute_offset:Int = 6 * SizeOf (0:Float)

' texture coord attribute
glVertexAttribPointer (2, 2, GL_FLOAT, GL_FALSE, Int(8 * SizeOf (0:Float)), Byte Ptr (attribute_offset))
glEnableVertexAttribArray (2)

' load and create a texture
' -------------------------
Local texture:UInt

glGenTextures(1, Varptr texture)
glBindTexture(GL_TEXTURE_2D, texture)

' set the texture wrapping parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)

' set texture filtering parameters
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

' load image, create texture and generate mipmaps
Local pixmap:TPixmap = LoadPixmap(PATH_PREFIX + "../resources/textures/container.jpg")
If pixmap Then
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, pixmap.width, pixmap.height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixmap.pixels)
	glGenerateMipmap(GL_TEXTURE_2D)
Else
	Print "Failed to load texture"
	End
End If

pixmap = Null

' render loop
' -----------
While Not window.ShouldClose ()
	
	' input
	' -----
	ProcessInput (window)

	' render
	' ------
	glClearColor (0.2, 0.3, 0.3, 1.0)
	glClear (GL_COLOR_BUFFER_BIT)
	
	' bind Texture
	glBindTexture(GL_TEXTURE_2D, texture)
	
	' render container
	ourShader.use()
	glBindVertexArray (VAO)
	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0)

	' glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers ()
	PollSystem ()
	
Wend

' optional: de-allocate all resources once they've outlived their purpose
glDeleteVertexArrays (1, Varptr VAO)
glDeleteBuffers (1, Varptr VBO)
glDeleteBuffers (1, Varptr EBO)

End
