<?php
$n = intval(trim(fgets(STDIN)));
$listLine = [];
for ($i = 0; $i < $n; $i++) {
    $listLine[] = trim(fgets(STDIN));
}

foreach ($listLine as $line) {
    if (preg_match('/^hackerrank$/i', $line)) {
        echo 0 . PHP_EOL;
    } elseif (preg_match('/^hackerrank/i', $line)) {
        echo 1 . PHP_EOL;
    } elseif (preg_match('/hackerrank$/i', $line)) {
        echo 2 . PHP_EOL;
    } else {
        echo -1 . PHP_EOL;
    }
}
