<?php
$n = intval(trim(fgets(STDIN)));
$listLine = [];
for ($i = 0; $i < $n; $i++) {
    $listLine[] = trim(fgets(STDIN));
}

foreach ($listLine as $line) {
    if (preg_match('/^hi\s[^d].*/i', $line)) {
        echo $line . PHP_EOL;
    }
}
