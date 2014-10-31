//
//  MDSTransformationFunctions.h
//  MDS9
//
//  Created by Hengchu Zhang on 10/28/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//

#ifndef __MDS9__MDSTransformationFunctions__
#define __MDS9__MDSTransformationFunctions__

#include <stdio.h>

void norm(double *output, double *input, double vmin, double vmax, int count);
void cscale(double *output, double *input, double bias, double contrast, int count);

void linear_warp(double *output, double *input, double vmin, double vmax,
                 double bias, double contrast, int count);

void log_warp(double *output, double *input, double vmin, double vmax,
              double bias, double contrast, double exp, int count);

void pow_warp(double *output, double *input, double vmin, double vmax,
                double bias, double contrast, double exp, int count);

void sqrt_warp(double *output, double *input, double vmin, double vmax,
               double bias, double contrast, int count);

void squared_warp(double *output, double *input, double vmin, double vmax,
                  double bias, double contrast, int count);

void asinh_warp(double *output, double *input, double vmin, double vmax,
                double bias, double contrast, int count);

void linear_mult(double *output, double *input, double scalar, int count);

/**
 *  Use this function to figure out percentiles
 *
 *  @param list  list of doubles
 *  @param k     zero-based index of number to find
 *  @param count length of @p list
 *
 *  @return kth largest value in @p list.
 */
double quickSelect(double *list, int k, int count);

#endif /* defined(__MDS9__MDSTransformationFunctions__) */