<?php
$n = intval(trim(fgets(STDIN)));
$listLine = [];
for ($i = 0; $i < $n; $i++) {
    $listLine[] = trim(fgets(STDIN));
}

$listDomain = [];

$domainNameRegex = '/(https:\/\/|http:\/\/)(www\.)?([a-zA-Z0-9-]+)((\.[a-zA-Z0-9-]+)+)/';
foreach ($listLine as $line) {
    if (preg_match_all($domainNameRegex, $line, $matches)) {
        foreach ($matches[0] as $index => $fullMatch) {
            $domain = $matches[3][$index] . $matches[4][$index];
            if (!in_array($domain, $listDomain)) {
                $listDomain[] = $domain;
            }
        }
    }
}

sort($listDomain);
echo implode(';', $listDomain) . PHP_EOL;
