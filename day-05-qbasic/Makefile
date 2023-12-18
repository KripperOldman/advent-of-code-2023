.PHONY: run
run: sol2
	./$^
	cat output

%: %.bas
	qb64/qb64 -c -o ../$@  $^
