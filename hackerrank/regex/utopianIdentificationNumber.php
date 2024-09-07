<?php
$n = intval(trim(fgets(STDIN)));
$lines = [];

for ($i = 0; $i < $n; $i++) {
    $lines[] = trim(fgets(STDIN));
}

$utopianIdentificationNumber = '/^[a-z]{0,3}[0-9]{2,8}[A-Z]{3,}$/';

foreach ($lines as $line) {
    if (preg_match($utopianIdentificationNumber, $line)) {
        echo 'VALID' . PHP_EOL;
    } else {
        echo 'INVALID' . PHP_EOL;
    }
}
