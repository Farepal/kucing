<?php
$n = intval(trim(fgets(STDIN)));
$lines = [];
for ($i = 0; $i < $n; $i++) {
    $lines[] = trim(fgets(STDIN));
}

$validPAN = '/^[A-Z]{5}[0-9]{4}[A-Z]$/';
for ($i = 0; $i < $n; $i++) {
    if (preg_match($validPAN, $lines[$i])) {
        echo 'YES' . PHP_EOL;
    } else {
        echo 'NO' . PHP_EOL;
    }
}
