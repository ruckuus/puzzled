#include <stdio.h>

int binary_search(int array[], int start, int len, int element);

int binary_search(int array[], int start, int len, int element)
{
  int real_len = len - 1;
  int min = array[0];
  int max = array[real_len];

  int med = 0;

  if (real_len % 2 == 0)
    med = start + (real_len / 2);
  else
    med = start + ((real_len + 1) / 2); 
  
  int medel = array[med];

  printf("%d, %d, %d, med = %d, medel = %d \n", start, len, element, med, medel);

  if (min == element)
    return 0;

  if (max == element)
    return len;

  if (medel == element)
    return med;

  if (element > medel)
    return binary_search(array, med + 1, len / 2,  element);
  else if (element < medel)
    return binary_search(array, med - (len / 2), len / 2, element );
  else
    return -1;
}

int main(void)
{
  int numbers[] = { 2, 4, 5, 6, 7, 24, 32, 61, 70, 71, 72, 89, 99 };  

  int element = 0;
  int pos = 0;

  element = 24;
  pos = binary_search(numbers, 0, 10, element);
  printf("%d @ %d\n", element, pos);

  element = 7;
  pos = binary_search(numbers, 0, 10, element);
  printf("%d @ %d\n", element, pos);

  element = 99;
  pos = binary_search(numbers, 0, 10, element);
  printf("%d @ %d\n", element, pos);

  element = 2;
  pos = binary_search(numbers, 0, 10, element);
  printf("%d @ %d\n", element, pos);

  element = 70;
  pos = binary_search(numbers, 0, 10, element);
  printf("%d @ %d\n", element, pos);

  element = 99;
  pos = binary_search(numbers, 0, 10, element);
  printf("%d @ %d\n", element, pos);

  return 0;
}
