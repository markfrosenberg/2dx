/**************************************************************************
*   Copyright (C) 2006 by UC Davis Stahlberg Laboratory                   *
*   HStahlberg@ucdavis.edu                                                *
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

#include "navigatorHelpTool.h"

navigatorHelpTool::navigatorHelpTool(const QString &fileName, QWidget *parent)
                  :QWidget(parent,Qt::Tool)
{
  resize(600,400);
  QGridLayout *layout = new QGridLayout(this);
  layout->setMargin(0);
  layout->setSpacing(0);
  setLayout(layout);

  helpText = new QTextBrowser(this);

  layout->addWidget(helpText);

  helpText->setSource(fileName);
}
