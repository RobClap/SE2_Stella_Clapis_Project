#sed -e "s:\(.*\)\(abstract|and|as|assert|but|check|else|exactly|enum|fact|for|fun|module|iff|implies|Int|let|in|open|or|pred|run|sum|extends\)\(.*\):\1{\\color{blue}\2}\3:g"
cat TAXInseconds.als | 
sed -r \
	-e 's:	:\\-\\qquad :g' \
	-e 's:\}:\\\}:g' \
	-e 's:\{:\\\{:g' \
	-e '/^\//! s:\s(abstract|and|as|assert|but|check|else|exactly|enum|fact|for|fun|module|iff|implies|Int|let|in|open|or|pred|run|sum|extends|univ|iden|one|lone|all|some|no|none|disj|not|set|sig)\s: {\\color{blue}\1} :g' \
	-e 's:\^:\\string\^:g' \
	-e 's:(//.*):{\\color{green}\1}:g' \
	-e 's:(/\*.*):{\\color{green}\1:g' \
	-e 's:(.*\*/):\1}:g' \
	-e 's:^(abstract|and|as|assert|but|check|else|exactly|enum|fact|for|fun|module|iff|implies|Int|let|in|open|or|pred|run|sum|extends|univ|iden|one|lone|all|some|no|none|disj|not|set|sig)\s:{\\color{blue}\1} :g' \
	-e 's/(.*)/\1\\\\/' |
cat -n
