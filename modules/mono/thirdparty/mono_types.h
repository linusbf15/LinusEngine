/**************************************************************************/
/*  mono_types.h                                                          */
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

// Adapted from mono-public-types.h and image-types.h.

// https://github.com/dotnet/runtime/blob/27a7fe5c4bbe0762c231b2a46162e60ee04f3cde/src/native/public/mono/utils/details/mono-publib-types.h
// https://github.com/dotnet/runtime/blob/27a7fe5c4bbe0762c231b2a46162e60ee04f3cde/src/native/public/mono/metadata/details/image-types.h

#ifndef _MONO_TYPES_H_
#define _MONO_TYPES_H_

#include <stdint.h>
#include <stdlib.h>

typedef int32_t mono_bool;

typedef void MonoAssembly;
typedef void MonoAssemblyName;
typedef void MonoImage;

typedef enum {
	MONO_IMAGE_OK,
	MONO_IMAGE_ERROR_ERRNO,
	MONO_IMAGE_MISSING_ASSEMBLYREF,
	MONO_IMAGE_IMAGE_INVALID,
	MONO_IMAGE_NOT_SUPPORTED, ///< \since net7
} MonoImageOpenStatus;

#endif // _MONO_TYPES_H_
