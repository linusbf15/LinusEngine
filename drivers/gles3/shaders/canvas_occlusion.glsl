/**************************************************************************/
/*  canvas_occlusion.glsl                                                 */
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

/* clang-format off */
#[modes]

mode_sdf =
mode_shadow = #define MODE_SHADOW
mode_shadow_RGBA = #define MODE_SHADOW \n#define USE_RGBA_SHADOWS

#[specializations]

#[vertex]

layout(location = 0) in vec3 vertex;

uniform highp mat4 projection;
uniform highp vec4 modelview1;
uniform highp vec4 modelview2;
uniform highp vec2 direction;
uniform highp float z_far;

#ifdef MODE_SHADOW
out float depth;
#endif

void main() {
	highp vec4 vtx = vec4(vertex, 1.0) * mat4(modelview1, modelview2, vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));

#ifdef MODE_SHADOW
	depth = dot(direction, vtx.xy);
#endif
	gl_Position = projection * vtx;
}

#[fragment]


uniform highp mat4 projection;
uniform highp vec4 modelview1;
uniform highp vec4 modelview2;
uniform highp vec2 direction;
uniform highp float z_far;

#ifdef MODE_SHADOW
in highp float depth;
#endif

#ifdef USE_RGBA_SHADOWS
layout(location = 0) out lowp vec4 out_buf;
#else
layout(location = 0) out highp float out_buf;
#endif

void main() {
    float out_depth = 1.0;

#ifdef MODE_SHADOW
	out_depth = depth / z_far;
#endif

#ifdef USE_RGBA_SHADOWS
	out_depth = clamp(out_depth, -1.0, 1.0);
	out_depth = out_depth * 0.5 + 0.5;
	highp vec4 comp = fract(out_depth * vec4(255.0 * 255.0 * 255.0, 255.0 * 255.0, 255.0, 1.0));
	comp -= comp.xxyz * vec4(0.0, 1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0);
	out_buf = comp;
#else
	out_buf = out_depth;
#endif
}
