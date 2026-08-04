/**************************************************************************/
/*  bvh_debug.inc                                                         */
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

public:
#ifdef BVH_VERBOSE
void _debug_recursive_print_tree(int p_tree_id) const {
	if (_root_node_id[p_tree_id] != BVHCommon::INVALID) {
		_debug_recursive_print_tree_node(_root_node_id[p_tree_id]);
	}
}

String _debug_aabb_to_string(const BVHABB_CLASS &aabb) const {
	POINT size = aabb.calculate_size();

	String sz;
	real_t vol = 0.0;

	for (int i = 0; i < POINT::AXIS_COUNT; ++i) {
		sz += "(";
		sz += itos(aabb.min[i]);
		sz += " ~ ";
		sz += itos(-aabb.neg_max[i]);
		sz += ") ";

		vol += size[i];
	}

	sz += "vol " + itos(vol);

	return sz;
}

void _debug_recursive_print_tree_node(uint32_t p_node_id, int depth = 0) const {
	const TNode &tnode = _nodes[p_node_id];

	String sz = String("\t").repeat(depth) + itos(p_node_id);

	if (tnode.is_leaf()) {
		sz += " L";
		sz += itos(tnode.height) + " ";
		const TLeaf &leaf = _node_get_leaf(tnode);

		sz += "[";
		for (int n = 0; n < leaf.num_items; n++) {
			if (n) {
				sz += ", ";
			}
			sz += "r";
			sz += itos(leaf.get_item_ref_id(n));
		}
		sz += "]  ";
	} else {
		sz += " N";
		sz += itos(tnode.height) + " ";
	}

	sz += _debug_aabb_to_string(tnode.aabb);
	print_line(sz);

	if (!tnode.is_leaf()) {
		for (int n = 0; n < tnode.num_children; n++) {
			_debug_recursive_print_tree_node(tnode.children[n], depth + 1);
		}
	}
}
#endif
