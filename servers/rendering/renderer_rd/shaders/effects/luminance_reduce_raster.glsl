/**************************************************************************/
/*  luminance_reduce_raster.glsl                                          */
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
#[vertex]

#version 450

#VERSION_DEFINES

#include "luminance_reduce_raster_inc.glsl"

layout(location = 0) out vec2 uv_interp;
/* clang-format on */

void main() {
	vec2 base_arr[3] = vec2[](vec2(-1.0, -1.0), vec2(-1.0, 3.0), vec2(3.0, -1.0));
	gl_Position = vec4(base_arr[gl_VertexIndex], 0.0, 1.0);
	uv_interp = clamp(gl_Position.xy, vec2(0.0, 0.0), vec2(1.0, 1.0)) * 2.0; // saturate(x) * 2.0
}

/* clang-format off */
#[fragment]

#version 450

#VERSION_DEFINES

#include "luminance_reduce_raster_inc.glsl"

layout(location = 0) in vec2 uv_interp;
/* clang-format on */

layout(set = 0, binding = 0) uniform sampler2D source_exposure;

#ifdef FINAL_PASS
layout(set = 1, binding = 0) uniform sampler2D prev_luminance;
#endif

layout(location = 0) out highp float luminance;

void main() {
	ivec2 dest_pos = ivec2(uv_interp * settings.dest_size);
	ivec2 src_pos = ivec2(uv_interp * settings.source_size);

	ivec2 next_pos = (dest_pos + ivec2(1)) * settings.source_size / settings.dest_size;
	next_pos = max(next_pos, src_pos + ivec2(1)); //so it at least reads one pixel

	highp vec3 source_color = vec3(0.0);
	for (int i = src_pos.x; i < next_pos.x; i++) {
		for (int j = src_pos.y; j < next_pos.y; j++) {
			source_color += texelFetch(source_exposure, ivec2(i, j), 0).rgb;
		}
	}

	source_color /= float((next_pos.x - src_pos.x) * (next_pos.y - src_pos.y));

#ifdef FIRST_PASS
	luminance = max(source_color.r, max(source_color.g, source_color.b));

	// This formula should be more "accurate" but gave an overexposed result when testing.
	// Leaving it here so we can revisit it if we want.
	// luminance = source_color.r * 0.21 + source_color.g * 0.71 + source_color.b * 0.07;
#else
	luminance = source_color.r;
#endif

#ifdef FINAL_PASS
	// Obtain our target luminance
	luminance = clamp(luminance, settings.min_luminance, settings.max_luminance);

	// Now smooth to our transition
	highp float prev_lum = texelFetch(prev_luminance, ivec2(0, 0), 0).r; //1 pixel previous luminance
	luminance = prev_lum + (luminance - prev_lum) * clamp(settings.exposure_adjust, 0.0, 1.0);
#endif
}
