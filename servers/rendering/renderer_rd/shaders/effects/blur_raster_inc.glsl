/**************************************************************************/
/*  blur_raster_inc.glsl                                                  */
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

#define FLAG_HORIZONTAL (1 << 0)
#define FLAG_USE_ORTHOGONAL_PROJECTION (1 << 1)
#define FLAG_GLOW_FIRST_PASS (1 << 2)

layout(push_constant, std430) uniform Blur {
	vec2 dest_pixel_size; // 08 - 08
	vec2 source_pixel_size; // 08 - 16

	vec2 pad; // 08 - 24
	uint flags; // 04 - 28
	float glow_level; // 04 - 32

	// Glow.
	float glow_strength; // 04 - 36
	float glow_bloom; // 04 - 40
	float glow_hdr_threshold; // 04 - 44
	float glow_hdr_scale; // 04 - 48

	float glow_exposure; // 04 - 52
	float glow_white; // 04 - 56
	float glow_luminance_cap; // 04 - 60
	float luminance_multiplier; // 04 - 64
}
blur;
