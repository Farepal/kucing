<?php
$n = intval(trim(fgets(STDIN)));
$lines = [];
for ($i = 0; $i < $n; $i++) {
    $lines[] = trim(fgets(STDIN));
}

$listValid = [];

foreach ($lines as $line) {
    $validLatitude = '/^\([+-]?([0-9](\.\d+)?|[1-8][0-9](\.\d+)?|90(\.0+)?),\s[+-]?([0-9](\.\d+)?|[1-9][0-9](\.\d+)?|1[0-7][0-9](\.\d+)?|180(\.0+)?)\)$/';
    if (preg_match($validLatitude, $line)) {
        $listValid[] = 'Valid';
    } else {
        $listValid[] = 'Invalid';
    }
}

for ($i = 0; $i < $n; $i++) {
    echo $listValid[$i] . PHP_EOL;
}
