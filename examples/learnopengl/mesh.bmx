SuperStrict

Import "shader.bmx"

Struct SVertex
	Field position:SVec3F
	Field normal:SVec3F
	Field texCoords:SVec2F
	Field tangent:SVec3F
	Field bitangent:SVec3F
End Struct

Type TTexture
	Field id:Int
	Field textureType:String
	Field path:String
End Type


Type TMesh
	' Mesh Data
	Field vertices:SVertex[]
	Field indices:UInt[]
	Field textures:TTexture[]
	Field VAO:UInt
	
	Field VBO:UInt
	Field EBO:UInt

	Method New(vertices:SVertex[], indices:UInt[], textures:TTexture[])
		Self.vertices = vertices
		Self.indices = indices
		Self.textures = textures
		
		' now that we have all the required data, set the vertex buffers and its attribute pointers.
		setupMesh()
	End Method

	' render the mesh
	Method Draw(shader:TShader)
		' bind appropriate textures
		Local diffuseNr:UInt = 1
		Local specularNr:UInt = 1
		Local normalNr:UInt = 1
		Local heightNr:UInt = 1
		
		For Local i:Int = 0 Until textures.length
			glActiveTexture(GL_TEXTURE0 + i) ' active proper texture unit before binding
			' retrieve texture number (the N in diffuse_textureN)
			Local number:String
			Local name:String = textures[i].textureType
			If name = "texture_diffuse" Then
				number = diffuseNr
				diffuseNr :+ 1
			Else If name = "texture_specular" Then
				number = specularNr ' transfer unsigned int to stream
				specularNr :+ 1
			Else If name = "texture_normal" Then
				number = normalNr ' transfer unsigned int to stream
				normalNr :+ 1
			Else If name = "texture_height" Then
				number = heightNr ' transfer unsigned int to stream
				heightNr :+ 1
			End If
			
			' now set the sampler to the correct texture unit
			glUniform1i(glGetUniformLocation(shader.id, name + number), i)
			' and finally bind the texture
			glBindTexture(GL_TEXTURE_2D, textures[i].id)
		Next
		
		' draw mesh
		glBindVertexArray(VAO)
		glDrawElements(GL_TRIANGLES, indices.length, GL_UNSIGNED_INT, 0)
		glBindVertexArray(0)
		
		' always good practice to set everything back to defaults once configured
		glActiveTexture(GL_TEXTURE0)
	End Method

Private
	' initializes all the buffer objects/arrays
	Method setupMesh()
		' create buffers/arrays
		glGenVertexArrays(1, Varptr VAO)
		glGenBuffers(1, Varptr VBO)
		glGenBuffers(1, Varptr EBO)

		glBindVertexArray(VAO)
		' load data into vertex buffers
		glBindBuffer(GL_ARRAY_BUFFER, VBO)
		
		Local v:SVertex

		' A great thing about structs is that their memory layout is sequential for all its items.
		' The effect is that we can simply pass a pointer to the struct and it translates perfectly to a glm::vec3/2 array which
		' again translates to 3/2 floats which translates to a byte array.
		glBufferData(GL_ARRAY_BUFFER, vertices.length * SizeOf(v), vertices, GL_STATIC_DRAW)
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO)
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * SizeOf(0:UInt), indices, GL_STATIC_DRAW)

		' set the vertex attribute pointers
		' vertex Positions
		glEnableVertexAttribArray(0)	
		glVertexAttribPointer(0, 3, GL_FLOAT, False, SizeOf(v), Null);
		' vertex normals
		glEnableVertexAttribArray(1)	
		glVertexAttribPointer(1, 3, GL_FLOAT, False, SizeOf(v), Byte Ptr(FieldOffset(SVertex, normal)))
		' vertex texture coords
		glEnableVertexAttribArray(2)	
		glVertexAttribPointer(2, 2, GL_FLOAT, False, SizeOf(v), Byte Ptr(FieldOffset(SVertex, texCoords)))
		' vertex tangent
		glEnableVertexAttribArray(3)
		glVertexAttribPointer(3, 3, GL_FLOAT, False, SizeOf(v), Byte Ptr(FieldOffset(SVertex, tangent)))
		' vertex bitangent
		glEnableVertexAttribArray(4)
		glVertexAttribPointer(4, 3, GL_FLOAT, False, SizeOf(v), Byte Ptr(FieldOffset(SVertex, bitangent)))

		glBindVertexArray(0)
	End Method

End Type
