pub mod token;

use std::{
	env::args,
	process::exit,
};

pub fn main() {
	let mut inputs: Vec<String>;
	let mut output: String = String::from("a.out");

	for arg in args() {
		if arg.starts_with("-out") {
			match arg.split_once(":") {
				Some((_, file)) => output = String::from(file),
				None => {
					println!("usage: nya FILES... -out:FILE");
					exit(1)
				},
			}
		} else {
		}
	}
}
