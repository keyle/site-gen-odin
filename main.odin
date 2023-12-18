package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strings"
import s "settings"
import "utils"

Article :: struct {
	path:        string,
	file:        string,
	markdown:    string,
	html:        string,
	title:       string,
	is_blog:     bool,
	url:         string,
	pub_date:    string,
	description: string,
	tags:        []string,
}

main :: proc() {
	settings := s.Settings{}
	s.load_settings(&settings)

	fmt.println("")
	fmt.println(settings)

	markdown_files := make([dynamic]string)
	defer delete(markdown_files)

	utils.walk_markdown_files(settings.workdir, &markdown_files)

	articles := make([dynamic]Article)
	defer delete(articles)

	for file in markdown_files {
		markdown := utils.read_file(file)

		article := Article {
			file     = strings.clone(slice.last_ptr(strings.split(file, "/"))^),
			path     = file,
			markdown = markdown,
			is_blog  = strings.contains(markdown, "<x-blog-title>"),
			html     = utils.read_file(
				strings.contains(markdown, "<x-index/>") \
				? settings.templateindex \
				: settings.template,
			),
		}
		html := utils.markdown_to_html(article.markdown)
        fmt.println(html)

		append(&articles, article)
	}


	// TODO @next do something with the markdown files
}
