<?php
$_fp = fopen("php://stdin", "r");

$inMultiLineComment = false;

$singeLineCommentRegex = '/(\/\/.*$)/';
$multiLineCommentLine = '/(\/\*.*\*\/)/';
$multiLineCommentStart = '/(\/\*.*)$/';
$multiLineCommentEnd = '/(.*\*\/)/';

$lineOutput = [];
while (feof($_fp) === false) {
    $line = trim(fgets($_fp));

    if (preg_match(($multiLineCommentStart), $line, $matches) && !$inMultiLineComment) {
        echo $matches[1] . PHP_EOL;
        $inMultiLineComment = true;
        if (preg_match('/.*\*\/$/', $line)) {
            $inMultiLineComment = false;
        }
    } elseif ($inMultiLineComment) {
        if (preg_match($multiLineCommentEnd, $line, $matches)) {
            echo $matches[1] . PHP_EOL;
            $inMultiLineComment = false;
        } else {
            echo $line . PHP_EOL;
        }
    } elseif (preg_match($singeLineCommentRegex, $line, $matches)) {
        echo $matches[1] . PHP_EOL;
    } elseif (preg_match($multiLineCommentLine, $line, $matches)) {
        echo $matches[1] . PHP_EOL;
    }
}
