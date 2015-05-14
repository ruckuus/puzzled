var insert = function(array, rightIndex, value) {
     
    for(var i = rightIndex; i >= 0 && (array[i] > value); i--) {
      array[i + 1] = array[i];
    }

    array[i + 1] = value;
};

var insertionSort = function(array) {
  var i;
  for (i = 1; i < array.length; i++) {
    insert(array, i - 1, array[i]); 
  }
}


var array = [3, 5, 7, 11, 13, 2, 9, 6];
insert(array, 4, 2);
console.log(array)

var array = [ 2, 3, 5, 7, 11, 13, 9, 6 ];
insert(array, 1, 3);
console.log(array)

var array = [22, 11, 99, 88, 9, 7, 42];
insertionSort(array);
console.log(array);

