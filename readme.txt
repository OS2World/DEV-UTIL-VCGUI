VCGUI for eCS und OS/2
~~~~~~~~~~~~~~~~~~~~~~
This program is a graphic interface for version management programs.
In the first version only CVS is supported, Subversion (svn) follows in one
of the next versions.

The program is Freeware and published under the GNU General Public License.
Details see in copying.txt.

It was developed with the Pascal development system WDSibyl. More about this
see under http://www.wdsibyl.org.

Disclaimer
~~~~~~~~~~
You are using this program at your own risk. The the author gives no
warranty for the function or any others things affected by this program.
Under no circumstances the author is liable for any loss or damage supposed
to derive from the use of the program.

Getting started
~~~~~~~~~~~~~~~
The fundamental ideas of the version control should admit to be. 
A CVS Documenation can be found under http://www.wincvs.org/howto/cvsdoc/index.html.

System prerequisites
~~~~~~~~~~~~~~~~~~~~
- eCS V 1.x or OS/2 V 4.x (V 3.0 may also work, not tested)
- EMX V 0.9d for CVS.EXE

Supported functionalities:
~~~~~~~~~~~~~~~~~~~~~~~~~~
- creation of a local repositories
- importing project folders
- checkout of projects
- updates of projects with different options (clean copy, date/time, tag/branch)
- committing the changes
- show history (list)
- comparisons of revisions (over external comparison program, eg. PMDIFF)
- adding folders and files
- deletion of files locally and from the repsitory
- edit/enedit (if write checkout is write protected)
- create tag or branch
- merge a branch into the head

Using
~~~~~
If WinCVS or CrossVC (LinCVS) were before already used, training should 
be easy, since the structure of the program is similar.

In the "Settings" under "Options" once the paths are to be adjusted to the external programs.
On the second tab "CVS profiles" are the connections to the Repositories adjusted.
At present local and pserver repositories are supported. Complete CVSROOT string is shown on the
window.
With click on the small "+" - button is put on an new entry for a repository and the further
data must be enterered.

In the left part of the main window is a tree, over the menu "Project" can project files be added
to the list.
Right is the file list, divided into "Controlled" and "Not Controlled".
Down the log window for the outputs of the appropriate commandline tool cvs.exe or svn.exe.
All parts have context menus.

Further information and Ssreenshots are on my homepage http://Bohn Stralsund.de to find under
"VCGUI" in the program list.

History
~~~~~~~
V 0.9.0.2
- Easier input of date/time for update
- Prevent access violation during tab change if project tree is empty

V 0.9.0.1
- First public version
