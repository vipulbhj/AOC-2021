<?php

$P_MAP = array();

function zip($a1, $a2) {
  $res = "";
  $len_a1 = strlen($a1);
  $len_a2 = strlen($a2);

  for($i = 0; $i < min($len_a1, $len_a2); $i++) {
    $res = $res.$a1[$i].$a2[$i];
  }
  
  if($len_a1 < $len_a2) {
    $t = substr($a2, min($len_a1, $len_a2), ($len_a2 - $len_a1));
    return $res.$t;
  } else if($len_a1 > $len_a2) {
    $t = substr($a1, min($len_a1, $len_a2), ($len_a1 - $len_a2));
    return $res.$t;
  } else {
    return $res;
  }
}

function iterate($map, $init, $f, $times) {
  $res = array();

  for($i = 0; $i < (strlen($init) - 1); $i++) {
    $ss = substr($init, $i, 2);
    if(array_key_exists($ss, $res)) {
      $res[$ss] += 1;
    } else {
      $res[$ss] = 1;
    }
  }
  
  for($i = 0; $i < $times; $i++) {
    $res = $f($map, $res);
  }

  return $res;
}

function process_val($P_MAP, $init) {
  $res = array();

  foreach ($init as $key => $value) {
    $comps = str_split($key);
    $chr = $P_MAP[$key];

    if(array_key_exists($comps[0].$chr, $res)) {
      $res[$comps[0].$chr] += $value;
    } else {
      $res[$comps[0].$chr] = $value;
    }

    if(array_key_exists($chr.$comps[1], $res)) {
      $res[$chr.$comps[1]] += $value;
    } else {
      $res[$chr.$comps[1]] = $value;
    }
  }

  return $res;
}

function part_one($P_MAP, $init) {
  $res = iterate($P_MAP, $init, "process_val", 10);
  $countMap = array();
  foreach($res as $k => $v) {
    $t = str_split($k);
    foreach($t as $c) {
      if(array_key_exists($c, $countMap)) {
        $countMap[$c] += $v;
      } else {
        $countMap[$c] = $v;
      }
    }
  }
  $vals = array_values($countMap);
  var_dump(round(max($vals) / 2) - round(min($vals) / 2));
}

function part_two($P_MAP, $init) {
  $res = iterate($P_MAP, $init, "process_val", 40);
  $countMap = array();
  foreach($res as $k => $v) {
    $t = str_split($k);
    foreach($t as $c) {
      if(array_key_exists($c, $countMap)) {
        $countMap[$c] += $v;
      } else {
        $countMap[$c] = $v;
      }
    }
  }
  $vals = array_values($countMap);
  var_dump(round(max($vals) / 2) - round(min($vals) / 2));
}

$file = fopen("input.txt","r");
$init = trim(fgets($file));
fgets($file);

while(!feof($file)) {
  $t = explode(" -> ", trim(fgets($file)));
  if (!isset($t[1])) {
   continue;
  }

  $P_MAP[$t[0]] = $t[1];
}

part_one($P_MAP, $init);
part_two($P_MAP, $init);

fclose($file);

?>
