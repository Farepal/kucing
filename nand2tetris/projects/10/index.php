<?php
class JackTokenizer
{
    private $regexKeyword = '/^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$/';
    private $regexSymbol = '/^(\{|\}|\(|\)|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)$/';
    private $regexIntegerConstant = '/^(\d+)$/';
    private $regexStringConstant = '/^\"(.*)\"$/';
    private $regexIdentifier = '/^([a-zA-Z_][a-zA-Z0-9]*)$/';

    private $outputFile;
    private $currentToken = '';
    private $tokens = [];
    private $currentIndex = 0;

    public function __construct($inputFile)
    {
        $this->outputFile = str_replace('.jack', 'FT.xml', $inputFile);
        $allLine = file($inputFile, FILE_IGNORE_NEW_LINES);
        $this->tokens = $this->cleanCodeToTokens($allLine);
    }

    public function hasMoreTokens()
    {
        return $this->currentIndex < count($this->tokens);
    }

    public function advance()
    {
        $this->currentToken = $this->tokens[$this->currentIndex];
        $this->currentIndex++;
    }

    public function tokenType()
    {
        if (preg_match($this->regexKeyword, $this->currentToken)) {
            return 'KEYWORD';
        } elseif (preg_match($this->regexSymbol, $this->currentToken)) {
            return 'SYMBOL';
        } elseif (preg_match($this->regexIntegerConstant, $this->currentToken)) {
            return 'INT_CONST';
        } elseif (preg_match($this->regexStringConstant, $this->currentToken)) {
            return 'STRING_CONST';
        } elseif (preg_match($this->regexIdentifier, $this->currentToken)) {
            return 'IDENTIFIER';
        } else {
            return 'UNKNOWN';
        }
    }

    public function keyword()
    {
        return $this->currentToken;
    }

    public function symbol()
    {
        switch ($this->currentToken) {
            case '<':
                return '&lt;';
            case '>':
                return '&gt;';
            case '&':
                return '&amp;';
            default:
                return $this->currentToken;
        }
    }

    public function identifier()
    {
        return $this->currentToken;
    }

    public function intVal()
    {
        return $this->currentToken;
    }

    public function stringVal()
    {
        $stringValue = substr($this->currentToken, 1, strlen($this->currentToken) - 2);
        return $stringValue;
    }

    private function cleanCodeToTokens($allLine)
    {
        $cleanedSlashComments = $this->clearSlashComments($allLine);
        $dirtyOneLine = implode(' ', $cleanedSlashComments);
        $cleanedAsteriskComments = preg_replace('/\/\*.*?\*\//s', '', $dirtyOneLine);
        $spaceBetweenSymbols = preg_replace('/(\{|\}|\(|\)|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)/', ' $1 ', $cleanedAsteriskComments);
        $cleanedRepeatedSpace = preg_replace('/\s+/', ' ', $spaceBetweenSymbols);
        $oneLine = trim($cleanedRepeatedSpace);
        preg_match_all('/"[^"]*"|\S+/', $oneLine, $matches);
        $tokens = $matches[0];
        return $tokens;
    }

    private function clearSlashComments($allLine)
    {
        $cleanedSlashComments = [];
        for ($i = 0; $i < count($allLine); $i++) {
            $line = $allLine[$i];
            $line = preg_replace('/\/\/.*/', '', $line);
            $line = trim($line);
            if ($line) {
                $cleanedSlashComments[] = $line;
            }
        }
        return $cleanedSlashComments;
    }
}

function main($argv)
{
    if (isset($argv[1])) {
        $inputFile = $argv[1];
        $tokenizer = new JackTokenizer($inputFile);
        while ($tokenizer->hasMoreTokens()) {
            $tokenizer->advance();
            $tokenType = $tokenizer->tokenType();
            if ($tokenType == 'KEYWORD') {
                echo "<keyword> " . $tokenizer->keyword() . " </keyword>\n";
            } elseif ($tokenType == 'SYMBOL') {
                echo "<symbol> " . $tokenizer->symbol() . " </symbol>\n";
            } elseif ($tokenType == 'IDENTIFIER') {
                echo "<identifier> " . $tokenizer->identifier() . " </identifier>\n";
            } elseif ($tokenType == 'INT_CONST') {
                echo "<integerConstant> " . $tokenizer->intVal() . " </integerConstant>\n";
            } elseif ($tokenType == 'STRING_CONST') {
                echo "<stringConstant> " . $tokenizer->stringVal() . " </stringConstant>\n";
            }
        }
    } else {
        echo "Usage: php JackTokenizer.php <inputFile.jack>\n";
    }
}

main($argv);
