<?php
$_fp = fopen("php://stdin", "r");

$isC = false;
$isJava = false;
$isPython = false;

$listCRegex = [
    '/#include\s<\w+\.h>/',
    '/int\smain\(\)\s{/',
    '/return\s0;/',
];

$listJavaRegex = [
    '/import\sjava\.\w+;/',
    '/public\sclass\s\w+\s{/',
    '/public\sstatic\svoid\smain\(\w+\s\w+\)\s{/',
];

$listPythonRegex = [
    '/def\s\w+\(\):/',
    '/print\(".*"\)/',
    '/print\s".*"/',
];

while (!feof($_fp)) {
    $line = trim(fgets($_fp));

    foreach ($listCRegex as $regex) {
        if (preg_match($regex, $line)) {
            $isC = true;
            break;
        }
    }

    if ($isC) {
        break;
    }

    foreach ($listJavaRegex as $regex) {
        if (preg_match($regex, $line)) {
            $isJava = true;
            break;
        }
    }

    if ($isJava) {
        break;
    }

    foreach ($listPythonRegex as $regex) {
        if (preg_match($regex, $line)) {
            $isPython = true;
            break;
        }
    }

    if ($isPython) {
        break;
    }
}
