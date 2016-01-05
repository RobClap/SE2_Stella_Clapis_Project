cat -n ConnectorDeployer.java | #prints with line numbers
egrep -v "^[ ]+[0-9]+	[ ]+//" | #ignore comments
egrep -v "^[ ]+[0-9]+	[ ]+\*" | # ↑
egrep '[^a-zA-Z][a-zA-Z_][a-zA-Z_][^a-zA-Z]' | #find one-letter literals
egrep -v "Exception e" | #ignore the "e" for exceptions 
egrep -v "if"

<<output
'
    53	import com.sun.enterprise.util.i18n.StringManager;
   146	    public <T> T loadMetaData(Class<T> type, DeploymentContext context) {
   233	            Object params[] = new Object[]{moduleName, e};
   510	                                "bean-validation-mapping", e);
   524	                Object params[] = new Object[]{rarName, e};
   565	                            "for detecting bean-validation-mapping", e);
  '
output
