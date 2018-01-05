import requests


def post_set():
	request = open("request.sh", "w")
	quiz = open("quizlet", "r")
	request.write('''curl -H "Authorization: Bearer MY_ACCESS_CODE" -i -X POST -F "whitespace=1"  ''')
	for line in quiz:
		term, defen = line.split()
		request.write('''-F "terms[]=''' + term + '''" ''')
		request.write('''-F "definitions[]=''' + defen + '''" ''')
	request.write('''-F "title=Mine" -F "lang_terms=en" -F "lang_definitions=ru" https://api.quizlet.com/2.0/sets ''')
	print(request)

transl = open("parseRes", "r")
quizlet = open("quizlet", "r+")
lenSet = sum(1 for line in quizlet)
quizlet.close()
quizlet = open("quizlet", "r+")

term = transl.readline()[:-1]

if not (term in quizlet.read()):
	pair = term + " " + transl.readline()
	quizlet.write(pair)
	quizlet.close()
	if lenSet + 1 == 20:
		post_set()

