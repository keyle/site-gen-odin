package utils

import cm "../shared/commonmark"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

walk_markdown_files :: proc(dir_path: string, markdown_files: ^[dynamic]string) {
	fmt.println("opening folder", dir_path)
	fd, err := os.open(dir_path)
	bail(err, "Could not open folder:", dir_path)

	fis: []os.File_Info
	defer os.file_info_slice_delete(fis)

	fis, err = os.read_dir(fd, -1)
	bail(err, "Could not read directory")

	for f in fis {
		if f.is_dir {
			walk_markdown_files(f.fullpath, markdown_files)
		}
		if strings.has_suffix(f.fullpath, ".md") {
			append(markdown_files, strings.clone(f.fullpath))
			fmt.println(f)
		}
	}
}

read_file :: proc(path: string) -> string {
	raw, ok := os.read_entire_file_from_filename(path)
	if !ok {
		fmt.eprintln("Could not load file:", path)
		os.exit(1)
	}
	return string(raw)
}

markdown_to_html :: proc(markdown: string) -> string {
	str := markdown
	smart_opt := cm.DEFAULT_OPTIONS | cm.Options{.Source_Position}
	root := cm.parse_document(raw_data(str), len(str), smart_opt)
	defer cm.node_free(root)

	html := cm.render_html(root, cm.DEFAULT_OPTIONS)
	defer cm.free(html)

	fmt.println(html)
	return string(html)
}

// there is a walk function under filepath.walk but it won't work for me
// appending to the user_data rawptr wasn't working as it couldn't workout
// what append was against and I ran dry trying to tell it was a rawptr to a slice
// this is 100% my lack of knowledge and understanding of Odin, hopefully some day I get clarity.
// walk_markdown_files_alt :: proc(dir_path: string, markdown_files: ^[dynamic]os.File_Info) {
// 	filepath.walk(
// 		dir_path,
// 		proc(
// 			info: os.File_Info,
// 			in_err: os.Errno,
// 			user_data: rawptr,
// 		) -> (
// 			err: os.Errno,
// 			skip_dir: bool,
// 		) {
// 			markdown_files_ptr := cast(^[]string)user_data
// 			assert(err == os.ERROR_NONE)

// 			if strings.has_suffix(info.fullpath, ".md") {
// 				append(markdown_files_ptr, info.fullpath)
// 				// markdown_files_ptr = append(markdown_files_ptr, info.fullpath)
// 			}
// 			// fmt.println(info.fullpath) // /app (the root)
// 			// fmt.println(info.is_dir) // false (this is certainly a directory)
// 			return os.ERROR_NONE, false
// 		},
// 		cast(rawptr)markdown_files,
// 	)
// }


// bail gracefully upon error
bail :: proc(err: os.Errno, msg: ..string) {
	if err != os.ERROR_NONE {
		fmt.eprintln(msg)
		fmt.eprintln("Could not read directory:", err)
		os.exit(1)
	}
}
