<?php
class JackTokenizer
{
    private $regexKeyword = '/^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$/';
    private $regexSymbol = '/^(\{|\}|\(|\)|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)$/';
    private $regexIntegerConstant = '/^(\d+)$/';
    private $regexStringConstant = '/^\"(.*)\"$/';
    private $regexIdentifier = '/^([a-zA-Z_][a-zA-Z0-9_]*)$/';

    private $currentToken = '';
    private $tokens = [];
    private $currentIndex = 0;

    public function __construct($inputFile)
    {
        $allLine = file($inputFile, FILE_IGNORE_NEW_LINES);
        $this->tokens = $this->cleanCodeToTokens($allLine);
    }

    public function getCurrentToken()
    {
        switch ($this->tokenType()) {
            case 'KEYWORD':
                return $this->keyword();
            case 'SYMBOL':
                return $this->symbol();
            case 'IDENTIFIER':
                return $this->identifier();
            case 'INT_CONST':
                return $this->intVal();
            case 'STRING_CONST':
                return $this->stringVal();
            default:
                return 'UNKNOWN';
        }
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

class compilationEngine
{
    private $nextToken, $nextTokenType;
    private $numberOfTabs = 0;
    private $tokenizer;
    private $outputFileXML, $outputFileTXML;

    public function __construct($inputFile)
    {
        $this->outputFileXML = str_replace('.jack', 'php.xml', $inputFile);
        file_put_contents($this->outputFileXML, '');
        $this->outputFileTXML = str_replace('.jack', 'phpT.xml', $inputFile);
        file_put_contents($this->outputFileTXML, '');
        $this->tokenizer = new JackTokenizer($inputFile);
        $this->fullProcess();
    }

    private function advance()
    {
        $this->writeCompilationEngine($this->getXMLdata());
        $this->tokenizerAdvanceAndWriteT();
    }

    private function tokenizerAdvanceAndWriteT()
    {
        if ($this->tokenizer->hasMoreTokens()) {
            $this->tokenizer->advance();
            $this->nextToken = $this->tokenizer->getCurrentToken();
            $this->nextTokenType = $this->tokenizer->tokenType();
            file_put_contents($this->outputFileTXML, $this->getXMLdata() . "\n", FILE_APPEND);
        }
    }

    private function fullProcess()
    {
        file_put_contents($this->outputFileTXML, "<tokens>\n", FILE_APPEND);
        $this->tokenizerAdvanceAndWriteT();
        $this->compileClass();
        file_put_contents($this->outputFileTXML, "</tokens>\n", FILE_APPEND);
    }

    private function getXMLdata()
    {
        $tokenTypeParser = [
            'KEYWORD' => 'keyword',
            'SYMBOL' => 'symbol',
            'IDENTIFIER' => 'identifier',
            'INT_CONST' => 'integerConstant',
            'STRING_CONST' => 'stringConstant',
        ];

        $xmlData = "<{$tokenTypeParser[$this->nextTokenType]}> {$this->nextToken} </{$tokenTypeParser[$this->nextTokenType]}>";
        return $xmlData;
    }

    private function writeCompilationEngine($string)
    {
        $tabs = str_repeat('  ', $this->numberOfTabs);
        $stringWithTabs = $tabs . $string;
        file_put_contents($this->outputFileXML, $stringWithTabs . "\n", FILE_APPEND);
    }

    private function writeNonTerminalStart($tag)
    {
        $this->writeCompilationEngine("<$tag>");
        $this->numberOfTabs += 1;
    }

    private function writeNonTerminalEnd($tag)
    {
        $this->numberOfTabs -= 1;
        $this->writeCompilationEngine("</$tag>");
    }

    private function lookAheadToken($token)
    {
        return $this->nextToken == $token;
    }

    private function lookAheadTokenType($tokenType)
    {
        return $this->nextTokenType == $tokenType;
    }

    private function isNextStatement()
    {
        return $this->lookAheadToken('let') || $this->lookAheadToken('if') || $this->lookAheadToken('while') || $this->lookAheadToken('do') || $this->lookAheadToken('return');
    }

    private function isNextOperator()
    {
        return $this->lookAheadToken('+') || $this->lookAheadToken('-') || $this->lookAheadToken('*') || $this->lookAheadToken('/') || $this->lookAheadToken('&amp;') || $this->lookAheadToken('|') || $this->lookAheadToken('&lt;') || $this->lookAheadToken('&gt;') || $this->lookAheadToken('=');
    }

    private function isNextUnaryOperator()
    {
        return $this->lookAheadToken('-') || $this->lookAheadToken('~');
    }

    private function isNextKeywordConstant()
    {
        return $this->lookAheadToken('true') || $this->lookAheadToken('false') || $this->lookAheadToken('null') || $this->lookAheadToken('this');
    }

    private function compileClass()
    {
        $this->writeNonTerminalStart('class');
        $this->advance(); // class
        $this->advance(); // className
        $this->advance(); // {
        while ($this->lookAheadToken('static') || $this->lookAheadToken('field')) {
            $this->compileClassVarDec();
        }
        while ($this->lookAheadToken('constructor') || $this->lookAheadToken('function') || $this->lookAheadToken('method')) {
            $this->compileSubroutine();
        }
        $this->advance(); // }
        $this->writeNonTerminalEnd('class');
    }

    private function compileClassVarDec()
    {
        $this->writeNonTerminalStart('classVarDec');
        $this->advance(); // static | field
        $this->advance(); // type
        $this->advance(); // varName
        while ($this->lookAheadToken(',')) {
            $this->advance(); // ,
            $this->advance(); // varName
        }
        $this->advance(); // ;
        $this->writeNonTerminalEnd('classVarDec');
    }

    private function compileSubroutine()
    {
        $this->writeNonTerminalStart('subroutineDec');
        $this->advance(); // constructor | function | method
        $this->advance(); // void | type
        $this->advance(); // subroutineName
        $this->advance(); // (
        $this->compileParameterList();
        $this->advance(); // )
        $this->compileSubroutineBody();
        $this->writeNonTerminalEnd('subroutineDec');
    }

    private function compileParameterList()
    {
        $this->writeNonTerminalStart('parameterList');
        if (!$this->lookAheadToken(')')) {
            $this->advance(); // type
            $this->advance(); // varName
            while ($this->lookAheadToken(',')) {
                $this->advance(); // ,
                $this->advance(); // type
                $this->advance(); // varName
            }
        }
        $this->writeNonTerminalEnd('parameterList');
    }

    private function compileSubroutineBody()
    {
        $this->writeNonTerminalStart('subroutineBody');
        $this->advance(); // {
        while ($this->lookAheadToken('var')) {
            $this->compileVarDec();
        }
        while ($this->isNextStatement()) {
            $this->compileStatements();
        }
        $this->advance(); // }
        $this->writeNonTerminalEnd('subroutineBody');
    }

    private function compileVarDec()
    {
        $this->writeNonTerminalStart('varDec');
        $this->advance(); // var
        $this->advance(); // type
        $this->advance(); // varName
        while ($this->lookAheadToken(',')) {
            $this->advance(); // ,
            $this->advance(); // varName
        }
        $this->advance(); // ;
        $this->writeNonTerminalEnd('varDec');
    }

    private function compileStatements()
    {
        $this->writeNonTerminalStart('statements');
        while ($this->isNextStatement()) {
            if ($this->lookAheadToken('let')) {
                $this->compileLet();
            } elseif ($this->lookAheadToken('if')) {
                $this->compileIf();
            } elseif ($this->lookAheadToken('while')) {
                $this->compileWhile();
            } elseif ($this->lookAheadToken('do')) {
                $this->compileDo();
            } elseif ($this->lookAheadToken('return')) {
                $this->compileReturn();
            }
        }
        $this->writeNonTerminalEnd('statements');
    }

    private function compileLet()
    {
        $this->writeNonTerminalStart('letStatement');
        $this->advance(); // let
        $this->advance(); // varName
        if ($this->lookAheadToken('[')) {
            $this->advance(); // [
            $this->compileExpression();
            $this->advance(); // ]
        }
        $this->advance(); // =
        $this->compileExpression();
        $this->advance(); // ;
        $this->writeNonTerminalEnd('letStatement');
    }

    private function compileIf()
    {
        $this->writeNonTerminalStart('ifStatement');
        $this->advance(); // if
        $this->advance(); // (
        $this->compileExpression();
        $this->advance(); // )
        $this->advance(); // {
        $this->compileStatements();
        while ($this->isNextStatement()) {
            $this->compileStatements();
        }
        $this->advance(); // }
        if ($this->lookAheadToken('else')) {
            $this->advance(); // else
            $this->advance(); // {
            $this->compileStatements();
            while ($this->isNextStatement()) {
                $this->compileStatements();
            }
            $this->advance(); // }
        }
        $this->writeNonTerminalEnd('ifStatement');
    }

    private function compileWhile()
    {
        $this->writeNonTerminalStart('whileStatement');
        $this->advance(); // while
        $this->advance(); // (
        $this->compileExpression();
        $this->advance(); // )
        $this->advance(); // {
        $this->compileStatements();
        while ($this->isNextStatement()) {
            $this->compileStatements();
        }
        $this->advance(); // }
        $this->writeNonTerminalEnd('whileStatement');
    }

    private function compileDo()
    {
        $this->writeNonTerminalStart('doStatement');
        $this->advance(); // do
        $this->advance(); // subroutineName | className | varName
        while ($this->lookAheadToken('.') || $this->lookAheadToken('(')) {
            if ($this->lookAheadToken('.')) {
                $this->advance(); // .
                $this->advance(); // subroutineName
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
            } elseif ($this->lookAheadToken('(')) {
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
            }
        }
        $this->advance(); // ;
        $this->writeNonTerminalEnd('doStatement');
    }

    private function compileReturn()
    {
        $this->writeNonTerminalStart('returnStatement');
        $this->advance(); // return
        if (!$this->lookAheadToken(';')) {
            $this->compileExpression();
        }
        $this->advance(); // ;
        $this->writeNonTerminalEnd('returnStatement');
    }

    private function compileExpression()
    {
        $this->writeNonTerminalStart('expression');
        $this->compileTerm();
        while ($this->isNextOperator()) {
            $this->advance(); // operator
            $this->compileTerm();
        }
        $this->writeNonTerminalEnd('expression');
    }

    private function compileTerm()
    {
        $this->writeNonTerminalStart('term');
        if ($this->lookAheadTokenType('INT_CONST') || $this->lookAheadTokenType('STRING_CONST') || $this->isNextKeywordConstant()) {
            $this->advance(); // intConst | stringConst | keywordConstant
        } elseif ($this->lookAheadTokenType('IDENTIFIER')) {
            $this->advance(); // varName
            if ($this->lookAheadToken('[')) {
                $this->advance(); // [
                $this->compileExpression();
                $this->advance(); // ]
            } elseif ($this->lookAheadToken('.')) {
                $this->advance(); // .
                $this->advance(); // subroutineName
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
            } elseif ($this->lookAheadToken('(')) {
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
            }
        } elseif ($this->isNextUnaryOperator()) {
            $this->advance(); // unaryOp
            $this->compileTerm();
        } elseif ($this->lookAheadToken('(')) {
            $this->advance(); // (
            $this->compileExpression();
            $this->advance(); // )
        }
        $this->writeNonTerminalEnd('term');
    }

    private function compileExpressionList()
    {
        $this->writeNonTerminalStart('expressionList');
        if (!$this->lookAheadToken(')')) {
            $this->compileExpression();
            while ($this->lookAheadToken(',')) {
                $this->advance(); // ,
                $this->compileExpression();
            }
        }
        $this->writeNonTerminalEnd('expressionList');
    }
}

class jackAnalyzer
{
    public function __construct($inputFolderOrFile)
    {
        if (is_dir($inputFolderOrFile)) {
            $files = glob($inputFolderOrFile . '/*.jack');
            foreach ($files as $file) {
                $this->analyze($file);
            }
        } elseif (is_file($inputFolderOrFile)) {
            $this->analyze($inputFolderOrFile);
        }
    }

    public function analyze($inputFile)
    {
        $compilationEngine = new CompilationEngine($inputFile);
    }
}

function main($argv)
{
    if (isset($argv[1])) {
        $inputFolderOrFile = $argv[1];
        $jackAnalyzer = new JackAnalyzer($inputFolderOrFile);
    } else {
        echo "Usage: php JackTokenizer.php <inputFile.jack>\n";
    }
}

main($argv);
