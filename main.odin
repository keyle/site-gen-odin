package main

import "core:fmt"
import "core:os"
import s "settings"
import "utils"

main :: proc() {
	settings: s.Settings
	s.load_settings(&settings)

	markdown_files := make([dynamic]os.File_Info, context.temp_allocator)
	defer delete(markdown_files)

	utils.walk_markdown_files(settings.workdir, &markdown_files)

	// TODO @next do something with the markdown files
}
