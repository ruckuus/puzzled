<?php

class  Numlet{
  protected $fizz = false;
  protected $buzz = false;

  public function isFizz($n) {
    if ($n % 3 == 0) {
      $this->fizz = true;
      return true;
    }
  }

  public function isBuzz($n) {
    if ($n % 5 == 0) {
      $this->buzz = true;
      return true;
    }
  }

  public function isNormal($n) {
    if (!$this->fizz && !$this->buzz) {
      return false;
    }
  }

  public function fizzBuzz($n) {
    if ($this->isFizz($n)) {
      echo "Fizz ";
    }

    if ($this->isBuzz($n)) {
      echo "Buzz ";
    }

    if ((!$this->fizz) && (!$this->buzz)) {
      echo $n . " ";
    }
  }
}

for ($i = 1; $i < 20; $i++) {
  $x = new Numlet();
  $x->fizzBuzz($i);
}