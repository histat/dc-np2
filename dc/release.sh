#!/bin/sh

#-----------------------------------------------------------------
CMDNAME=`basename $0`
BASE=`pwd`
VER=$(date '+0.%y.%m.%d')
#-----------------------------------------------------------------
BINDIR="np2-$VER-dc-plainfiles"
SOURCEDIR="np2-$VER-dc-source"



make_bin() {

	if [ ! -d $BINDIR ];then
		mkdir -p disttmp/$BINDIR
	fi 
	
	cp README disttmp/$BINDIR/
	cp IP.BIN disttmp/$BINDIR/
	cp NP2.BIN disttmp/$BINDIR/
	cd $BASE/disttmp/
	zip -r $BINDIR.zip $BINDIR
	cd $BASE
}


make_src() {

	if [ ! -d $SOURCEDIR ];then
		mkdir -p disttmp/$SOURCEDIR
	fi 

	mkdir disttmp/$SOURCEDIR/dc

	cp *.cpp *.h *.res *.str Makefile disttmp/$SOURCEDIR/dc/
	cp -r common disttmp/$SOURCEDIR/dc/
	cp -r fdd disttmp/$SOURCEDIR/dc/
	cp -r menu disttmp/$SOURCEDIR/dc/
	cp -r sh disttmp/$SOURCEDIR/dc/
	cp ../*.c ../*.h ../*.tbl disttmp/$SOURCEDIR/
	cp -r ../bios disttmp/$SOURCEDIR/
	cp -r ../cbus disttmp/$SOURCEDIR/
	cp -r ../codecnv disttmp/$SOURCEDIR/
	cp -r ../common disttmp/$SOURCEDIR/
	cp -r ../fdd disttmp/$SOURCEDIR/
	cp -r ../generic disttmp/$SOURCEDIR/
	cp -r ../font disttmp/$SOURCEDIR/
	cp -r ../i286hdc disttmp/$SOURCEDIR/
	cp -r ../io disttmp/$SOURCEDIR/
	cp -r ../lio disttmp/$SOURCEDIR/
	cp -r ../mem disttmp/$SOURCEDIR/
	cp -r ../sound disttmp/$SOURCEDIR/
	cp -r ../vram disttmp/$SOURCEDIR/
	cd $BASE/disttmp/
	tar jcvf $SOURCEDIR.tar.bz2 $SOURCEDIR
	cd $BASE
}


case $1 in
    all)
    make_src
    make_bin
    ;;
    src)
    make_src
    ;;
    bin)
    make_bin
    ;;
    *)
    echo "USAGE: $CMDNAME (all|src|bin)" 1>&2
    ;;
esac
