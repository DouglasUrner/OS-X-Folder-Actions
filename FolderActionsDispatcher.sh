#!/bin/bash

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

#
# The name of the file that resides in the target folder
# and defines the callback functions
#

CALLBACK_FILE=.FolderActions.sh

#
# Internal
#

#DEBUG=1
EVENT=$1
TARGET_FOLDER=${2%/}
TARGET_CALLBACK_FILE=${TARGET_FOLDER}/${CALLBACK_FILE}

# include the target callback file
source ${TARGET_CALLBACK_FILE}

# logging function
function log() {
  if [ -n "${DEBUG}" ]; then
    logger -t org.claymac.FolderActionsDispatcher $1
  fi
}

# main
case ${EVENT} in
  opening)
    log "calling ${TARGET_CALLBACK_FILE}:folder_opened(folder:${TARGET_FOLDER})"
    folder_opened "${TARGET_FOLDER}"
    ;;

  closing)
    log "calling ${TARGET_CALLBACK_FILE}:folder_closed(folder:${TARGET_FOLDER})"
    folder_closed "${TARGET_FOLDER}"
    ;;

  adding)
    for item in "${@:3}"; do
      log "calling ${TARGET_CALLBACK_FILE}:item_added_to_folder(folder:${TARGET_FOLDER}, item:${item})"
      item_added_to_folder "${TARGET_FOLDER}" "${item}"
    done
    ;;

  removing)
    for item in "${@:3}"; do
      log "calling ${TARGET_CALLBACK_FILE}:item_removed_from_folder(folder:${TARGET_FOLDER}, item:${item})"
      item_removed_from_folder "${TARGET_FOLDER}" "${item}"
    done
    ;;

  *)
    log "got unknown event, ignoring"
    ;;
esac

