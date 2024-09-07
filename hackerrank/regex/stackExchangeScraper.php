<?php
$_fp = fopen("php://stdin", "r");

$regexQuestionNumber = '/question-summary-(\d+)"/';
$regexQuestionTitle = '/<a href="[^"]+" class="question-hyperlink">([^<]+)<\/a>/';
$regexAgo = '/class="relativetime">([^<]+)<\/span>/';
$list = [];

$questionNumber = '';
$questionTitle = '';
$ago = '';
while ($line = fgets($_fp)) {
    if (preg_match($regexQuestionNumber, $line, $matches)) {
        $questionNumber = $matches[1];
    } elseif (preg_match($regexQuestionTitle, $line, $matches)) {
        $questionTitle = $matches[1];
    } elseif (preg_match($regexAgo, $line, $matches)) {
        $ago = $matches[1];
        $list[] = [
            'questionNumber' => $questionNumber,
            'questionTitle' => $questionTitle,
            'ago' => $ago
        ];
        $questionNumber = '';
        $questionTitle = '';
        $ago = '';
    }
}

foreach ($list as $item) {
    echo $item['questionNumber'] . ';' . $item['questionTitle'] . ';' . $item['ago'] . PHP_EOL;
}
