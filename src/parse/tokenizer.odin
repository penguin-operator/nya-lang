package parse

import "core:slice"
import "core:strings"
import "core:os"
import "core:fmt"

OPERATORS: []string : {
	";",
	":",
	"=",
	",",
	"(",
	")",
	"{",
	"}",
	"[",
	"]",
	".",
	"..",
	"@",
	"<",
	">",
	"!=",
	"==",
	"<=",
	">=",
	"&&",
	"||",
	"//",
	"!",
	"&",
	"|",
	"^",
	"~",
	"-",
	"--",
	"+",
	"++",
	"*",
	"/",
	"%",
	"<<",
	">>",
}

SPECIAL: string : "`~!@#$%^&*()-+=\\/|[{]};:'\",<.>?"

token :: struct {
	value: string,
	line, column: int,
}

tokenize :: proc (file, code: string) -> []token {
	tokens: [dynamic]token
	i, l := 0, 0
	line, column := 1, 1
	ops := OPERATORS
	slice.sort_by(ops[:], proc (a, b: string) -> bool { return len(a) > len(b) })
	for i < len(code) {
		if code[i] == '\n' || code[i] == '\r' || code[i] == '\t' || code[i] == ' ' {
			i += 1
			if code[i-1] == '\n' {
				line += 1
				column = 1
			} else {
				column += 1
			}
			continue
		} else if code[i] == '"' || code[i] == '\'' {
			end := code[i]
			l = 1
			for i < len(code) && code[i+l] != end {
				if code[i+l] == '\n' {
					fmt.eprintfln("\e[1;31merror\e[0m %s:%d:%d " + "newline in string literal", file, line, column)
					os.exit(1)
				}
				l += 1
			}
			if code[i+l] == end do l += 1
		} else if code[i] == '#' {
			l = 0
			for i < len(code) && code[i+l] != '\n' {
				l += 1
			}
			if code[i+l] == '\n' {
				l += 1
				line += 1
				column = 1
			}
		} else if strings.contains_rune(SPECIAL, rune(code[i])) {
			for op in ops {
				if strings.has_prefix(code[i:], op) {
					l = len(op)
					break
				}
			}
			if l == 0 {
				fmt.eprintfln("\e[1;31merror\e[0m %s:%d:%d " + "unexpected character: '%c'", file, line, column)
				os.exit(1)
			}
		} else if strings.contains_rune("0123456789", rune(code[i])) {
			l = 1
			if code[i-1] == '-' {
				i -= 1
				ordered_remove(&tokens, len(tokens)-1)
			}
			if code[i] == '0' {
				if i+l < len(code) && (code[i+l] == 'x' || code[i+l] == 'X') {
					l += 1
					for i+l < len(code) && strings.contains_rune("0123456789abcdefABCDEF", rune(code[i+l])) {
						l += 1
					}
				} else if i+l < len(code) && (code[i+l] == 'b' || code[i+l] == 'B') {
					l += 1
					for i+l < len(code) && strings.contains_rune("01", rune(code[i+l])) {
						l += 1
					}
				} else if i+l < len(code) && strings.contains_rune("01234567", rune(code[i+l])) {
					for i+l < len(code) && strings.contains_rune("01234567", rune(code[i+l])) {
						l += 1
					}
				} else if i+l < len(code) && code[i+l] == '.' {
					if i+l+1 < len(code) && strings.contains_rune("0123456789", rune(code[i+l+1])) {
						l += 1
						for i+l < len(code) && strings.contains_rune("0123456789", rune(code[i+l])) {
							l += 1
						}
					} else {
						fmt.eprintfln("\e[1;31merror\e[0m %s:%d:%d " + "wrong format for float literal", file, line, column)
						os.exit(1)
					}
				}
			} else {
				for i+l < len(code) && strings.contains_rune("0123456789", rune(code[i+l])) {
					l += 1
				}
				if i+l < len(code) && code[i+l] == '.' {
					l += 1
					if i+l < len(code) && strings.contains_rune("0123456789", rune(code[i+l])) {
						for i+l < len(code) && strings.contains_rune("0123456789", rune(code[i+l])) {
							l += 1
						}
					} else {
						fmt.eprintfln("\e[1;31merror\e[0m %s:%d:%d " + "wrong format for float literal", file, line, column)
						os.exit(1)
					}
				}
			}
		} else {
			for i+l < len(code) && !strings.contains_rune(SPECIAL+" \n\r\t", rune(code[i+l])) {
				l += 1
			}
		}
		if t := code[i:i+l]; t != "" {
			append(&tokens, token { t, line, column })
			column += l
		}
		i += l
		l = 0
	}
	return tokens[:]
}
