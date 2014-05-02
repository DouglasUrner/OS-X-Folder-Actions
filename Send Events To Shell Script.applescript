#
# This file is part of the Claymac project
# Copyright (C) 2009 <sharon.dagan@gmail.com>
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#

to send_event(the_event, a_folder, a_payload)
	set dispatcher_script to "/usr/local/bin/FolderActionsDispatcher.sh"
	do shell script dispatcher_script & " " & the_event & " " & POSIX path of a_folder & " " & a_payload
end send_event

on opening folder this_folder
	try
		send_event("opening", this_folder, "")
	on error errmsg
		display dialog errmsg
	end try
end opening folder


on closing folder window for this_folder
	try
		send_event("closing", this_folder, "")
	on error errmsg
		display dialog errmsg
	end try
end closing folder window for

on adding folder items to this_folder after receiving added_items
	try
		set item_list to ""
		tell application "Finder"
			repeat with an_item in added_items
				set item_name to name of an_item
				set item_list to item_list & "'" & item_name & "' "
			end repeat
		end tell
		send_event("adding", this_folder, item_list)
	on error errmsg
		display dialog errmsg
	end try
end adding folder items to

on removing folder items from this_folder after losing these_items
	try
		set item_list to ""
		tell application "Finder"
			repeat with an_item in these_items
				set item_name to name of an_item
				set item_list to item_list & "'" & item_name & "' "
			end repeat
		end tell
		send_event("removing", this_folder, item_list)
	on error errmsg
		display dialog errmsg
	end try
end removing folder items from
