node ../projects/10/index.js ../projects/10/ArrayTest
echo "node ../projects/10/index.js ../projects/10/ExpressionLessSquare"
node ../projects/10/index.js ../projects/10/Square
echo "node ../projects/10/index.js ../projects/10/ExpressionLessSquare"
node ../projects/10/index.js ../projects/10/ExpressionLessSquare
echo "node ../projects/10/index.js ../projects/10/Square"
echo ""

echo "ArrayTest/Main"
sh TextComparer.sh ../projects/10/ArrayTest/Main.xml ../projects/10/ArrayTest/MainR.xml
echo ""

echo "ArrayTest/MainT"
sh TextComparer.sh ../projects/10/ArrayTest/MainT.xml ../projects/10/ArrayTest/MainFT.xml
echo ""

echo "ExpressionLessSquare/Square"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/Main.xml ../projects/10/ExpressionLessSquare/MainR.xml
echo ""

echo "ExpressionLessSquare/SquareT"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/MainT.xml ../projects/10/ExpressionLessSquare/MainFT.xml
echo ""

echo "ExpressionLessSquare/Square"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/Square.xml ../projects/10/ExpressionLessSquare/SquareR.xml
echo ""

echo "ExpressionLessSquare/SquareT"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/SquareT.xml ../projects/10/ExpressionLessSquare/SquareFT.xml
echo ""

echo "ExpressionLessSquare/SquareGame"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/SquareGame.xml ../projects/10/ExpressionLessSquare/SquareGameR.xml
echo ""

echo "ExpressionLessSquare/SquareGameT"
sh TextComparer.sh ../projects/10/ExpressionLessSquare/SquareGameT.xml ../projects/10/ExpressionLessSquare/SquareGameFT.xml
echo ""

echo "Square/Main"
sh TextComparer.sh ../projects/10/Square/Main.xml ../projects/10/Square/MainR.xml
echo ""

echo "Square/MainT"
sh TextComparer.sh ../projects/10/Square/MainT.xml ../projects/10/Square/MainFT.xml
echo ""

echo "Square/Square"
sh TextComparer.sh ../projects/10/Square/Square.xml ../projects/10/Square/SquareR.xml
echo ""

echo "Square/SquareT"
sh TextComparer.sh ../projects/10/Square/SquareT.xml ../projects/10/Square/SquareFT.xml
echo ""

echo "Square/SquareGame"
sh TextComparer.sh ../projects/10/Square/SquareGame.xml ../projects/10/Square/SquareGameR.xml
echo ""

echo "Square/SquareGameT"
sh TextComparer.sh ../projects/10/Square/SquareGameT.xml ../projects/10/Square/SquareGameFT.xml
echo ""


php ../projects/10/index.php ../projects/10/ArrayTest
echo "php ../projects/10/index.php ../projects/10/ExpressionLessSquare"
php ../projects/10/index.php ../projects/10/Square
echo "php ../projects/10/index.php ../projects/10/ExpressionLessSquare"
php ../projects/10/index.php ../projects/10/ExpressionLessSquare
echo "php ../projects/10/index.php ../projects/10/Square"
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
