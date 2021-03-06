/*
 *  spotSelectTool.h
 *  2dx_image
 *
 *  Created by Bryant Gipson on 5/3/06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef SPOTSELECTTOOL_H
#define SPOTSELECTTOOL_H

#include <QApplication>
#include <QDesktopWidget>
#include <QWidget>
#include <QGridLayout>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QString>
#include <QLabel>
#include <QPoint>
#include <math.h>
#include "confData.h"
#include <mrcImage.h>
#include <fullScreenImage.h>

class spotSelectTool : public QWidget
{
  Q_OBJECT

  public slots:
  void updateReferenceOrigin();

  signals:
  void phaseChanged(float);

  private:

  float inv[2][2];
  int screenWidth, screenHeight;

  QPoint currentPos;

  QLabel *i,*j,*mouseX,*mouseY,*refOriginX,*refOriginY;
  QLabel *resolution, *value, *phase;

  confData *data;
  mrcHeader *imageHeader;
  mrcImage *imageData;
  fullScreenImage *image;

  public:
  spotSelectTool(confData *data, fullScreenImage *image, mrcImage *sourceImage, const QPoint &dimensions, QWidget *parent = NULL);
  void updateIndices(const QPoint &pos);
  void updateIndices(float imageScale);
  QPointF getImageCoordinates();

};

#endif

