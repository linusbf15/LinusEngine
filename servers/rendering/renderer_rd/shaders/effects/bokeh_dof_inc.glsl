/**************************************************************************/
/*  bokeh_dof_inc.glsl                                                    */
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

layout(push_constant, std430) uniform Params {
	ivec2 size;
	float z_far;
	float z_near;

	bool orthogonal;
	float blur_size;
	float blur_scale;
	int blur_steps;

	bool blur_near_active;
	float blur_near_begin;
	float blur_near_end;
	bool blur_far_active;

	float blur_far_begin;
	float blur_far_end;
	bool second_pass;
	bool half_size;

	bool use_jitter;
	float jitter_seed;
	bool use_physical_near;
	bool use_physical_far;

	float blur_size_near;
	float blur_size_far;
	uint pad[2];
}
params;

//used to work around downsampling filter
#define DEPTH_GAP 0.0

const float GOLDEN_ANGLE = 2.39996323;

//note: uniform pdf rand [0;1[
float hash12n(vec2 p) {
	p = fract(p * vec2(5.3987, 5.4421));
	p += dot(p.yx, p.xy + vec2(21.5351, 14.3137));
	return fract(p.x * p.y * 95.4307);
}
