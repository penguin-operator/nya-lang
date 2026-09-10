package parse

import "core:os"
import "core:fmt"
import "ast"

parse :: proc (path: string) -> (result: ast.module) {
	code: string
	if path == "-" {
		buf := make([dynamic]u8, 4)
		i := 0
		for {
			n, _ := os.read(os.stdin, buf[i:])
			resize(&buf, len(buf)+n)
			if n == 0 do break
			i += n
		}
		code = string(buf[:i])
	} else {
		file, err := os.open(path, {.Read})
		if err != nil {
			fmt.eprintfln("\e[1;31merror\e[0m " + "failed to open file %s (%s)", path, err)
			os.exit(1)
		}
		defer os.close(file)
		stat: os.File_Info
		stat, err = os.fstat(file, context.allocator)
		if err != nil {
			fmt.eprintfln("\e[1;31merror\e[0m " + "failed to get file info for %s (%s)", path, err)
			os.exit(1)
		}
		buf := make([]u8, stat.size)
		_, err = os.read(file, buf)
		if err != nil {
			fmt.eprintfln("\e[1;31merror\e[0m " + "failed to read file %s (%s)", path, err)
			os.exit(1)
		}
		code = string(buf)
	}
	tokens := tokenize(path, code)
	fmt.println(tokens)
	return
}
