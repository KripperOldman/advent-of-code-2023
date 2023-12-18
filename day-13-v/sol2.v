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
	
	outer : for lines := os.get_lines(); lines != []; lines = os.get_lines() {
		mut group_sol := 0
		smudged := smudge(lines)

		old_verts := get_vertical_reflection(lines)
		old_vert := if old_verts.len > 0 {old_verts[0]} else {0}

		old_hors := get_horizontal_reflection(lines)
		old_hor := if old_hors.len > 0 {old_hors[0]} else {0}

		for x in smudged {
			verts := get_vertical_reflection(x).filter(it != old_vert)
			vert := if verts.len > 0 {verts[0]} else {0}
			hors := get_horizontal_reflection(x).filter(it != old_hor)
			hor := if hors.len > 0 {hors[0]} else {0}

			if vert > 0 {
				group_sol = vert
				// println('Vertical Reflection between ${vert} and ${vert}')
				for line in x {
					for i, c in line {
						if i < vert {
							eprint(colors['OKBLUE'])
						} else {
							eprint(colors['OKGREEN'])
						}
						eprint(c.ascii_str())
					}
					eprintln(colors['ENDC'])
				}
				break
			}
			if hor > 0 {
				group_sol = 100 * hor

				// println('Horizontal Reflection Found between ${hor} and ${hor + 1}')
				for i, line in x {
					if i < hor {
						eprint(colors['OKBLUE'])
					} else {
						eprint(colors['OKGREEN'])
					}
					eprint(line)
					eprintln(colors['ENDC'])
				}
				break
			}
		}

		if group_sol == 0 {
			// println('No Reflection Found.')
			for line in lines {
				eprint(colors['WARNING'])
				eprint(line)
				eprintln(colors['ENDC'])
			}
		}
		eprintln('')
		sol += group_sol
	}

	println(sol)
}

fn smudge(lines []string) [][]string {
	mut smudged := [][]string{}
	for i, line in lines {
		for j, _ in line {
			mut new := lines.clone()
			if line[j] == '.'[0] {
				new[i] = new[i][..j] + '#' + new[i][j + 1..]
			} else {
				new[i] = new[i][..j] + '.' + new[i][j + 1..]
			}
			smudged << new
		}
	}

	return smudged
}

fn get_horizontal_reflection(lines []string) []int {
	// 	eprintln('Getting Horizontal Reflections')
	mut reflections := []int{}
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
				reflections << reflection_start + 1
				reflection_size = 0
				reflection_start++
				next_index = reflection_start + 1
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
		reflections << reflection_start + 1
	}
	return reflections
}

fn get_vertical_reflection(lines []string) []int {
	// eprintln('Getting Vertical Reflections')
	mut reflections := []int{}
	mut prev_lines := []string{}
	mut reflection_start := -1
	mut reflection_size := 0
	mut col_index := 0
	for col_index < lines[0].len {
		mut next_index := -1
		line := get_vertical_string(lines, col_index)
		reflection_index := reflection_start - reflection_size

		// eprintln(line)
		// eprintln('col_index ${col_index}')
		// eprintln('reflection_start ${reflection_start}')
		// eprintln('reflection_index ${reflection_index}')
		// eprintln('reflection_size  ${reflection_size}')
		// eprintln(prev_lines)
		// eprintln('')

		if prev_lines.len > 0 && line == prev_lines[reflection_index] {
			reflection_size++

			if reflection_size == reflection_start + 1 {
				reflections << reflection_start + 1
				reflection_start++
				reflection_size = 0
				next_index = reflection_start + 1
			} else {
				next_index = col_index + 1
			}
		} else {
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
		reflections << reflection_start + 1
	}
	return reflections
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
