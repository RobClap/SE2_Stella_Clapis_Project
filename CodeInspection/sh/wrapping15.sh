cat -n ConnectorDeployer.java| grep -v ';' | grep -v '{$' | grep -v '}$' | egrep '[^ 0-9]+'
