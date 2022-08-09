' https://learnopengl.com/

SuperStrict

Framework GLFW.GLFWWindow

Import GLFW.GLFW
Import GLFW.GLFWOpenGL
Import GLFW.GLFWSystem

Import BRL.StandardIO

Local app_name:String = "Hello Triangle Indexed"

Const SCR_WIDTH:UInt	= 800
Const SCR_HEIGHT:UInt	= 600

Type TGameWindow Extends TGLFWWindow
	
	' glfw: whenever the window size changed (by OS or user resize) this callback method executes
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

Local vertexShaderSource:String

vertexShaderSource :+ "#version 330 core~n"
vertexShaderSource :+ "layout (location = 0) in vec3 aPos;~n"
vertexShaderSource :+ "void main()~n"
vertexShaderSource :+ "{~n"
vertexShaderSource :+ "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);~n"
vertexShaderSource :+ "}~n"

Local fragmentShaderSource:String

fragmentShaderSource :+ "#version 330 core~n"
fragmentShaderSource :+ "out vec4 FragColor;~n"
fragmentShaderSource :+ "void main()~n"
fragmentShaderSource :+ "{~n"
fragmentShaderSource :+ "   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);~n"
fragmentShaderSource :+ "}~n"

' build and compile our shader program
' ------------------------------------

' vertex shader
Local vertexShader:Int = glCreateShader (GL_VERTEX_SHADER)

glShaderSource (vertexShader, 1, vertexShaderSource)
glCompileShader (vertexShader)

Local success:Int
Local infoLog:String

' check for shader compile errors
glGetShaderiv (vertexShader, GL_COMPILE_STATUS, Varptr success)

If Not success
	infoLog = glGetShaderInfoLog (vertexShader)
	Print "Vertex shader compilation failed: " + infoLog
EndIf

' fragment shader
Local fragmentShader:Int = glCreateShader (GL_FRAGMENT_SHADER)

glShaderSource (fragmentShader, 1, fragmentShaderSource)
glCompileShader (fragmentShader)

' check for shader compile errors
glGetShaderiv (fragmentShader, GL_COMPILE_STATUS, Varptr success)

If Not success
	infoLog = glGetShaderInfoLog (fragmentShader)
	Print "Fragment shader compilation failed: " + infoLog
EndIf

' link shaders
Local shaderProgram:Int = glCreateProgram ()

glAttachShader (shaderProgram, vertexShader)
glAttachShader (shaderProgram, fragmentShader)
glLinkProgram (shaderProgram)

glGetProgramiv (shaderProgram, GL_LINK_STATUS, Varptr success)

If Not success
	infoLog = glGetProgramInfoLog (shaderProgram)
	Print "Shader program linking failed: " + infoLog
EndIf

glDeleteShader (vertexShader)
glDeleteShader (fragmentShader)

' set up vertex data (and buffer(s)) and configure vertex attributes
Local vertices:Float [] = [..
	0.5, 0.5, 0.0, ..
	0.5, -0.5, 0.0, ..
	-0.5, -0.5, 0.0, ..
	-0.5, 0.5, 0.0]

Local indices:UInt [] = [..
	0, 1, 3, ..
	1, 2, 3]

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
glBufferData (GL_ELEMENT_ARRAY_BUFFER, Int(indices.length * SizeOf (0:Float)), indices, GL_STATIC_DRAW)

glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, Int(3 * SizeOf (0:Float)), 0:Byte Ptr)
glEnableVertexAttribArray (0)

' note that this is allowed, the call to glVertexAttribPointer registered VBO as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
glBindBuffer (GL_ARRAY_BUFFER, 0)

' You can unbind the VAO afterwards so other VAO calls won't accidentally modify this VAO, but this rarely happens. Modifying other
' VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
glBindVertexArray (0)

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
	
	' draw our first triangle
	glUseProgram (shaderProgram)
	glBindVertexArray (VAO) ' seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
	glDrawElements (GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0)

	' swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
	window.SwapBuffers ()
	PollSystem ()
	
Wend

' optional: de-allocate all resources once they've outlived their purpose
glDeleteVertexArrays (1, Varptr VAO)
glDeleteBuffers (1, Varptr VBO)
glDeleteBuffers (1, Varptr EBO)

End
