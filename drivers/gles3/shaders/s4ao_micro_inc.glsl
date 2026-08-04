/**************************************************************************/
/*  s4ao_micro_inc.glsl                                                   */
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

// S4AO (Stupid Simple Screen Space Ambient Occlusion) - Jonathan Dummer (O1S)
// This micro version uses only 3 depth samples, the midpoint and a randomly-rotated, balanced pair.

const mediump float ssao_falloff_frac = 0.25;
// Perform the SSAO.
float s4ao(vec2 UV) {
#ifdef USE_MULTIVIEW
	mediump float depth = texture(depth_buffer_array, vec3(UV, view)).r;
#else
	mediump float depth = texture(depth_buffer, UV).r;
#endif
	mediump float inv_falloff = 1.0f / max(1e-4f, depth * ssao_falloff_frac);
	// Random 2D rotation per pixel (0..1 -> parabola approximating a 180 deg arc)
	mediump float r01 = fract(dot(UV, ssao_prn_UV));
	mediump vec2 duv = vec2(r01 - 0.5f, 2.0f * (r01 - r01 * r01)) * (2.0f * depth * ssao_radius_frac); // 180 degrees.
	// Grab the samples and determine the occlusion.
	mediump float occlusion = 0.0f;
	for (int s = 0; s < 2; ++s) {
#ifdef USE_MULTIVIEW
		mediump float dz = texture(depth_buffer_array, vec3(UV + duv, view)).r - depth;
#else
		mediump float dz = texture(depth_buffer, UV + duv).r - depth;
#endif
		// How 'directly overhead' is it?  Factor in the falloff depth.
		occlusion += normalize(vec3(duv, dz)).z * mix(1.0f, 0.0f, dz * inv_falloff);
		// Mirror the next sample.
		duv = -duv;
	}
	// Adjust the occlusion for intensity, and # samples.
	occlusion = 1.0f - clamp(occlusion * 0.5f * ssao_intensity, 0.0f, 1.0f);
	return occlusion * occlusion;
}
