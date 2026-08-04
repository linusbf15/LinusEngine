/**************************************************************************/
/*  cube_to_octmap.glsl                                                   */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             LINUS ENGINE                               */
/*            https://linusbf15.github.io/linus-engine-web                */
/**************************************************************************/
/* Copyright (c) 2026-present Linus Fogsgaard.                            */
/* Copyright (c) 2014-2026 Godot Engine contributors (see AUTHORS.md).    */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

#[vertex]

#version 450

#VERSION_DEFINES

layout(location = 0) out vec2 uv_interp;

void main() {
	vec2 base_arr[3] = vec2[](vec2(-1.0, -3.0), vec2(-1.0, 1.0), vec2(3.0, 1.0));
	uv_interp = base_arr[gl_VertexIndex];
	gl_Position = vec4(uv_interp, 0.0, 1.0);
}

#[fragment]

#version 450

#VERSION_DEFINES

#include "../oct_inc.glsl"

layout(location = 0) in vec2 uv_interp;
layout(location = 0) out vec4 frag_color;

layout(set = 0, binding = 0) uniform samplerCube source_cube;

layout(push_constant, std430) uniform Params {
	float border_size;
	uint pad1;
	uint pad2;
	uint pad3;
}
params;

void main() {
	vec3 dir = oct_to_vec3_with_border(uv_interp * 0.5 + 0.5, params.border_size);
	frag_color = vec4(texture(source_cube, dir).rgb, 1.0);
}
