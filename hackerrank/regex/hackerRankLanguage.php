<?php
$n = intval(trim(fgets(STDIN)));
$listLine = [];
for ($i = 0; $i < $n; $i++) {
    $listLine[] = trim(fgets(STDIN));
}

foreach ($listLine as $line) {
    if (preg_match('/^[1-9]\d{4}\s(C|CPP|JAVA|PYTHON|PERL|PHP|RUBY|CSHARP|HASKELL|CLOJURE|BASH|SCALA|ERLANG|CLISP|LUA|BRAINFUCK|JAVASCRIPT|GO|D|OCAML|R|PASCAL|SBCL|DART|GROOVY|OBJECTIVEC)$/', $line)) {
        echo 'VALID' . PHP_EOL;
    } else {
        echo 'INVALID' . PHP_EOL;
    }
}
