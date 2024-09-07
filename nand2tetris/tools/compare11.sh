php ../projects/11/index.php ../projects/10/ArrayTest
echo "php ../projects/11/index.php ../projects/10/ExpressionLessSquare"
php ../projects/11/index.php ../projects/10/Square
echo "php ../projects/11/index.php ../projects/10/ExpressionLessSquare"
php ../projects/11/index.php ../projects/10/ExpressionLessSquare
echo "php ../projects/11/index.php ../projects/10/Square"
echo ""

echo "ArrayTest/Main"
sh TextComparer.sh ../projects/10/ArrayTest/Main.xml ../projects/10/ArrayTest/Mainphp.xml
echo ""

echo "ArrayTest/MainT"
sh TextComparer.sh ../projects/10/ArrayTest/MainT.xml ../projects/10/ArrayTest/MainphpT.xml
echo ""

echo "ExpressionLessSquare/Square"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/Main.xml ../projects/10/ExpressionLessSquare/Mainphp.xml
echo ""

echo "ExpressionLessSquare/SquareT"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/MainT.xml ../projects/10/ExpressionLessSquare/MainphpT.xml
echo ""

echo "ExpressionLessSquare/Square"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/Square.xml ../projects/10/ExpressionLessSquare/Squarephp.xml
echo ""

echo "ExpressionLessSquare/SquareT"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/SquareT.xml ../projects/10/ExpressionLessSquare/SquarephpT.xml
echo ""

echo "ExpressionLessSquare/SquareGame"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/SquareGame.xml ../projects/10/ExpressionLessSquare/SquareGamephp.xml
echo ""

echo "ExpressionLessSquare/SquareGameT"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/SquareGameT.xml ../projects/10/ExpressionLessSquare/SquareGamephpT.xml
echo ""

echo "Square/Main"
sh TextComparer.sh ../projects/10/Square/Main.xml ../projects/10/Square/Mainphp.xml
echo ""

echo "Square/MainT"
sh TextComparer.sh ../projects/10/Square/MainT.xml ../projects/10/Square/MainphpT.xml
echo ""

echo "Square/Square"
sh TextComparer.sh ../projects/10/Square/Square.xml ../projects/10/Square/Squarephp.xml
echo ""

echo "Square/SquareT"
sh TextComparer.sh ../projects/10/Square/SquareT.xml ../projects/10/Square/SquarephpT.xml
echo ""

echo "Square/SquareGame"
sh TextComparer.sh ../projects/10/Square/SquareGame.xml ../projects/10/Square/SquareGamephp.xml
echo ""

echo "Square/SquareGameT"
sh TextComparer.sh ../projects/10/Square/SquareGameT.xml ../projects/10/Square/SquareGamephpT.xml
echo ""

php ../projects/11/index.php ../projects/11/Average
php ../projects/11/index.php ../projects/11/ComplexArrays
php ../projects/11/index.php ../projects/11/ConvertToBin
php ../projects/11/index.php ../projects/11/Pong
php ../projects/11/index.php ../projects/11/Seven
php ../projects/11/index.php ../projects/11/Square
php ../projects/11/index.php ../projects/11/Tes

sh JackCompiler.sh ../projects/11/Average
sh JackCompiler.sh ../projects/11/ComplexArrays
sh JackCompiler.sh ../projects/11/ConvertToBin
sh JackCompiler.sh ../projects/11/Pong
sh JackCompiler.sh ../projects/11/Seven
sh JackCompiler.sh ../projects/11/Square

echo "Average/Average"
sh TextComparer.sh ../projects/11/Average/Mainphp.vm ../projects/11/Average/Main.vm
echo ""

echo "ComplexArrays/ComplexArrays"
sh TextComparer.sh ../projects/11/ComplexArrays/Mainphp.vm ../projects/11/ComplexArrays/Main.vm
echo ""

echo "ConvertToBin/ConvertToBin"
sh TextComparer.sh ../projects/11/ConvertToBin/Mainphp.vm ../projects/11/ConvertToBin/Main.vm
echo ""

echo "Pong/Pong"
sh TextComparer.sh ../projects/11/Pong/Mainphp.vm ../projects/11/Pong/Main.vm
sh TextComparer.sh ../projects/11/Pong/Batphp.vm ../projects/11/Pong/Bat.vm
sh TextComparer.sh ../projects/11/Pong/Ballphp.vm ../projects/11/Pong/Ball.vm
sh TextComparer.sh ../projects/11/Pong/PongGamephp.vm ../projects/11/Pong/PongGame.vm
echo ""

echo "Seven/Seven"
sh TextComparer.sh ../projects/11/Seven/Mainphp.vm ../projects/11/Seven/Main.vm
echo ""

echo "Square/Square"
sh TextComparer.sh ../projects/11/Square/Mainphp.vm ../projects/11/Square/Main.vm
sh TextComparer.sh ../projects/11/Square/Squarephp.vm ../projects/11/Square/Square.vm
sh TextComparer.sh ../projects/11/Square/SquareGamephp.vm ../projects/11/Square/SquareGame.vm
echo ""


