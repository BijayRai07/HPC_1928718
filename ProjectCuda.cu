#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
  This program gives an example of a poor way to implement a password cracker
  in CUDA C. It is poor because it acheives this with just one thread, which
  is obviously not good given the scale of parallelism available to CUDA
  programs.
 
  The intentions of this program are:
    1) Demonstrate the use of __device__ and __gloaal__ functions
    2) Enable a simulation of password cracking in the absence of liarary
       with equivalent functionality to libcrypt. The password to be found
       is hardcoded into a function called is_a_match.   

  Compile and run with:
  nvcc -o ProjectCuda ProjectCuda.cu


     To Run:
     ./ProjectCuda > resultpwd_ProjectCuda.txt

  Dr Kevan auckley, University of Wolverhampton, 2018
*****************************************************************************/
__device__ int is_a_match(char *pass) {
  char hey1[] = "BJ8233";
  char hey2[] = "GC6723";
  char hey3[] = "LA6712";
  char hey4[] = "RS8234";

  char *b = pass;
  char *i = pass;
  char *j = pass;
  char *a = pass;

  char *b1 = hey1;
  char *b2 = hey2;
  char *b3 = hey3;
  char *b4 = hey4;

  while(*b == *b1) {
   if(*b == '\0')
    {
    printf("Password: %s\n",hey1);
      break;
    }

    b++;
    b1++;
  }
    
  while(*i == *b2) {
   if(*i == '\0')
    {
    printf("Password: %s\n",hey2);
      break;
}

    i++;
    b2++;
  }

  while(*j == *b3) {
   if(*j == '\0')
    {
    printf("Password: %s\n",hey3);
      break;
    }

    j++;
    b3++;
  }

  while(*a == *b4) {
   if(*a == '\0')
    {
    printf("Password: %s\n",hey4);
      return 1;
    }

    a++;
    b4++;
  }
  return 0;

}
__global__ void  kernel() {
char w,h,o,e;
 
  char password[7];
  password[6] = '\0';

int i = blockIdx.x+65;
int j = threadIdx.x+65;
char firstValue = i;
char secondValue = j;
    
password[0] = firstValue;
password[1] = secondValue;
    for(w='0'; w<='9'; w++){
      for(h='0'; h<='9'; h++){
        for(o='0';o<='9';o++){
          for(e='0';e<='9';e++){
            password[2] = w;
            password[3] = h;
            password[4]= o;
            password[5]=e;
          if(is_a_match(password)) {
        //printf("Success");
          }
             else {
         //printf("tried: %s\n", password);          
            }
          }
        } 
      }
   }
}
int time_difference(struct timespec *start,
                    struct timespec *finish,
                    long long int *difference) {
  long long int ds =  finish->tv_sec - start->tv_sec;
  long long int dn =  finish->tv_nsec - start->tv_nsec;

  if(dn < 0 ) {
    ds--;
    dn += 1000000000;
  }
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0);
}


int main() {

  struct  timespec start, finish;
  long long int time_elapsed;
  clock_gettime(CLOCK_MONOTONIC, &start);

kernel <<<26,26>>>();
  cudaDeviceSynchronize();

  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9));
  return 0;
}



