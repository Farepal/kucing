<?php
class JackTokenizer
{
    private $regexKeyword = '/^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$/';
    private $regexSymbol = '/^(\{|\}|\(|\)|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)$/';
    private $regexIntegerConstant = '/^(\d+)$/';
    private $regexStringConstant = '/^\"(.*)\"$/';
    private $regexIdentifier = '/^([a-zA-Z_][a-zA-Z0-9]*)$/';

    private $inputFile, $outputFile;
    private $allLines = [];
    private $currentLine = '';
    private $currentToken = '';

    public function __construct($inputFile)
    {
        $this->inputFile = $inputFile;
        $this->outputFile = str_replace('.jack', 'T.xml', $inputFile);
        $this->allLines = file($inputFile, FILE_IGNORE_NEW_LINES);
        echo "Processing $inputFile\n";
    }
}

function main($argv)
{
    if (isset($argv[1])) {
        $inputFile = $argv[1];
        $tokenizer = new JackTokenizer($inputFile);
    } else {
        echo "Usage: php JackTokenizer.php <inputFile.jack>\n";
    }
}

main($argv);
