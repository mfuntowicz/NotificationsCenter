#############################################################################
##
## Inject As3 code
##
## Original script by David Hanak fom http://stackoverflow.com/questions/357825/flash-actionscript-cpu-profiler
##
#############################################################################

import os,sre, sys


rePOI = sre.compile(r'''\bpackage\b|\bclass\b|\bfunction\b|\breturn\b|\[ProfilerInfo|["']|/\*|//.*|[{}]''')
reFun = sre.compile(r'\bfunction\b\s*((?:[gs]et\s+)?\w*)\s*\(')
reCls = sre.compile(r'class\s+(\w+)[\s{]')
rePkg = sre.compile(r'package\s+((\w|\.)+)[\s{]')
rePi = sre.compile(r'\[ProfilerInfo\s*\((\w*)=\s*(.)(.*)(?<!\\)\2')
reStr = sre.compile(r'''(["'/]).*?(?<!\\)\1''')
reEnd = sre.compile(r'\n')
reSubFct = sre.compile(r'{.*}')

def addProfilingCalls(body, checkClass = 1, stack = [], retvar = 0):
	pos = 0
	depth = 0
	klass = ""
	packageName = ""
	returnDone = 0
	customInfo = "null"
	
	# Ignore file if there is no class definition
	if checkClass and body.find("public class") == -1 : return body
		
	match = rePOI.search(body, pos)
	while match:
		poi = match.group(0)
		pos = match.start(0)
		endpos = match.end(0)
		# Ignore comment string like // xx
		if poi[0:2] == '//':
			None
		
		# Ignore comment block
		elif poi == '/*':
			endpos = body.find("*/", pos)
		
		# Ignore string content
		elif poi in '''"'/''':
			strm = reStr.match(body, pos)
			if strm and (poi != '/' or sre.search('[=(,]\s*$', body[:pos])):
				endpos = strm.end(0)
		
		# Match package name
		elif poi == 'package':
			mp = rePkg.match(body, pos);
			if mp != None :
				packageName = mp.group(1)
		
		# Match class name
		elif poi == 'class':
			m = reCls.match(body, pos);
			if m != None :
				klass = m.group(1)
			customInfo = "null"
		
		# Match ProfileInfo meta
		elif poi == '[ProfilerInfo':
			mPi = rePi.match(body, pos)
			if mPi != None and  mPi.group(1) == "customInfo":
				customInfo = mPi.group(3)
		
		# Match and insert start call log
		elif poi == 'function':
			fname = reFun.match(body, pos)
			if fname != None :
				if fname.group(1):
					fname = packageName + '::' + klass + '.' + fname.group(1)
				else:
					lastf = stack[-1]
					lastf['anon'] += 1
					fname = lastf['name'] + '.anon' + str(lastf['anon'])
				stack.append({'name':fname, 'depth':depth, 'anon':0, 'customInfo':customInfo})
				customInfo = "null"
				brace = body.find('{', pos) + 1
				line = "\nAs3PerformancesAnalyzer.instance.startLog('" + fname + \
					 "');"
				body = body[:brace] + line + body[brace:]
				depth += 1
				endpos = brace + len(line)

		elif poi == '{':
			depth += 1
		
		# Match return and add end call log
		elif poi == 'return':
			if len(stack):
				lastf = stack[-1]
			else:
				lastf = {'name':'unknow', 'depth':depth, 'anon':0, 'customInfo':'null'}
			semicolon = body.find(';', pos) + 1
			
			endLine = body.find('\n', pos) ;
			
			# If semicolon is missing after return statement
			returnEnd = body.find("}", pos)
			if (semicolon > returnEnd and returnEnd != -1 and (semicolon > endLine or endLine == -1)) or semicolon == 0:
				semicolon = returnEnd
			
			if sre.match('return\s*;', body[pos:]):
				line = "{ As3PerformancesAnalyzer.instance.endLog('" + lastf['name'] + \
					 "', " + lastf['customInfo'] + "); return; }"
			else:
				retvar += 1
				returnVal = body[pos+6:semicolon]
				if returnVal.find(" function ") != -1 or returnVal.find("{") != -1:
					while returnVal.count("{") != returnVal.count("}"):
						semicolon += 1
						returnVal = body[pos+6:semicolon]
					returnVal = addProfilingCalls(returnVal, 0, stack, retvar)
				
				line = "{ var __ret" + str(retvar) + "__:* =" + returnVal + \
					 "\nAs3PerformancesAnalyzer.instance.endLog('" + lastf['name'] + \
					 "', " + lastf['customInfo'] + "); return __ret" + str(retvar) + "__; }"
			
			body = body[:pos] + line + body[semicolon:]
			endpos = pos + len(line)

		elif poi == '}':
			depth -= 1
			if len(stack) > 0 and stack[-1]['depth'] == depth:
				lastf = stack.pop()
				line = "\nAs3PerformancesAnalyzer.instance.endLog('" + lastf['name'] + \
					"', " + lastf['customInfo'] + ");\n"
				body = body[:pos] + line + body[pos:]
				endpos += len(line)
		pos = endpos
		match = rePOI.search(body, pos)
	return body

asFileCount = 0
for d in os.walk("."):
	if d[0].find("svn") != -1 or d[0].find('mod-') != -1: continue
	sys.stderr.write('Folder ' + d[0] + '\n')
	for file in d[2]:
		if file.find('.as') != -1 and file.find("As3PerformancesAnalyzer.as") == -1:
			sys.stdout.write('File ' + file + '\n')
			asFileCount += 1
			inf = open(d[0] + "\\" + file, 'rU')
			content = addProfilingCalls(inf.read())
			inf.close()
			#sys.stdout.write(content)
			outf = open(d[0] + "\\" + file, "w")
			outf.write(content)
			outf.close()
sys.stderr.write('Nombre de fichier injectes : ' + str(asFileCount))