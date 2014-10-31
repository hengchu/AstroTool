//
//  MDSTransformationFunctions.c
//  MDS9
//
//  Created by Hengchu Zhang on 10/28/14.
//  Copyright (c) 2014 Hengchu Zhang. All rights reserved.
//
//  This file implements a set of transformation functions similar
//  to those provided in ds9. The implementation is adapted from this
//  python script: https://github.com/glue-viz/ds9norm/blob/master/ds9norm.py

#include "MDSTransformationFunctions.h"
#include <math.h>
#include <Accelerate/Accelerate.h>

void norm(double *output, double *input, double vmin, double vmax, int count)
{
  double neg_vmin = -1.0 * vmin;
  
  // Performs output = input - 1.0 * vmin
  vDSP_vsaddD(input, 1, &neg_vmin, output, 1, count);
  
  double vmax_minus_vmin = vmax - vmin;
  
  // Performs output = output / (vmax - vmin).
  vDSP_vsdivD(output, 1, &vmax_minus_vmin, output, 1, count);
  
  double clipLo = 0.0;
  double clipHi = 1.0;
  // Clips the result between 0 and 1
  vDSP_vclipD(output, 1, &clipLo, &clipHi, output, 1, count);
}

void cscale(double *output, double *input, double bias, double contrast, int count)
{
  double neg_bias = -1.0 * bias;
  
  // output = input - bias
  vDSP_vsaddD(input, 1, &neg_bias, output, 1, count);
  
  // output *= contrast
  vDSP_vsmulD(output, 1, &contrast, output, 1, count);
  
  double half = 0.5;
  
  // output += 0.5
  vDSP_vsaddD(output, 1, &half, output, 1, count);
  
  double clipLo = 0.0;
  double clipHi = 1.0;
  vDSP_vclipD(output, 1, &clipLo, &clipHi, output, 1, count);
}

void linear_warp(double *output, double *input, double vmin, double vmax,
                 double bias, double contrast, int count)
{
  norm(output, input, vmin, vmax, count);
  cscale(output, output, bias, contrast, count);
}

void log_warp(double *output, double *input, double vmin, double vmax,
              double bias, double contrast, double exp, int count)
{
  norm(output, input, vmin, vmax, count);
  
  // output *= exp
  vDSP_vsmulD(output, 1, &exp, output, 1, count);
  

  double one = 1.0;
  // output += 1
  vDSP_vsaddD(output, 1, &one, output, 1, count);
  
  // output = log(output)
  vvlog(output, output, &count);
  
  double logExpAndOne = log(exp+1);
    
  // output = output / log(exp+1)
  vDSP_vsdivD(output, 1, &logExpAndOne, output, 1, count);
  
  cscale(output, output, bias, contrast, count);
}

void pow_warp(double *output, double *input, double vmin, double vmax,
                double bias, double contrast, double exp, int count)
{
  norm(output, input, vmin, vmax, count);
  
  double log_exp = log(exp);
  
  vDSP_vsmulD(output, 1, &log_exp, output, 1, count);
  
  // output = e^output
  vvexp(output, output, &count);
  
  double neg_one = -1.0;
  // output -= 1
  vDSP_vsaddD(output, 1, &neg_one, output, 1, count);
  
  double exp_minus_one = exp - 1;
  // output /= (exp-1)
  vDSP_vsdivD(output, 1, &exp_minus_one, output, 1, count);
  
  cscale(output, output, bias, contrast, count);
}

void sqrt_warp(double *output, double *input, double vmin, double vmax, double bias, double contrast, int count)
{
  norm(output, input, vmin, vmax, count);

  vvsqrt(output, output, &count);
  
  cscale(output, output, bias, contrast, count);
}

void squared_warp(double *output, double *input, double vmin, double vmax, double bias, double contrast, int count)
{
  norm(output, input, vmin, vmax, count);
  
  vDSP_vsqD(output, 1, output, 1, count);
  
  cscale(output, output, bias, contrast, count);
}

void asinh_warp(double *output, double *input, double vmin, double vmax, double bias, double contrast, int count)
{
  norm(output, input, vmin, vmax, count);
  
  double ten = 10.0;
  vDSP_vsmulD(output, 1, &ten, output, 1, count);
  
  vvasinh(output, output, &count);
  
  double three = 3.0;
  vDSP_vsdivD(output, 1, &three, output, 1, count);

  cscale(output, output, bias, contrast, count);
}

void linear_mult(double *output, double *input, double scalar, int count)
{
  vDSP_vsmulD(input, 1, &scalar, output, 1, count);
}

void swap_items(double *list, int i, int j)
{
  double tmp = list[i];
  list[i] = list[j];
  list[j] = tmp;
}

int partition(double *list, int startI, int endI, int pivotI)
{
  double pivotValue = list[pivotI];
  list[pivotI] = list[startI];
  list[startI] = pivotValue;
  
  int storeI = startI + 1;
  while (storeI < endI && list[storeI] <= pivotValue) ++storeI;
  
  for (int i = storeI + 1; i < endI; i++) {
    if (list[i] <= pivotValue) {
      swap_items(list, i, storeI);
      ++storeI;
    }
  }
  
  int newPivotI = storeI - 1;
  list[startI] = list[newPivotI];
  list[newPivotI] = pivotValue;
  return newPivotI;
}

double _quickSelect(double *list, int k, int startI, int endI)
{
  while (true) {
    int pivotI = (startI + endI) / 2;
    int splitI = partition(list, startI, endI, pivotI);
    if (k < splitI)
      endI = splitI;
    else if (k > splitI)
      startI = splitI + 1;
    else
      return list[k];
  }
}

double quickSelect(double *list, int k, int count)
{
  double *tmp = malloc(sizeof(double) * count);
  memcpy(tmp, list, sizeof(double) * count);
  double value = _quickSelect(tmp, k, 0, count);
  free(tmp);
  return value;
}

