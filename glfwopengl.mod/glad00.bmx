'
' NOTE : Generated file. Do not edit. Your changes may be lost on the next update!
'        Generated by g2bmx on 08 Aug 2022
'
Strict

Import "../glfw.mod/glfw/deps/*.h"
Import "../glfw.mod/glfw/deps/glad/gl.h"

Extern

Global glWindowPos2d(x_:Double,y_:Double)="void glad_glWindowPos2d( GLdouble, GLdouble)!"
Global glWindowPos2dv(v_:Double Ptr)="void glad_glWindowPos2dv(const GLdouble*)!"
Global glWindowPos2f(x_:Float,y_:Float)="void glad_glWindowPos2f( GLfloat, GLfloat)!"
Global glWindowPos2fv(v_:Float Ptr)="void glad_glWindowPos2fv(const GLfloat*)!"
Global glWindowPos2i(x_:Int,y_:Int)="void glad_glWindowPos2i( GLint, GLint)!"
Global glWindowPos2iv(v_:Int Ptr)="void glad_glWindowPos2iv(const GLint*)!"
Global glWindowPos2s(x_:Short,y_:Short)="void glad_glWindowPos2s( GLshort, GLshort)!"
Global glWindowPos2sv(v_:Short Ptr)="void glad_glWindowPos2sv(const GLshort*)!"
Global glWindowPos3d(x_:Double,y_:Double,z_:Double)="void glad_glWindowPos3d( GLdouble, GLdouble, GLdouble)!"
Global glWindowPos3dv(v_:Double Ptr)="void glad_glWindowPos3dv(const GLdouble*)!"
Global glWindowPos3f(x_:Float,y_:Float,z_:Float)="void glad_glWindowPos3f( GLfloat, GLfloat, GLfloat)!"
Global glWindowPos3fv(v_:Float Ptr)="void glad_glWindowPos3fv(const GLfloat*)!"
Global glWindowPos3i(x_:Int,y_:Int,z_:Int)="void glad_glWindowPos3i( GLint, GLint, GLint)!"
Global glWindowPos3iv(v_:Int Ptr)="void glad_glWindowPos3iv(const GLint*)!"
Global glWindowPos3s(x_:Short,y_:Short,z_:Short)="void glad_glWindowPos3s( GLshort, GLshort, GLshort)!"
Global glWindowPos3sv(v_:Short Ptr)="void glad_glWindowPos3sv(const GLshort*)!"

End Extern

Extern "C"
Function gladLoadGL:Int(func(name:Byte Ptr))="int gladLoadGL( GLADloadfunc)!"
End Extern
