cat ConnectorDeployer.java | 
egrep -v "^[ ]*//" | #ignore comments
egrep -v "^[ ]*\*" | # ↑
egrep '[^a-zA-Z][a-zA-Z_][^a-zA-Z]' | #find one-letter literals
egrep -v "Exception e" #ignore the "e" for exceptions


