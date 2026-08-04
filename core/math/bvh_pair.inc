/**************************************************************************/
/*  bvh_pair.inc                                                          */
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
// note .. maybe this can be attached to another node structure?
// depends which works best for cache.
struct ItemPairs {
	struct Link {
		void set(BVHHandle h, void *ud) {
			handle = h;
			userdata = ud;
		}
		BVHHandle handle;
		void *userdata;
	};

	void clear() {
		num_pairs = 0;
		extended_pairs.reset();
		expanded_aabb = BOUNDS();
	}

	BOUNDS expanded_aabb;

	// maybe we can just use the number in the vector TODO
	int32_t num_pairs;
	LocalVector<Link> extended_pairs;

	void add_pair_to(BVHHandle h, void *p_userdata) {
		Link temp;
		temp.set(h, p_userdata);

		extended_pairs.push_back(temp);
		num_pairs++;
	}

	uint32_t find_pair_to(BVHHandle h) const {
		for (int n = 0; n < num_pairs; n++) {
			if (extended_pairs[n].handle == h) {
				return n;
			}
		}
		return uint32_t(-1);
	}

	bool contains_pair_to(BVHHandle h) const {
		return find_pair_to(h) != BVHCommon::INVALID;
	}

	// return success
	void *remove_pair_to(BVHHandle h) {
		void *userdata = nullptr;

		for (int n = 0; n < num_pairs; n++) {
			if (extended_pairs[n].handle == h) {
				userdata = extended_pairs[n].userdata;
				extended_pairs.remove_at_unordered(n);
				num_pairs--;
				break;
			}
		}

		return userdata;
	}

	// experiment : scale the pairing expansion by the number of pairs.
	// when the number of pairs is high, the density is high and a lower collision margin is better.
	// when there are few local pairs, a larger margin is more optimal.
	real_t scale_expansion_margin(real_t p_margin) const {
		real_t x = real_t(num_pairs) * (1.0 / 9.0);
		x = MIN(x, 1.0);
		x = 1.0 - x;
		return p_margin * x;
	}
};
