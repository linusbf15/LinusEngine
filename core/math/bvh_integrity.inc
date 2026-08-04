/**************************************************************************/
/*  bvh_integrity.inc                                                     */
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

void _integrity_check_all() {
#ifdef BVH_INTEGRITY_CHECKS
	for (int n = 0; n < NUM_TREES; n++) {
		uint32_t root = _root_node_id[n];
		if (root != BVHCommon::INVALID) {
			_integrity_check_down(root);
		}
	}
#endif
}

void _integrity_check_up(uint32_t p_node_id) {
	TNode &node = _nodes[p_node_id];

	BVHABB_CLASS abb = node.aabb;
	node_update_aabb(node);

	BVHABB_CLASS abb2 = node.aabb;
	abb2.expand(-_node_expansion);

	CRASH_COND(!abb.is_other_within(abb2));
}

void _integrity_check_down(uint32_t p_node_id) {
	const TNode &node = _nodes[p_node_id];

	if (node.is_leaf()) {
		_integrity_check_up(p_node_id);
	} else {
		CRASH_COND(node.num_children != 2);

		for (int n = 0; n < node.num_children; n++) {
			uint32_t child_id = node.children[n];

			// check the children parent pointers are correct
			TNode &child = _nodes[child_id];
			CRASH_COND(child.parent_id != p_node_id);

			_integrity_check_down(child_id);
		}
	}
}
