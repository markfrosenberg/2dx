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

#ifndef NAVIGATOR_H
#define NAVIGATOR_H

#include <QGraphicsView>
#include <QGraphicsScene>
#include <QGraphicsItemGroup>
#include <QAction>
#include <QScrollBar>
#include "confData.h"
#include "mrcImage.h"

class navigator : public QGraphicsView
{
  Q_OBJECT

  public slots:

  void center();
  void toggleItem(QGraphicsItem *item, bool visible);
  void toggleLattice(bool visible);

  private:
  confData *data;
  QGraphicsScene *scene;
  mrcImage *image;

  QGraphicsItemGroup *primaryLattice;

  void initializeActions();
  void initializeOverlay();
  void initializeLattice();

  public:
    navigator(confData *conf, const QString &imageName, QWidget *parent = NULL);

};


#endif
