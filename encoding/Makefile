all: toCNF tour-triangle tour-encode decode

toCNF: toCNF.c
	gcc toCNF.c -O2 -o toCNF

tour-triangle: tour-triangle.c
	gcc tour-triangle.c -O2 -o tour-triangle

tour-encode: tour-encode.c
	gcc tour-encode.c -O2 -o tour-encode

decode: decode.c
	gcc decode.c -O2 -o decode

clean:
	rm toCNF tour-triangle tour-encode decode
