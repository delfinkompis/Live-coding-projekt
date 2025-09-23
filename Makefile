all:
	guild compile riemann.scm -o riemann.go
	guild compile music-synonyms.scm -o music-synonyms.go
	guild compile repl-variabler.scm -o repl-variabler.go
	guild compile my-repl-defuns.scm -o my-repl-defuns.go

