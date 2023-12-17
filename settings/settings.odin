package settings

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

Settings :: struct {
	workdir:        string,
	webroot:        string,
	template:       string,
	templateindex:  string,
	contenttag:     string,
	titletag:       string,
	descriptiontag: string,
	keywordstag:    string,
}

load_settings :: proc(settings: ^Settings) {
	user_home_dir := os.get_env("HOME")
	settings_location := strings.join(
		[]string{user_home_dir, ".config/site-gen/settings.json"},
		"/",
	)
	fmt.println("getting settings from", settings_location)
	settings_raw, ok := os.read_entire_file_from_filename(settings_location)
	if !ok {
		fmt.eprintln("Failed to load settings from default location:", settings_location)
		return
	}
	defer delete(settings_raw)

	json_data, err := json.parse(settings_raw)
	if err != .None {
		fmt.eprintln("Failed to parse the json file.")
		fmt.eprintln("Error:", err)
		return
	}
	defer json.destroy_value(json_data)

	root := json_data.(json.Object)

    settings.workdir = root["workdir"].(json.String)
    settings.webroot = root["webroot"].(json.String)
    settings.template = root["template"].(json.String)
    settings.templateindex = root["templateindex"].(json.String)
    settings.contenttag = root["contenttag"].(json.String)
    settings.titletag = root["titletag"].(json.String)
    settings.descriptiontag = root["descriptiontag"].(json.String)
    settings.keywordstag = root["keywordstag"].(json.String)

	fmt.println("Settings loaded successfully.")
}
