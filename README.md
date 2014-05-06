OS-X-Folder-Actions
===================
Found these here: http://j4zzcat.wordpress.com/2010/01/06/folder-actions-unix-style.

## Folder Actions, UNIX style

Mac OS X has a nice feature called Folder Actions. Basically, this feature lets you attach an AppleScript script to a folder, and have that script run whenever items are added or removed from the folder. Have a look here for a simple example.

How would you write that script in bash? Here’s my simple, general-purpose solution.

There are three parts in this solution:

1. An AppleScript called Send Events To Shell Script.scpt (binary file, use the built-in AppleScript Editor to view/edit)

1. A bash script called FolderActionsDispatcher.sh

1. A user-written bash script .FolderActions.sh (see the template)

When you attach the Send Events To Shell Script.scpt script to a folder, it will act as an observer and forward the Opening, Closing, Adding and Removing events to the bash script /usr/local/bin/FolderActionsDispatcher.sh. The event payload includes the type of the event, the data needed to perform its purpose (i.e., for the Adding event, the list of the added items), as well as the name of the folder that was the target of the event. FolderActionsDispatcher.sh will parse the event, and then will try to invoke a callback script named .FolderActions.sh in the target folder. All you have to do is write the .FolderActions.sh bash script and place it in the folder it belongs to.

## Installation

Here’s an example. Let’s say that we want to copy every file placed in ~/Downloads to /private/tmp, and do it automatically. Here’s what we will do:

1. One time setup:
 
   1. Clone this repo.
   2. Copy **Send Events To Shell Script.scpt** to **~/Library/Scripts/Folder Action Scripts**. 
   2. Copy **FolderActionsDispatcher.sh** to **/usr/local/bin**.
   3. Make it world executable, like so: _$ chmod a+x /usr/local/bin/FolderActionsDispatcher.sh_.

1. Create the file ~/Downloads/.FolderActions.sh. The file FolderActions.template is a good starting point. Make the new file user executable, like so:$ chmod u+x ~/Downloads/.FolderActions.sh.

1. Edit ~/Downloads/.FolderActions.sh and add the desired code in the item_added_to_folder() function. This callback function will be called by the /usr/local/bin/FolderActionsDispatcher.sh dispatcher script, every time an item (either a file or a folder) is added to the ~/Downloads directory.

  ```sh
  function item_added_to_folder() {
    FOLDER=$1
    ITEM=$2
    # this is what we will do
    cp ${FOLDER}/${ITEM} /private/tmp
  }
  ```

1. Save the modified script.

1. Enable Folder Actions  for ~/Downloads. In the Finder application, select the ~/Downloads folder, bring up the context menu, and select ‘Folder Actions Setup…‘   From the dialog, select the ‘Send Events To Shell Script.scpt‘ action, and click the ‘Attach‘ button.

That’s it :-) To test it, place a file in ~/Downloads and see that it gets copied to /private/tmp.
