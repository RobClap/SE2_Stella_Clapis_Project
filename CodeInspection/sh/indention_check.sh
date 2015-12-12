cat ConnectorDeployer.java |
 egrep -v '^[ ]{4}+' | #output lines that do not start with "    "+ (4 or multiple of 4 spaces)
 egrep -v "^[a-zA-Z]" | #filter out lines that are not indented at all
 egrep -v "^[ ]*$" | #remove blank lines
 egrep -v "^ \*" | #remove comments section
 egrep -v "/\*" | #remove comments open
 egrep -v "^@" | #remove @
 egrep -v "^}" #remove end of the file

<<output
[1 line]
							//ignore ?
line 518 in registerBeanValidator()
output

cat ConnectorDeployer.java | grep "	" #Check for the "tab" character

<<output
[the same line yelded by the other command]
output
