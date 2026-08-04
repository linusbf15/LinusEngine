/**************************************************************************/
/*  bvh_misc.inc                                                          */
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

int _handle_get_tree_id(BVHHandle p_handle) const {
	if (USE_PAIRS) {
		return _extra[p_handle.id()].tree_id;
	}
	return 0;
}

public:
void _handle_sort(BVHHandle &p_ha, BVHHandle &p_hb) const {
	if (p_ha.id() > p_hb.id()) {
		BVHHandle temp = p_hb;
		p_hb = p_ha;
		p_ha = temp;
	}
}

private:
void create_root_node(int p_tree) {
	// if there is no root node, create one
	if (_root_node_id[p_tree] == BVHCommon::INVALID) {
		uint32_t root_node_id;
		TNode *node = _nodes.request(root_node_id);
		node->clear();
		_root_node_id[p_tree] = root_node_id;

		// make the root node a leaf
		uint32_t leaf_id;
		TLeaf *leaf = _leaves.request(leaf_id);
		leaf->clear();
		node->neg_leaf_id = -(int)leaf_id;
	}
}

bool node_is_leaf_full(TNode &tnode) const {
	const TLeaf &leaf = _node_get_leaf(tnode);
	return leaf.is_full();
}

public:
TLeaf &_node_get_leaf(TNode &tnode) {
	BVH_ASSERT(tnode.is_leaf());
	return _leaves[tnode.get_leaf_id()];
}

const TLeaf &_node_get_leaf(const TNode &tnode) const {
	BVH_ASSERT(tnode.is_leaf());
	return _leaves[tnode.get_leaf_id()];
}

private:
