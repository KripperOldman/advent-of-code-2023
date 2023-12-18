import os

const colors = {
	'HEADER':    '\033[95m'
	'OKBLUE':    '\033[94m'
	'OKGREEN':   '\033[92m'
	'WARNING':   '\033[93m'
	'FAIL':      '\033[91m'
	'ENDC':      '\033[0m'
	'BOLD':      '\033[1m'
	'UNDERLINE': '\033[4m'
}

fn main() {
	mut sol := 0
	for lines := os.get_lines(); lines != []; lines = os.get_lines() {
		vert := get_vertical_reflection(lines)
		hor := 100 * get_horizontal_reflection(lines)
		sol += vert + hor

		if vert == 0 && hor == 0 {
			// println('No Reflection Found.')
			for line in lines {
				eprint(colors['WARNING'])
				eprint(line)
				eprintln(colors['ENDC'])
			}
		}
		eprintln('')
	}

	println(sol)
}

fn get_horizontal_reflection(lines []string) int {
// 	eprintln('Getting Horizontal Reflections')
	mut prev_lines := []string{}
	mut reflection_start := -1
	mut reflection_size := 0
	mut line_index := 0
	for line_index < lines.len {
		mut next_index := -1
		line := lines[line_index]
		reflection_index := reflection_start - reflection_size

// 		eprintln(line)
// 		eprintln('line_index ${line_index}')
// 		eprintln('reflection_start ${reflection_start}')
// 		eprintln('reflection_index ${reflection_index}')
// 		eprintln('reflection_size  ${reflection_size}')
// 		eprintln(prev_lines)
// 		eprintln('')

		if prev_lines.len > 0 && line == prev_lines[reflection_index] {
			reflection_size++

			if reflection_size == reflection_start + 1 {
				break
			}
			next_index = line_index + 1
		} else {
			reflection_size = 0
			reflection_start++
			next_index = reflection_start + 1
		}

		if line_index >= prev_lines.len {
			prev_lines << line
		}

		line_index = next_index
	}

	if reflection_size > 0 {
		// println('Horizontal Reflection Found between ${reflection_start + 1} and ${reflection_start + 2}')
		for i, line in lines {
			if i <= reflection_start {
				eprint(colors['OKBLUE'])
			} else {
				eprint(colors['OKGREEN'])
			}
			eprint(line)
			eprintln(colors['ENDC'])
		}
		return reflection_start + 1
	} else {
		return 0
	}
}

fn get_vertical_reflection(lines []string) int {
	eprintln('Getting Vertical Reflections')
	mut prev_lines := []string{}
	mut reflection_start := -1
	mut reflection_size := 0
	mut col_index := 0
	for col_index < lines[0].len {
		mut next_index := -1
		line := get_vertical_string(lines, col_index)
		reflection_index := reflection_start - reflection_size

		eprintln(line)
		eprintln('col_index ${col_index}')
		eprintln('reflection_start ${reflection_start}')
		eprintln('reflection_index ${reflection_index}')
		eprintln('reflection_size  ${reflection_size}')
		eprintln(prev_lines)
		eprintln('')

		if prev_lines.len > 0 && line == prev_lines[reflection_index] {
			eprintln("${line} matches ${prev_lines[reflection_index]}")
			reflection_size++

			if reflection_size == reflection_start + 1 {
				break
			}
			next_index = col_index + 1
		} else {
			if prev_lines.len > 0 {
				eprintln("${line} doesn't match ${prev_lines[reflection_index]}")
			}
			reflection_size = 0
			reflection_start++
			next_index = reflection_start + 1
		}

		if col_index >= prev_lines.len {
			prev_lines << line
		}

		col_index = next_index
	}

	if reflection_size > 0 {
		// println('Vertical Reflection between ${reflection_start + 1} and ${reflection_start + 2}')
		for line in lines {
			for i, c in line {
				if i <= reflection_start {
					eprint(colors['OKBLUE'])
				} else {
					eprint(colors['OKGREEN'])
				}
				eprint(c.ascii_str())
			}
			eprintln(colors['ENDC'])
		}
		return reflection_start + 1
	} else {
		return 0
	}
}

// fn get_vertical_reflection(lines []string) int {
// 	// eprintln("Getting Vertical Reflections");
// 	mut prev_lines := []string{}
// 	mut reflection_start := -1
// 	mut reflection_size := 0
// 	for i in 0 .. (lines[0].len) {
// 		line := get_vertical_string(lines, i)
// 
// 		reflection_index := reflection_start - reflection_size
// 
// 		if prev_lines.len > 0 {
// 			// eprintln(line)
// 			// eprintln('reflection_start ${reflection_start}')
// 			// eprintln('reflection_index ${reflection_index}')
// 			// eprintln('reflection_size  ${reflection_size}')
// 			// eprintln('')
// 		}
// 
// 		if prev_lines.len > 0 && line == prev_lines[reflection_index] {
// 			reflection_size++
// 
// 			if reflection_size == reflection_start + 1 {
// 				break
// 			}
// 		} else {
// 			reflection_size = 0
// 			reflection_start = i
// 		}
// 
// 		prev_lines << line
// 	}
// 
// 	if reflection_size > 0 {
// 		println('Vertical Reflection between ${reflection_start + 1} and ${reflection_start + 2}')
// 		for line in lines {
// 			for i, c in line {
// 				if i <= reflection_start {
// 					eprint(colors['OKBLUE'])
// 				} else {
// 					eprint(colors['OKGREEN'])
// 				}
// 				eprint(c.ascii_str())
// 			}
// 			eprintln(colors['ENDC'])
// 		}
// 		return reflection_size + 1
// 	} else {
// 		return 0
// 	}
// }

fn get_vertical_string(lines []string, i int) string {
	mut s := ''
	for line in lines {
		s += '${line[i].ascii_str()}'
	}

	return s
}
