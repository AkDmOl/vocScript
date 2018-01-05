#!/bin/bash

system="$(uname -s)" 
case "$system" in
    Linux)   machine=Linux;;
    Darwin*)  machine=Mac;;

esac
API_KEY1="$(cat key1)"
API_KEY2="$(cat key2)"
if [ "$machine"=="Mac" ];
then
    osascript getSelectedText
    textToTranslate=$(pbpaste)
    text="$(echo $textToTranslate | sed -e "s/ /+/g")"
    curl -d "key=$API_KEY1&lang=en-ru&text=$text" https://translate.yandex.net/api/v1.5/tr.json/translate? > firstMean
    cat firstMean | sed 's/.*\[\"\(.*\)\"\].*/\1/' > resultTransl
    
    curl -d "key=$API_KEY2&lang=en-ru&text=$text" https://dictionary.yandex.net/api/v1/dicservice/lookup? > tmp
    cat tmp | perl -pe 's/<mean>.*?<\/mean>/!/g' > cleanTmp
    xmllint --shell cleanTmp <<< 'cat //text/text()' | sed '/^[[:blank:]]*\-/d' | sed '/[[:blank:]]*\//d' > parseRes
    cat parseRes >> resultTransl
    ./showTranslate.sh
    if [[ -s parseRes ]];
    then
	python makeRequestQuizlet.py
	if [[ -s request.sh ]];
	then
		chmod +x request.sh
		./request.sh > log
		rm request.sh
	fi
    fi
fi
