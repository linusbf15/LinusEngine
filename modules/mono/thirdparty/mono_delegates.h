/**************************************************************************/
/*  mono_delegates.h                                                      */
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

// Adapted from monovm.h and assembly-functions.h to match coreclr_delegates.h.

// https://github.com/dotnet/runtime/blob/27a7fe5c4bbe0762c231b2a46162e60ee04f3cde/src/mono/mono/mini/monovm.h
// https://github.com/dotnet/runtime/blob/27a7fe5c4bbe0762c231b2a46162e60ee04f3cde/src/native/public/mono/metadata/details/assembly-functions.h

#ifndef _MONO_DELEGATES_H_
#define _MONO_DELEGATES_H_

#include "mono_types.h"

typedef MonoAssembly *(*MonoAssemblyPreLoadFunc)(
		MonoAssemblyName *aname,
		char **assemblies_path,
		void* user_data);

typedef void (*mono_install_assembly_preload_hook_fn)(
		MonoAssemblyPreLoadFunc func,
		void *user_data);

typedef const char *(*mono_assembly_name_get_name_fn)(MonoAssemblyName *aname);

typedef const char *(*mono_assembly_name_get_culture_fn)(MonoAssemblyName *aname);

typedef MonoImage *(*mono_image_open_from_data_with_name_fn)(
		char *data,
		uint32_t data_len,
		mono_bool need_copy,
		/*out*/ MonoImageOpenStatus *status,
		mono_bool refonly,
		const char *name);

typedef MonoAssembly *(*mono_assembly_load_from_full_fn)(
		MonoImage *image,
		const char *fname,
		/*out*/ MonoImageOpenStatus *status,
		mono_bool refonly);

#endif // _MONO_DELEGATES_H_
