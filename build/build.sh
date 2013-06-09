BIN=../bin
LIB=../lib
SRC=../src
OUT=../out

java -jar $BIN/asc.jar -strict -import $LIB/playerglobal.abc -swf Main,800,600 $SRC/Main.as
mv $SRC/Main.swf $OUT
