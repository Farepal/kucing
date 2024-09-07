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
        $spaceBetweenSymbols = preg_replace('/(".*?")(*SKIP)(*FAIL)|(\{|\}|\(|\)|\[|\]|\.|\,|\;|\+|\-|\*|\/|\&|\||\<|\>|\=|\~)/', ' $2 ', $cleanedAsteriskComments);
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
    private $symbolTable;
    private $VMWriter;
    private $expressionListCount = 0;

    public function __construct($inputFile, SymbolTable $symbolTable, VMWriter $VMWriter)
    {
        $this->tokenizer = new JackTokenizer($inputFile);
        $this->symbolTable = $symbolTable;
        $this->VMWriter = $VMWriter;

        $this->outputFileXML = str_replace('.jack', 'php.xml', $inputFile);
        file_put_contents($this->outputFileXML, '');

        $this->outputFileTXML = str_replace('.jack', 'phpT.xml', $inputFile);
        file_put_contents($this->outputFileTXML, '');

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

        $this->symbolTable->className = $this->nextToken;
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

        $kind = strtoupper($this->nextToken);
        $this->advance(); // static | field

        $type = $this->nextToken;
        $this->advance(); // type

        $name = $this->nextToken;
        $this->advance(); // varName
        $this->symbolTable->define($name, $type, $kind);

        while ($this->lookAheadToken(',')) {
            $this->advance(); // ,

            $name = $this->nextToken;
            $this->advance(); // varName
            $this->symbolTable->define($name, $type, $kind);
        }
        $this->advance(); // ;
        $this->writeNonTerminalEnd('classVarDec');
    }

    private function compileSubroutine()
    {
        $this->writeNonTerminalStart('subroutineDec');

        $this->symbolTable->reset();
        if ($this->lookAheadToken('method')) {
            $this->symbolTable->define('this', $this->symbolTable->className, 'ARG');
        }

        $this->symbolTable->subroutineType = $this->nextToken;
        $this->advance(); // constructor | function | method

        $this->advance(); // void | type

        $this->symbolTable->subroutineName = $this->nextToken;
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
            $kind = 'ARG';

            $type = $this->nextToken;
            $this->advance(); // type

            $name = $this->nextToken;
            $this->advance(); // varName
            $this->symbolTable->define($name, $type, $kind);

            while ($this->lookAheadToken(',')) {
                $this->advance(); // ,

                $type = $this->nextToken;
                $this->advance(); // type

                $name = $this->nextToken;
                $this->advance(); // varName
                $this->symbolTable->define($name, $type, $kind);
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
        $this->VMWriter->writeFunction($this->symbolTable->className . '.' . $this->symbolTable->subroutineName, $this->symbolTable->varCount('VAR'));
        if ($this->symbolTable->subroutineType == 'constructor') {
            $this->VMWriter->writePush('constant', $this->symbolTable->varCount('FIELD'));
            $this->VMWriter->writeCall('Memory.alloc', 1);
            $this->VMWriter->writePop('pointer', 0);
        } elseif ($this->symbolTable->subroutineType == 'method') {
            $this->VMWriter->writePush('argument', 0);
            $this->VMWriter->writePop('pointer', 0);
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

        $kind = 'VAR';
        $this->advance(); // var

        $type = $this->nextToken;
        $this->advance(); // type

        $name = $this->nextToken;
        $this->advance(); // varName
        $this->symbolTable->define($name, $type, $kind);

        while ($this->lookAheadToken(',')) {
            $this->advance(); // ,

            $name = $this->nextToken;
            $this->advance(); // varName
            $this->symbolTable->define($name, $type, $kind);
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

        $isAccessArray = false;
        $popVarName = $this->nextToken;
        $this->advance(); // varName
        if ($this->lookAheadToken('[')) {
            $this->advance(); // [
            $this->compileExpression();
            // $this->VMWriter->writePush('local', $this->symbolTable->indexOf($popVarName));
            $this->autoPush($popVarName);
            $this->VMWriter->writeArithmetic('add');
            $this->advance(); // ]
            $isAccessArray = true;
        }
        $this->advance(); // =
        $this->compileExpression();


        if ($isAccessArray) {
            $this->VMWriter->writePop('temp', 0);
            $this->VMWriter->writePop('pointer', 1);
            $this->VMWriter->writePush('temp', 0);
            $this->VMWriter->writePop('that', 0);
        } else {
            $this->autoPop($popVarName);
        }
        $this->advance(); // ;
        $this->writeNonTerminalEnd('letStatement');
    }

    private function compileIf()
    {
        $this->writeNonTerminalStart('ifStatement');
        $ifIndex = $this->VMWriter->ifIndex;
        $this->VMWriter->ifIndex++;
        $this->advance(); // if
        $this->advance(); // (
        $this->compileExpression();
        $this->advance(); // )
        $this->VMWriter->writeIf('IF_TRUE' . $ifIndex);
        $this->VMWriter->writeGoto('IF_FALSE' . $ifIndex);
        $this->VMWriter->writeLabel('IF_TRUE' . $ifIndex);
        $this->advance(); // {
        $this->compileStatements();
        while ($this->isNextStatement()) {
            $this->compileStatements();
        }
        $this->advance(); // }
        $isElseExist = $this->lookAheadToken('else');
        if ($isElseExist) {
            $this->VMWriter->writeGoto('IF_END' . $ifIndex);
        }
        $this->VMWriter->writeLabel('IF_FALSE' . $ifIndex);
        if ($this->lookAheadToken('else')) {
            $this->advance(); // else
            $this->advance(); // {
            $this->compileStatements();
            while ($this->isNextStatement()) {
                $this->compileStatements();
            }
            $this->advance(); // }
        }
        if ($isElseExist) {
            $this->VMWriter->writeLabel('IF_END' . $ifIndex);
        }
        $this->writeNonTerminalEnd('ifStatement');
    }

    private function compileWhile()
    {
        $this->writeNonTerminalStart('whileStatement');
        $whileIndex = $this->VMWriter->whileIndex;
        echo $whileIndex;
        $this->VMWriter->whileIndex++;
        $this->advance(); // while
        $this->advance(); // (
        $this->VMWriter->writeLabel('WHILE_EXP' . $whileIndex);
        $this->compileExpression();
        $this->VMWriter->writeArithmetic('not');
        $this->advance(); // )
        $this->VMWriter->writeIf('WHILE_END' . $whileIndex);
        $this->advance(); // {
        $this->compileStatements();
        while ($this->isNextStatement()) {
            $this->compileStatements();
        }
        $this->VMWriter->writeGoto('WHILE_EXP' . $whileIndex);
        $this->advance(); // }
        $this->VMWriter->writeLabel('WHILE_END' . $whileIndex);
        $this->writeNonTerminalEnd('whileStatement');
    }

    private function compileDo()
    {
        $this->writeNonTerminalStart('doStatement');
        $this->advance(); // do

        $functionName = $this->nextToken;
        $this->advance(); // subroutineName | className | varName
        $countName = 1;
        $isOwnMethod = false;
        while ($this->lookAheadToken('.') || $this->lookAheadToken('(')) {
            if ($this->lookAheadToken('.')) {
                $this->advance(); // .

                if ($this->symbolTable->kindOf($functionName) != 'NONE') {
                    // $this->VMWriter->writePush('local', $this->symbolTable->indexOf($functionName));
                    $this->autoPush($functionName);
                    $functionName = $this->symbolTable->typeOf($functionName) . '.' . $this->nextToken;
                } else {
                    $functionName .= "." . $this->nextToken;
                }
                $this->advance(); // subroutineName
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
                $this->VMWriter->writeCall($functionName, $this->expressionListCount);
                $this->VMWriter->writePop('temp', 0);
                $this->expressionListCount = 0;
            } elseif ($this->lookAheadToken('(')) {
                if ($countName == 1) {
                    $isOwnMethod = true;
                }
                if ($isOwnMethod) {
                    $this->VMWriter->writePush('pointer', 0);
                }
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
                $this->VMWriter->writeCall($this->symbolTable->className . '.' . $functionName, $this->expressionListCount + 1);
                $this->VMWriter->writePop('temp', 0);
                $this->expressionListCount = 0;
            }
            $countName++;
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
        } else {
            $this->VMWriter->writePush('constant', 0);
        }
        $this->VMWriter->writeReturn();
        $this->VMWriter->close();
        $this->VMWriter->whileIndex = 0;
        $this->VMWriter->ifIndex = 0;
        $this->advance(); // ;
        $this->writeNonTerminalEnd('returnStatement');
    }

    private function compileExpression()
    {
        $this->writeNonTerminalStart('expression');
        $this->compileTerm();
        while ($this->isNextOperator()) {
            $operator = $this->nextToken;
            $this->advance(); // operator
            $this->compileTerm();

            if ($operator == '+') {
                $this->VMWriter->writeArithmetic('add');
            } elseif ($operator == '-') {
                $this->VMWriter->writeArithmetic('sub');
            } elseif ($operator == '*') {
                $this->VMWriter->writeCall('Math.multiply', 2);
            } elseif ($operator == '/') {
                $this->VMWriter->writeCall('Math.divide', 2);
            } elseif ($operator == '&amp;') {
                $this->VMWriter->writeArithmetic('and');
            } elseif ($operator == '|') {
                $this->VMWriter->writeArithmetic('or');
            } elseif ($operator == '&lt;') {
                $this->VMWriter->writeArithmetic('lt');
            } elseif ($operator == '&gt;') {
                $this->VMWriter->writeArithmetic('gt');
            } elseif ($operator == '=') {
                $this->VMWriter->writeArithmetic('eq');
            }
        }
        $this->writeNonTerminalEnd('expression');
    }

    private function compileTerm()
    {
        $this->writeNonTerminalStart('term');
        if ($this->lookAheadTokenType('INT_CONST')) {
            $this->VMWriter->writePush('constant', $this->nextToken);
            $this->advance(); // intConst
        } elseif ($this->lookAheadTokenType('STRING_CONST')) {
            $stringConst = $this->nextToken;

            $this->VMWriter->writePush('constant', strlen($stringConst));
            $this->VMWriter->writeCall('String.new', 1);
            for ($i = 0; $i < strlen($stringConst); $i++) {
                $this->VMWriter->writePush('constant', ord($stringConst[$i]));
                $this->VMWriter->writeCall('String.appendChar', 2);
            }
            $this->advance(); // stringConst
        } elseif ($this->isNextKeywordConstant()) {
            if ($this->lookAheadToken('true')) {
                $this->VMWriter->writePush('constant', 0);
                $this->VMWriter->writeArithmetic('not');
            } elseif ($this->lookAheadToken('false') || $this->lookAheadToken('null')) {
                $this->VMWriter->writePush('constant', 0);
            } elseif ($this->lookAheadToken('this')) {
                $this->VMWriter->writePush('pointer', 0);
            }
            $this->advance(); // keywordConstant
        } elseif ($this->lookAheadTokenType('IDENTIFIER')) {
            $pushVarName = $this->nextToken;
            $this->advance(); // varName
            if ($this->lookAheadToken('[')) {
                $this->advance(); // [
                $this->compileExpression();
                // $this->VMWriter->writePush('local', $this->symbolTable->indexOf($pushVarName));
                $this->autoPush($pushVarName);
                $this->VMWriter->writeArithmetic('add');
                $this->VMWriter->writePop('pointer', 1);
                $this->VMWriter->writePush('that', 0);
                $this->advance(); // ]
            } elseif ($this->lookAheadToken('.')) {
                $this->advance(); // .
                if ($this->symbolTable->kindOf($pushVarName) != 'NONE') {
                    $functionName = $this->symbolTable->typeOf($pushVarName) . '.' . $this->nextToken;
                    // $this->VMWriter->writePush('local', $this->symbolTable->indexOf($pushVarName));
                    $this->autoPush($pushVarName);
                } else {
                    $functionName = $pushVarName . '.' . $this->nextToken;
                }
                $this->advance(); // subroutineName
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
                $this->VMWriter->writeCall($functionName, $this->expressionListCount);
                $this->expressionListCount = 0;
            } elseif ($this->lookAheadToken('(')) {
                $this->advance(); // (
                $this->compileExpressionList();
                $this->advance(); // )
                $this->VMWriter->writeCall($this->symbolTable->className . '.' . $pushVarName, $this->expressionListCount + 1);
                $this->expressionListCount = 0;
            } else {
                $this->autoPush($pushVarName);
            }
        } elseif ($this->isNextUnaryOperator()) {
            $unaryOperator = $this->nextToken;
            $this->advance(); // unaryOp
            $this->compileTerm();
            if ($unaryOperator == '-') {
                $this->VMWriter->writeArithmetic('neg');
            } elseif ($unaryOperator == '~') {
                $this->VMWriter->writeArithmetic('not');
            }
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
            $this->expressionListCount++;
            $this->compileExpression();
            while ($this->lookAheadToken(',')) {
                $this->advance(); // ,
                $this->expressionListCount++;
                $this->compileExpression();
            }
        }
        $this->writeNonTerminalEnd('expressionList');
    }

    private function autoPush($varName)
    {
        if ($this->symbolTable->kindOf($varName) == 'VAR') {
            $this->VMWriter->writePush('local', $this->symbolTable->indexOf($varName));
        } elseif ($this->symbolTable->kindOf($varName) == 'ARG') {
            $this->VMWriter->writePush('argument', $this->symbolTable->indexOf($varName));
        } elseif ($this->symbolTable->kindOf($varName) == 'FIELD') {
            $this->VMWriter->writePush('this', $this->symbolTable->indexOf($varName));
        } elseif ($this->symbolTable->kindOf($varName) == 'STATIC') {
            $this->VMWriter->writePush('static', $this->symbolTable->indexOf($varName));
        }
    }

    private function autoPop($varName)
    {
        if ($this->symbolTable->kindOf($varName) == 'VAR') {
            $this->VMWriter->writePop('local', $this->symbolTable->indexOf($varName));
        } elseif ($this->symbolTable->kindOf($varName) == 'ARG') {
            $this->VMWriter->writePop('argument', $this->symbolTable->indexOf($varName));
        } elseif ($this->symbolTable->kindOf($varName) == 'FIELD') {
            $this->VMWriter->writePop('this', $this->symbolTable->indexOf($varName));
        } elseif ($this->symbolTable->kindOf($varName) == 'STATIC') {
            $this->VMWriter->writePop('static', $this->symbolTable->indexOf($varName));
        }
    }
}

class SymbolTable
{
    private $classScope = [];
    private $subroutineScope = [];
    private $staticIndex = 0, $fieldIndex = 0, $argIndex = 0, $varIndex = 0;

    public $className = '';
    public $subroutineName = '';
    public $subroutineType = '';

    public function __construct()
    {
        $this->classScope = [];
        $this->subroutineScope = [];
    }

    public function reset()
    {
        $this->subroutineScope = [];
        $this->argIndex = 0;
        $this->varIndex = 0;
    }

    public function define($name, $type, $kind)
    {
        if ($kind == 'STATIC') {
            $this->classScope[$name] = ['type' => $type, 'kind' => $kind, 'index' => $this->staticIndex];
            $this->staticIndex++;
        } elseif ($kind == 'FIELD') {
            $this->classScope[$name] = ['type' => $type, 'kind' => $kind, 'index' => $this->fieldIndex];
            $this->fieldIndex++;
        } elseif ($kind == 'ARG') {
            $this->subroutineScope[$name] = ['type' => $type, 'kind' => $kind, 'index' => $this->argIndex];
            $this->argIndex++;
        } elseif ($kind == 'VAR') {
            $this->subroutineScope[$name] = ['type' => $type, 'kind' => $kind, 'index' => $this->varIndex];
            $this->varIndex++;
        }
    }

    public function varCount($kind)
    {
        switch ($kind) {
            case 'STATIC':
                return $this->staticIndex;
            case 'FIELD':
                return $this->fieldIndex;
            case 'ARG':
                return $this->argIndex;
            case 'VAR':
                return $this->varIndex;
            default:
                return 0;
        }
    }

    public function kindOf($name)
    {
        if (array_key_exists($name, $this->subroutineScope)) {
            return $this->subroutineScope[$name]['kind'];
        } elseif (array_key_exists($name, $this->classScope)) {
            return $this->classScope[$name]['kind'];
        } else {
            return 'NONE';
        }
    }

    public function typeOf($name)
    {
        if (array_key_exists($name, $this->subroutineScope)) {
            return $this->subroutineScope[$name]['type'];
        } elseif (array_key_exists($name, $this->classScope)) {
            return $this->classScope[$name]['type'];
        }
    }

    public function indexOf($name)
    {
        if (array_key_exists($name, $this->subroutineScope)) {
            return $this->subroutineScope[$name]['index'];
        } elseif (array_key_exists($name, $this->classScope)) {
            return $this->classScope[$name]['index'];
        }
    }
}

class VMWriter
{
    private $outputFile;
    private $output = '';
    public $ifIndex = 0, $whileIndex = 0;

    public function __construct($outputFile)
    {
        $this->outputFile = $outputFile;
    }

    public function writePush($segment, $index)
    {
        $this->output .= "push $segment $index\n";
    }

    public function writePop($segment, $index)
    {
        $this->output .= "pop $segment $index\n";
    }

    public function writeArithmetic($command)
    {
        $this->output .= "$command\n";
    }

    public function writeLabel($label)
    {
        $this->output .= "label $label\n";
    }

    public function writeGoto($label)
    {
        $this->output .= "goto $label\n";
    }

    public function writeIf($label)
    {
        $this->output .= "if-goto $label" . "\n";
    }

    public function writeCall($name, $nArgs)
    {
        $this->output .= "call $name $nArgs\n";
    }

    public function writeFunction($name, $nLocals)
    {
        $this->output .= "function $name $nLocals\n";
    }

    public function writeReturn()
    {
        $this->output .= "return\n";
    }

    public function close()
    {
        file_put_contents($this->outputFile, $this->output);
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
        $symbolTable = new SymbolTable();
        $VMWriter = new VMWriter(str_replace('.jack', 'php.vm', $inputFile));
        $compilationEngine = new CompilationEngine($inputFile, $symbolTable, $VMWriter);
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
