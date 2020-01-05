#include <stdio.h>
#include <math.h>
#include <time.h>
#include <unistd.h>
#include <cuda_runtime_api.h>



/*
To compile:
nvcc -o ProjectLinear ProjectLinear.cu

./ProjectLinear
*/


typedef struct point_t{
double x;
double y;
}point_t;

int n_data = 1000;
__device__ int d_n_data =1000;

point_t data[] = {
  {77.68,113.12},{65.18,112.25},{82.30,149.33},{84.24,136.85},
  {73.59,114.35},{78.43,131.58},{72.35,96.51},{65.19,97.95},
  {82.78,137.22},{82.03,119.69},{73.75,112.97},{83.17,140.27},
  {33.40,75.51},{39.91,66.03},{ 6.47,38.71},{31.68,62.31},
  {88.68,139.07},{68.31,114.67},{66.46,117.81},{34.44,58.30},
  {77.16,136.29},{33.92,56.80},{ 5.35,42.26},{49.32,78.13},
  {71.63,99.62},{80.45,121.62},{35.70,74.02},{13.12,45.15},
  {59.69,107.58},{ 5.47,32.51},{55.30,105.05},{44.42,94.18},
  { 2.84,34.56},{48.55,81.68},{14.55,43.33},{ 5.33,38.25},
  {31.47,47.64},{ 3.15,23.26},{18.00,37.05},{71.67,109.66},
  {86.16,128.07},{41.71,83.31},{ 9.68,30.41},{63.76,99.65},
  {61.97,117.67},{29.44,62.90},{43.63,79.88},{ 1.67,17.22},
  {35.36,70.44},{74.24,115.90},{85.61,137.65},{99.85,151.87},
  { 7.27,16.29},{84.37,125.26},{76.48,101.87},{ 6.59,27.27},
  {33.41,73.59},{68.55,103.70},{ 6.05,45.06},{34.57,75.54},
  {33.68,73.00},{57.72,106.53},{54.18,76.98},{73.90,103.58},
  {24.78,49.76},{16.02,61.65},{45.80,81.78},{ 4.15,31.21},
  { 7.38,48.01},{67.08,95.10},{31.90,76.48},{ 4.91,26.72},
  {42.09,52.93},{ 4.10,38.34},{11.90,27.43},{90.69,142.41},
  {95.51,126.43},{27.63,64.34},{11.84,44.65},{ 7.12,37.37},
  {37.27,82.35},{42.47,84.53},{47.47,97.08},{17.57,39.43},
  {43.61,84.44},{48.95,93.39},{28.12,55.61},{80.63,136.11},
  { 0.85,41.66},{73.73,124.20},{77.69,120.23},{87.70,127.88},
  {27.78,48.39},{52.93,85.51},{24.09,66.41},{65.52,108.73},
  {85.82,131.09},{82.07,145.49},{24.34,61.59},{22.34,64.38},
  {77.82,123.61},{99.58,144.37},{79.15,125.56},{71.37,121.98},
  {12.70,43.82},{59.81,109.31},{10.35,26.79},{65.37,106.76},
  {77.36,113.02},{92.09,140.49},{36.92,67.89},{67.13,114.78},
  {92.65,142.54},{61.13,100.33},{58.21,104.38},{99.81,145.47},
  {69.50,120.74},{34.87,66.70},{48.25,77.57},{60.89,103.42},
  {52.06,98.04},{70.27,108.56},{49.09,106.92},{38.87,84.38},
  {28.04,69.46},{17.51,46.52},{79.92,128.62},{15.82,65.19},
  {25.72,77.47},{66.54,118.34},{24.09,45.41},{92.26,147.17},
  {98.48,159.02},{ 1.18,53.02},{95.23,154.06},{72.50,115.39},
  {47.24,95.73},{ 4.97,40.82},{37.66,77.06},{25.22,59.37},
  {88.94,137.18},{99.90,157.08},{95.58,128.62},{98.31,165.80},
  {95.42,148.32},{28.38,42.17},{62.52,121.77},{80.05,126.23},
  {60.40,106.83},{46.14,94.84},{74.35,103.58},{88.97,130.82},
  {50.22,85.96},{65.61,107.78},{30.22,55.97},{84.07,121.56},
  { 5.38,22.46},{61.11,112.83},{77.99,133.11},{11.05,54.67},
  {43.43,76.13},{78.82,129.31},{31.84,61.60},{ 7.76,33.26},
  {22.38,55.93},{96.51,149.49},{22.44,37.58},{74.92,120.02},
  {22.94,72.13},{51.82,93.27},{ 6.36,43.41},{42.08,71.16},
  {29.81,63.45},{30.34,61.25},{98.02,165.32},{86.06,120.78},
  {50.99,80.01},{95.80,149.58},{92.50,145.76},{ 7.25,22.51},
  {28.97,89.82},{68.51,122.12},{95.42,142.32},{46.74,85.03},
  {12.53,68.88},{ 8.20,34.28},{29.55,69.07},{63.23,109.69},
  { 9.82,43.19},{76.97,114.47},{27.09,40.09},{16.17,49.71},
  {37.02,77.43},{11.85,24.75},{16.37,42.83},{94.95,118.91},
  {69.95,121.79},{67.66,99.24},{31.29,52.12},{71.09,121.22},
  {11.21,60.01},{28.75,70.83},{91.64,136.28},{80.47,123.65},
  { 6.45,18.47},{27.80,80.01},{52.41,108.87},{43.77,89.26},
  {85.26,129.07},{80.08,130.29},{20.91,56.22},{68.54,113.27},
  {27.09,75.40},{32.41,71.59},{89.77,122.10},{84.66,135.97},
  {43.95,78.98},{73.07,123.92},{43.96,66.15},{44.89,98.51},
  {55.20,82.11},{83.29,152.36},{34.66,80.66},{83.27,123.97},
  {68.29,110.34},{73.62,138.39},{92.54,138.22},{63.53,125.62},
  { 1.16,17.84},{17.27,37.97},{ 0.74,24.38},{16.48,43.26},
  {98.69,143.62},{53.42,75.94},{76.67,114.93},{55.15,76.82},
  {56.03,88.44},{24.29,61.19},{ 6.35,47.73},{ 0.46,53.57},
  {48.72,69.47},{64.56,104.37},{26.06,60.18},{14.86,33.71},
  {51.01,97.97},{51.73,90.74},{29.93,54.21},{42.12,53.98},
  {92.80,139.04},{14.87,27.85},{98.18,128.47},{ 9.53,54.61},
  {23.45,35.73},{42.78,87.52},{28.47,66.69},{12.86,33.75},
  {29.58,73.39},{70.81,107.22},{87.52,141.50},{17.48,49.17},
  {66.32,100.19},{27.50,84.23},{27.64,60.58},{94.61,133.89},
  { 4.29,40.85},{92.79,159.23},{37.62,80.97},{66.72,114.51},
  {31.07,68.96},{81.34,127.13},{69.01,119.16},{65.32,105.82},
  { 5.53,37.72},{72.19,111.71},{68.16,115.06},{25.81,65.39},
  { 4.96,40.09},{94.84,155.93},{18.84,54.89},{51.80,89.99},
  {11.95,44.36},{62.68,91.92},{78.66,111.60},{88.88,147.29},
  {27.61,45.38},{56.76,95.58},{81.82,123.82},{32.97,58.13},
  {36.91,80.90},{44.96,95.95},{ 9.21,57.71},{ 7.86,43.36},
  {17.95,46.51},{45.83,87.56},{81.40,132.18},{71.12,113.91},
  {69.84,98.46},{70.55,101.33},{50.87,74.76},{66.54,112.16},
  {43.37,90.40},{36.11,69.11},{31.77,66.53},{72.43,116.30},
  {28.88,52.33},{ 4.35,42.31},{35.99,72.81},{70.10,114.37},
  {43.91,91.36},{18.95,36.23},{71.45,110.25},{ 9.69,27.16},
  {56.91,88.84},{36.54,56.69},{62.78,104.90},{87.87,138.53},
  {53.29,92.93},{26.66,82.66},{31.37,76.43},{39.04,68.78},
  { 2.18,41.50},{79.21,123.84},{50.73,85.71},{65.15,106.20},
  {47.80,95.27},{ 3.72,25.24},{65.14,113.81},{69.06,102.94},
  {81.92,122.92},{52.68,69.88},{ 9.84,64.41},{74.83,121.42},
  {26.08,58.80},{64.74,98.10},{92.61,149.03},{64.81,94.85},
  {31.08,66.63},{15.73,47.47},{72.74,101.49},{69.61,103.22},
  {46.48,73.27},{84.36,135.52},{47.93,70.56},{87.18,145.04},
  {63.50,115.20},{ 2.10,30.02},{ 3.72,23.11},{45.35,84.60},
  {60.51,98.20},{98.95,152.96},{46.84,75.09},{19.18,46.19},
  {56.04,85.01},{64.87,107.97},{12.94,41.00},{ 9.30,26.11},
  {10.74,58.84},{58.58,106.89},{92.63,111.41},{85.54,133.03},
  {15.57,23.53},{ 6.96,43.04},{28.00,68.74},{81.80,128.16},
  {47.95,83.41},{51.16,96.83},{10.54,23.23},{34.40,81.57},
  {55.22,94.23},{21.19,59.34},{45.47,100.75},{79.66,137.93},
  {60.00,97.01},{30.74,62.92},{48.22,91.30},{66.36,100.83},
  {35.04,74.98},{91.58,141.63},{66.65,111.99},{88.44,117.44},
  {55.82,83.35},{64.29,93.09},{61.57,107.98},{57.27,114.31},
  {18.83,30.28},{45.93,87.95},{37.82,69.71},{73.09,123.57},
  { 6.94,52.99},{12.96,27.84},{92.59,141.24},{ 5.72,39.08},
  {71.74,105.53},{15.07,52.03},{90.10,147.44},{76.53,103.65},
  {38.50,71.69},{87.17,124.54},{32.46,67.99},{84.10,119.33},
  {86.51,130.38},{67.56,112.91},{71.80,117.42},{48.87,94.18},
  {43.23,75.01},{41.70,73.75},{68.26,117.73},{25.51,55.34},
  {63.24,102.18},{14.84,60.28},{46.20,83.19},{58.14,106.03},
  { 9.51,42.10},{42.06,84.08},{89.91,144.90},{63.25,99.89},
  {35.16,69.70},{74.35,118.34},{39.34,64.09},{60.84,112.26},
  {94.77,143.15},{96.28,134.52},{63.68,94.91},{69.81,117.78},
  {43.74,88.09},{50.98,87.25},{36.56,75.15},{74.94,122.06},
  {29.37,64.41},{ 9.71,24.28},{42.93,85.22},{94.80,135.99},
  {87.32,141.04},{23.94,50.48},{40.00,73.79},{46.61,97.59},
  {48.69,84.84},{33.04,77.53},{72.78,108.17},{21.18,54.92},
  {93.26,142.99},{16.75,33.93},{18.36,51.12},{85.62,123.19},
  {37.21,65.94},{35.75,74.91},{36.52,85.42},{31.30,57.22},
  {61.26,81.06},{45.83,67.09},{ 6.77,45.94},{49.86,68.39},
  {30.86,45.06},{68.49,106.49},{72.25,107.46},{49.09,93.52},
  {48.72,80.74},{ 3.32,31.83},{63.55,94.35},{21.80,64.38},
  {76.59,136.69},{65.88,88.59},{84.31,127.57},{85.30,141.94},
  {84.86,135.57},{27.41,72.56},{85.73,115.38},{78.71,132.39},
  {33.89,58.67},{20.58,58.62},{28.41,66.69},{10.27,46.98},
  {30.16,79.27},{92.20,145.26},{64.94,108.49},{89.64,135.88},
  {82.62,135.86},{69.85,108.34},{48.97,88.12},{49.92,90.14},
  {30.09,79.40},{46.27,79.73},{ 5.73,43.38},{99.27,150.21},
  {90.85,143.28},{66.88,123.52},{31.98,78.12},{68.28,104.85},
  {44.95,78.70},{49.78,88.41},{45.65,89.31},{65.19,117.43},
  {75.52,114.78},{41.15,70.51},{98.15,151.45},{20.22,48.03},
  {16.28,48.80},{81.28,130.12},{77.62,99.30},{31.24,61.49},
  {18.01,35.99},{ 5.08,30.23},{32.26,58.72},{14.53,40.13},
  {33.50,62.77},{31.75,59.10},{59.42,96.18},{83.63,126.46},
  {52.94,94.28},{30.89,66.56},{55.54,104.85},{77.64,121.03},
  {83.64,121.96},{ 4.71, 7.57},{56.96,91.71},{91.41,172.02},
  {82.93,131.61},{71.76,105.94},{57.08,103.03},{80.04,135.29},
  {72.62,122.89},{33.00,78.12},{ 5.83,39.65},{ 8.32,39.78},
  {43.06,73.40},{86.81,133.44},{99.65,133.66},{36.90,69.30},
  {33.18,70.81},{98.66,150.67},{90.12,126.85},{26.17,56.34},
  {20.44,37.85},{71.93,102.37},{89.75,133.62},{53.39,86.14},
  {27.91,58.88},{94.70,156.37},{68.90,106.27},{71.66,112.03},
  { 2.95,54.32},{57.50,104.86},{ 1.66,31.75},{67.65,103.19},
  {53.47,82.34},{80.24,146.44},{11.93,47.45},{12.64,42.38},
  {86.19,118.95},{29.66,72.35},{57.60,108.95},{17.56,53.59},
  {47.09,110.10},{41.13,60.76},{24.61,38.87},{35.72,78.61},
  {11.09,40.00},{69.37,112.48},{33.37,66.51},{85.90,135.84},
  {40.91,82.91},{21.40,40.42},{19.32,55.80},{77.00,120.62},
  {90.37,124.87},{65.80,110.60},{43.02,97.02},{46.65,84.02},
  {91.37,141.58},{12.99,50.47},{33.39,73.92},{17.76,52.14},
  {95.40,136.66},{74.37,119.21},{14.47,56.08},{80.24,118.06},
  {62.19,96.25},{73.30,109.05},{79.67,124.39},{33.11,62.39},
  {28.35,59.20},{25.35,62.15},{13.42,47.33},{18.65,40.88},
  { 3.71,26.66},{92.25,139.16},{51.04,95.81},{ 9.11,37.65},
  {14.37,45.66},{14.40,42.04},{13.55,59.41},{ 4.60,35.20},
  {28.29,49.90},{26.42,62.31},{78.01,121.38},{89.25,124.37},
  {99.43,154.99},{ 4.43,34.80},{15.33,58.51},{56.56,103.08},
  {16.53,59.59},{96.02,132.54},{66.44,96.09},{27.56,62.36},
  {25.74,66.37},{43.28,90.84},{43.73,80.38},{79.41,121.38},
  {59.75,100.07},{43.76,83.84},{57.28,84.06},{77.37,132.64},
  {97.70,139.58},{36.08,83.37},{ 3.78,39.96},{53.94,91.10},
  {31.37,61.94},{ 1.34,33.50},{11.61,51.64},{ 1.57,28.77},
  {89.15,140.83},{36.19,74.31},{60.94,113.69},{18.59,47.62},
  {99.58,137.45},{88.14,135.62},{20.50,46.98},{74.20,123.09},
  {73.47,117.99},{54.50,100.31},{80.86,119.64},{11.46,40.97},
  {12.62,42.81},{83.71,142.23},{22.54,60.19},{76.07,108.84},
  {46.37,95.36},{20.96,71.97},{21.94,60.98},{42.53,79.08},
  {50.31,88.00},{75.94,137.57},{88.72,125.13},{76.02,107.18},
  {56.13,92.37},{78.23,110.15},{35.55,80.92},{70.61,136.49},
  {67.31,115.35},{95.59,143.96},{20.05,44.10},{60.14,102.02},
  {58.35,93.18},{38.33,73.63},{88.40,123.57},{78.76,112.78},
  {15.22,40.53},{19.46,61.57},{34.06,70.61},{81.31,131.36},
  {82.39,132.94},{52.75,65.07},{48.09,84.56},{94.50,144.24},
  {92.82,140.78},{47.02,79.90},{52.08,91.89},{70.58,124.20},
  {70.80,108.34},{40.33,80.65},{11.39,36.18},{30.76,81.63},
  {20.19,56.87},{57.24,109.79},{85.86,118.85},{81.26,139.85},
  {97.32,137.68},{74.99,124.51},{58.04,86.65},{32.83,48.55},
  {61.05,101.86},{ 8.57,40.13},{27.18,74.97},{33.03,58.34},
  {67.19,120.11},{87.68,126.11},{27.53,58.95},{10.62,43.26},
  {60.31,97.64},{63.83,94.05},{58.87,99.27},{10.78,31.74},
  {29.88,60.09},{78.52,115.62},{73.80,127.00},{24.48,73.88},
  {55.61,98.87},{16.45,32.41},{45.24,89.93},{21.91,63.12},
  {77.58,117.05},{77.38,121.42},{ 9.05,25.23},{10.29,31.07},
  {77.43,118.57},{ 3.94,22.36},{12.44,43.13},{51.96,94.82},
  { 9.27,27.98},{19.89,62.36},{55.98,92.69},{31.72,92.17},
  {43.62,83.87},{44.10,71.43},{12.19,29.79},{78.56,122.35},
  { 1.94,28.44},{21.77,60.78},{11.04,30.22},{11.41,52.18},
  {73.11,103.56},{87.47,151.71},{ 4.44,38.38},{ 5.12,39.89},
  {74.85,110.47},{33.73,65.16},{21.85,60.65},{90.16,141.33},
  {34.31,74.89},{42.82,70.47},{94.46,152.98},{25.01,48.69},
  {34.23,64.57},{85.00,122.05},{76.05,112.17},{30.16,58.09},
  {35.14,73.11},{84.59,117.76},{80.50,115.62},{96.58,141.10},
  {71.01,109.16},{69.89,129.57},{10.34,49.14},{38.80,83.75},
  {43.66,77.27},{ 2.73,28.89},{61.10,92.38},{81.06,136.78},
  {84.33,138.83},{62.34,96.79},{98.13,163.18},{32.59,70.67},
  {17.95,37.79},{83.26,121.61},{36.22,65.10},{83.85,124.91},
  {23.30,65.53},{91.59,141.30},{65.68,103.15},{ 8.93,31.84},
  {15.25,44.21},{50.19,95.52},{72.73,121.38},{82.09,119.58},
  {89.02,139.59},{ 2.54,40.33},{42.44,81.52},{54.44,80.91},
  { 3.13,12.60},{ 4.55,33.88},{72.52,134.98},{30.13,62.26},
  {16.13,27.82},{43.49,86.00},{25.38,55.31},{ 8.66,58.83},
  {39.27,80.58},{82.48,123.35},{13.99,27.93},{36.92,63.77},
  {78.87,129.10},{98.56,152.80},{81.45,132.28},{39.01,68.53},
  {41.18,75.03},{61.19,110.85},{ 9.16,28.75},{98.96,158.29},
  {52.25,104.46},{53.73,102.82},{73.33,115.09},{43.61,85.97},
  {40.72,58.94},{88.16,146.73},{21.69,49.90},{38.22,100.33},
  {50.86,84.10},{40.98,79.44},{84.53,145.30},{ 1.70,46.66},
  {53.38,87.74},{ 1.06,19.29},{24.53,50.06},{66.32,112.26},
  {90.05,136.74},{36.88,72.99},{95.12,139.60},{22.16,38.69},
  {85.05,139.31},{16.18,42.40},{ 2.37,35.40},{73.31,98.46},
  {15.10,54.76},{ 4.68,35.96},{88.19,124.09},{48.82,85.80},
  {26.23,48.93},{90.38,137.03},{10.46,57.31},{ 6.07,38.47},
  {69.61,97.05},{28.35,62.11},{19.06,33.77},{61.62,112.77},
  {43.54,96.76},{90.40,115.16},{ 5.04,26.59},{68.97,113.70},
  { 4.84,13.07},{31.44,67.59},{38.32,68.52},{96.62,146.78},
  {84.71,123.20},{47.30,90.22},{99.05,171.16},{93.28,119.71},
  {65.10,107.55},{54.20,103.74},{25.79,48.80},{23.42,63.12},
  {51.90,91.70},{30.32,69.79},{63.81,112.35},{65.35,101.68},
  {26.74,63.11},{10.82,45.03},{ 0.26,30.20},{48.75,100.17},
  {28.29,72.09},{ 7.73,59.77},{24.53,57.70},{82.90,120.74},
  {40.72,75.87},{ 7.58,35.27},{38.30,68.70},{34.64,83.64},
  { 8.05,18.41},{33.58,64.69},{56.72,91.53},{97.42,148.42},
  {11.62,33.90},{11.55,45.17},{26.22,55.35},{66.61,111.49},
  {43.61,89.80},{43.80,77.62},{29.15,83.24},{67.30,125.13},
  { 9.52,46.34},{52.05,84.90},{28.38,65.74},{91.62,144.66},
  {30.89,60.38},{70.23,104.40},{89.89,144.70},{15.82,74.01},
  {11.54,41.95},{12.18,43.67},{39.28,85.85},{16.45,53.93},
  {12.31,36.43},{77.27,127.01},{98.08,139.55},{21.37,63.15},
  {97.53,139.77},{29.24,68.70},{38.79,70.82},{17.57,57.55},
  {10.10,47.91},{38.37,68.76},{83.06,115.82},{30.93,73.79},
  {46.87,92.75},{ 7.03,23.94},{90.36,130.34},{64.30,103.64},
  {81.86,128.84},{70.54,95.08},{55.82,90.97},{54.70,80.73},
  {66.37,104.02},{ 0.25,30.14},{81.74,121.53},{15.81,48.71},
  {98.72,150.00},{72.98,128.25},{82.25,131.46},{82.21,130.73},
  {70.15,129.81},{17.86,44.19},{11.69,26.98},{ 1.27,33.81},
  {29.19,50.97},{68.97,115.61},{98.19,131.35},{28.79,72.60},
  { 4.58,47.89},{80.91,136.58},{ 6.78,33.05},{35.20,67.85},
  {19.57,41.22},{83.00,136.36},{57.11,107.30},{41.01,83.85},
  {10.05,43.01},{ 9.56,55.32},{42.43,90.56},{92.75,149.11},
  {84.70,118.74},{66.56,106.98},{ 4.58,28.97},{ 8.43,47.54},
  { 4.23,35.90},{92.27,148.90},{97.17,140.03},{81.73,122.05},
  {61.29,95.27},{13.95,53.50},{56.76,111.09},{98.27,150.58},
  {92.37,137.08},{18.78,63.69},{69.23,97.58},{23.41,74.93},
  {78.17,136.28},{60.26,102.26},{38.57,63.86},{68.63,123.90},
  {40.25,63.13},{52.96,82.54},{13.91,50.85},{38.66,92.67},
  {36.16,61.27},{79.03,150.65},{87.10,132.79},{23.94,63.97},
  {10.13,27.34},{14.20,25.76},{12.16,40.21},{ 9.23,38.79},
  {62.15,94.55},{16.67,50.63},{32.36,60.02},{ 7.52,45.26},
  {60.15,100.92},{48.98,80.57},{35.85,78.51},{10.46,41.01},
  {23.05,60.93},{ 8.12,31.05},{35.46,78.48},{23.56,55.86},
  {96.29,147.09},{61.35,92.18},{ 8.91,51.22},{90.00,123.92},
  {66.43,114.13},{ 3.83,42.40},{13.88,20.39},{ 1.65,28.18},
  {35.82,58.35},{99.86,151.20},{51.28,86.45},{36.82,59.84},
  {86.32,128.76},{ 5.18,32.97},{87.01,133.19},{15.27,46.37},
  {94.93,133.71},{80.00,120.31},{63.37,105.16},{49.70,91.23},
  {91.23,142.48},{54.71,94.90},{79.48,107.05},{51.98,86.99},
  {49.04,85.39},{32.42,71.57},{99.77,146.66},{91.06,143.81}
};

double residual_error(double r, double a, double m, double c) {
  double e = (m * r) + c - a;
  return e * e;
}
__device__ double d_residual_error(double r, double a, double m, double c) {
  double e = (m * r) + c - a;
  return e * e;
}
double rms_error(double m, double c) {
  int i;
  double mean;
  double error_sum = 0;
  
  for(i=0; i<n_data; i++) {
    error_sum += residual_error(data[i].x, data[i].y, m, c);  
  }
  
  mean = error_sum / n_data;
  
  return sqrt(mean);
}
__global__ void d_rms_error(double *m, double *c,double *error_sum_arr,point_t *d_data) {
  int i = threadIdx.x + blockIdx.x *blockDim.x;
error_sum_arr[i] = d_residual_error(d_data[i].x,d_data[i].y, *m, *c);
}

int time_difference(struct timespec *start, struct timespec *finish, long long int *difference)
{
long long int ds = finish->tv_sec - start->tv_sec;
long long int dn = finish->tv_nsec - start->tv_nsec;

 if(dn < 0){
  ds--;
  dn += 1000000000;
}
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0); 
}



int main(){
 int i;
  double bm = 1.3;
  double bc = 10;
  double be;
  double dm[8];
  double dc[8];
  double e[8];
  double step = 0.01;
  double best_error = 999999999;
  int best_error_i;
  int minimum_found = 0;
  
  double om[] = {0,1,1, 1, 0,-1,-1,-1};
  double oc[] = {1,1,0,-1,-1,-1, 0, 1};

struct timespec start, finish;
	long long int time_elapsed;
	clock_gettime(CLOCK_MONOTONIC, &start);
cudaError_t error;


double *d_dm;
double *d_dc;
double *d_error_sum_arr;
point_t *d_data;

be= rms_error(bm,bc);

error=cudaMalloc(&d_dm,(sizeof(double) * 8));
if(error){
fprintf(stderr,"cudaMalloc on d_dm returned %d %s\n",error,
cudaGetErrorString(error));
exit(1);
}

error=cudaMalloc(&d_dc,(sizeof(double) * 8));
if(error){
fprintf(stderr,"cudaMalloc on d_dc returned %d %s\n",error,
cudaGetErrorString(error));
exit(1);
}

error=cudaMalloc(&d_error_sum_arr,(sizeof(double) * 1000));
if(error){
fprintf(stderr,"cudaMalloc on d_error_sum_arr returned %d %s\n",error, //371
cudaGetErrorString(error));
exit(1);
}

error=cudaMalloc(&d_data,sizeof(data)); //376
if(error){
fprintf(stderr,"cudaMalloc on d_data returned %d %s\n",error,
cudaGetErrorString(error));
exit(1);
}

while(!minimum_found) {
    for(i=0;i<8;i++) {
dm[i] = bm + (om[i] * step);
dc[i]= bc + (oc[i] * step);
}

 error = cudaMemcpy(d_dm,dm,(sizeof(double)*8), cudaMemcpyHostToDevice);
if(error){
fprintf(stderr,"cudaMemcpy to d_dm returned %d %s\n",error,
cudaGetErrorString(error));
}

 error = cudaMemcpy(d_dc,dc,(sizeof(double)*8), cudaMemcpyHostToDevice);
if(error){
fprintf(stderr,"cudaMemcpy to d_dc returned %d %s\n",error,
cudaGetErrorString(error));
}

error = cudaMemcpy(d_data, data,sizeof(data), cudaMemcpyHostToDevice); //401
if(error){
fprintf(stderr,"cudaMemcpy to d_data returned %d %s\n",error,
cudaGetErrorString(error));
}

for(i=0;i<8;i++){
double h_error_sum_arr[1000];

double error_sum_total;
double error_sum_mean;

d_rms_error <<<100,10>>>(&d_dm[i],&d_dc[i],d_error_sum_arr,d_data);
cudaThreadSynchronize();
error =cudaMemcpy(&h_error_sum_arr,d_error_sum_arr,(sizeof(double) *1000),
cudaMemcpyDeviceToHost);
if(error){
fprintf(stderr,"cudaMemcpy to error_sum returned %d %s\n",error,
cudaGetErrorString(error));
}
for(int j=0;j<n_data;j++){
error_sum_total+= h_error_sum_arr[j];
}
error_sum_mean = error_sum_total / n_data;
e[i] =sqrt(error_sum_mean);

if(e[i] < best_error){
best_error = e[i];
error_sum_total +=h_error_sum_arr[i];
}
error_sum_mean = error_sum_total /n_data;//431
e[i] =  sqrt(error_sum_mean); //432

if(e[i]<best_error){ //434
best_error = e[i];
best_error_i = i;
}
 error_sum_total = 0;  //438
}
if(best_error <be){
be=best_error;
bm =dm[best_error_i];
bc= dc[best_error_i];
}else {
minimum_found = 1;
}
}


error = cudaFree(d_dm);
if(error){
fprintf(stderr,"cudaFree on d_dm returned %d %s\n",error,
cudaGetErrorString(error));  //453
exit(1);
}

error = cudaFree(d_dc);
if(error){
fprintf(stderr,"cudaFree on d_dc returned %d %s\n",error,
cudaGetErrorString(error));
exit(1);
}

error = cudaFree(d_data);
if(error){
fprintf(stderr,"cudaFree on d_data returned %d %s\n",error,
cudaGetErrorString(error));
exit(1);
}

error = cudaFree(d_error_sum_arr);
if(error){
fprintf(stderr,"cudaFree on d_error_sum_arr returned %d %s\n",error,
cudaGetErrorString(error));
exit(1);
}


printf("minimum m,c is %lf,%lf with error %lf\n", bm, bc, be);

clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed,
                                         (time_elapsed/1.0e9)); 

return 0;
}

;
