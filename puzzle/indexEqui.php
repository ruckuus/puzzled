<?php
/*
A[0] = -7   A[1] =  1   A[2] = 5
A[3] =  2   A[4] = -4   A[5] = 3
A[6] =  0 */

$A = array (-7, 1, 5, 2, -4, 3, 0);

function solution($A) {
  $sum_left = 0;
  $sum_right = 0;

  $siz = count($A);

  for($i = 0; $i < $siz; $i++) {
    $sum_left = 0;
    $sum_right = 0;
    if ($i == 0) {
      $sum_left = 0;
    } else {
      for ($k = 0; $k < $i; $k++) {
        $sum_left += $A[$k];
      }
    }

    if ($i == $siz - 1) {
      $sum_right = 0;
    } else {
      $j = $i +1;
      for($j; $j < $siz; $j++) {
        $sum_right += $A[$j];
      }
    }
    
    if ($sum_left == $sum_right) {
      return $i;
    }
  }
    return -1;

}

if ($r = solution($A) != -1) {
  echo "Index Equi: $r\n";
} 
