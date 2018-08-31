/*
* Copyright (c) 2011-2018 alcadica (https://www.alcadica.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: alcadica <github@alcadica.com>
*/

namespace Alcadica.Develop.Plugins.Entities.Common {
	public class SourceTreeItem : Object {
		public bool has_parent {
			get {
				return this.parent != null;
			}
		}
		public bool is_leaf { 
			get {
				return this.children.length () == 0; 
			}
		}
		public SourceTreeItem? parent = null;
		public SourceTreeItem? root = null;
		public SourceTree tree { get; set; }
		public string node_name { get; set; }
		public List<SourceTreeItem> children = new List<SourceTreeItem> ();

		public void append_child (SourceTreeItem child) {
			if (this.has_child (child)) {
				return;
			}
			
			child.parent = this;
			child.root = this.root;
			this.children.append (child);
			this.tree.item_did_add (child);
		}

		public List<SourceTreeItem> get_flatterned_children () {
			List<SourceTreeItem> result = new List<SourceTreeItem> ();

			if (this.children.length () == 0) {
				return result;
			}

			result = this.children.copy ();
			
			for (int i = 0; i < result.length (); i++) {
				var _r = result.nth_data (i).get_flatterned_children ();
				
				result.concat ((owned) _r);
			}

			return result;
		}

		public bool has_child (SourceTreeItem child) {
			return this.children.find (child).length () > 0;
		}

		public void remove_child (SourceTreeItem child) {
			if (!this.has_child (child)) {
				return;
			}
			
			this.children.remove (child);
			this.tree.item_did_remove (child);
		}
	}
}