cat -n ConnectorDeployer.java | 
egrep '^.{88}'| tee longerthan80 | egrep '^.{128}' > longerthan120

echo There are $(wc -l longerthan80 | cut -d" " -f 1) lines longer than 80 chars and $(wc -l longerthan120| cut -d" " -f 1) lines longer than 120 chars
