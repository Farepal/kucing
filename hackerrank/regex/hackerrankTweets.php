<?php
$n = intval(trim(fgets(STDIN)));
$lines = [];
for ($i = 0; $i < $n; $i++) {
    $lines[] = trim(fgets(STDIN));
}

$hackerrankTweets = '/hackerrank/i';

$count = 0;
foreach ($lines as $line) {
    if (preg_match($hackerrankTweets, $line)) {
        $count++;
    }
}

echo $count;
