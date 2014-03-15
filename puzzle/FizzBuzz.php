<?php
$out = array_map(function($n) { return (''==($m=(($n % 3 == 0) ? "Fizz" : '') . ( ($n % 5 == 0) ? "Buzz" : '')) )?$n:$m; }, range(1,100));
foreach($out as $i) {
  echo "${i}\n";
}