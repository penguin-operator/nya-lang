#+feature dynamic-literals
package nya

import "core:strings"
import "core:fmt"
import "core:os"

main :: proc () {
	args := os.args[1:]
	inputs: [dynamic]string
	opts: map[string]union#no_nil{string,bool} = {
		"out" = proc() -> string {
			path, _ := os.get_working_directory(context.allocator)
			_, output: string = os.split_path(path)
			return output
		}(),
	}
	for arg, i in args {
		if arg[0] == '-' {
			opt := arg[1:]
			val: string
			if strings.contains(opt, "=") {
				kv := strings.split(opt, "=")
				opt, val = kv[0], kv[1]
				if _, has := opts[opt]; !has {
					fmt.eprintfln("\e[1;31merror\e[0m " + "option \e[1m-%s\e[0m does not exist", opt)
					os.exit(1)
				}
				opts[opt] = val
			} else {
				if _, has := opts[opt]; !has {
					fmt.eprintfln("\e[1;31merror\e[0m " + "option \e[1m-%s\e[0m does not exist", opt)
					os.exit(1)
				}
				opts[opt] = true
			}
		} else do append(&inputs, arg)
	}
}
