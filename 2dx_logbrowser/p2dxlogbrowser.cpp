/***************************************************************************
 *   Copyright (C) 2006 by UC Davis Stahlberg Laboratory   *
 *   HStahlberg@ucdavis.edu   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/


#ifdef HAVE_CONFIG_H
#include <config.h>  // configuration file generated by the IDE
#endif

#include <qapplication.h>  // qt application class library

#include "LBMainWindow.h"  // main window class library that is the main GUI
/***************************************************************************
 *   Main Program                                                          *
 ***************************************************************************/
int main(int argc, char *argv[])
{
  QApplication p2dxlogbrowser(argc, argv);  // log browser main application
  LBMainWindow mainWin(argc, argv);  // create the main window for the GUI
  mainWin.show();  // display the main window for the GUI application
  mainWin.raise(); // raises the window on top of the parent widget stack
  mainWin.activateWindow(); // activates the window an thereby putting it on top-level
  return p2dxlogbrowser.exec();  // exec the GUI application and terminate the current process
}
