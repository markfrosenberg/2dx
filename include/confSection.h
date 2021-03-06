/***************************************************************************
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

#include <QString>
#include <QStringList>
#include <QList>
#include <QHash>
#include "confElement.h"

class confSection : public QObject
{
  Q_OBJECT

  private:
  QString sectionTitle;
  QList<confElement *> elements;
  QHash<QString,int> concernList;

  public:
  confSection(QString title, QObject *parent = NULL);
  void append(confElement *e);
  QString title();
  unsigned int size();

  void addConcern(QString concern);
  int concerns(QString concern);

  confSection & operator<<(confElement *e);
  confElement* operator[](unsigned int);
  bool operator==(const confSection& section);
};
