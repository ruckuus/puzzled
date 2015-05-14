var factorial = function(n) {
  if (n === 0) {
    return 1;
  }

  if (n > 1) {
    return n * factorial(n - 1);
  }
}

var factorial_iterative = function(n) {
  var res =  1;
  for(var i = n; i > 0; i--) {
    res = res * i;
  }

  return res;
}
