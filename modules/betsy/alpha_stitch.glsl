/**************************************************************************/
/*  alpha_stitch.glsl                                                     */
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

// RGB and Alpha components of ETC2 RGBA/DXT5 are computed separately.
// This compute shader merely stitches them together to form the final result
// It's also used by RG11/BC4 driver to stitch two R11/BC4 into one RG11/BC5

#[compute]
#version 450

layout(local_size_x = 8, //
		local_size_y = 8, //
		local_size_z = 1) in;

layout(binding = 0) uniform usampler2D srcRGB;
layout(binding = 1) uniform usampler2D srcAlpha;
layout(binding = 2, rgba32ui) uniform restrict writeonly uimage2D dstTexture;

void main() {
	uvec2 rgbBlock = texelFetch(srcRGB, ivec2(gl_GlobalInvocationID.xy), 0).xy;
	uvec2 alphaBlock = texelFetch(srcAlpha, ivec2(gl_GlobalInvocationID.xy), 0).xy;

	imageStore(dstTexture, ivec2(gl_GlobalInvocationID.xy), uvec4(rgbBlock.xy, alphaBlock.xy));
}
