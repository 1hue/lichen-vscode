// Write files mapped under "generate" in package.json from VS Code settings
// Usage: node generate.js <settings.json>
const fs = require("fs");
const path = require("path");

const settingsFile = process.argv[2];

// Settings allow line comments and trailing commas
const parseJsonc = (text) =>
	JSON.parse(text.replace(/^\s*\/\/.*$/gm, "").replace(/,(\s*[}\]])/g, "$1"));

const settings = parseJsonc(fs.readFileSync(settingsFile, "utf8"));
const templates = JSON.parse(fs.readFileSync("package.json", "utf8")).generate;

/** Look up path like `editor.tokenColorCustomizations/textMateRules` in settings */
const lookup = (keyPath) =>
	keyPath.split("/").reduce((value, key) => {
		if (!(key in value)) throw new Error(`${keyPath} not in ${settingsFile}`);
		return value[key];
	}, settings);

/** Expand key list like `["*", "!.vscode/colors.json"]` - all settings minus keys of that file */
const expandKeys = (entries) => {
	const excluded = entries
		.filter((e) => e.startsWith("!"))
		.flatMap((e) => templates[e.slice(1)] ?? [e.slice(1)]);
	return entries
		.filter((e) => !e.startsWith("!"))
		.flatMap((e) => (e === "*" ? Object.keys(settings) : [e]))
		.filter((k) => !excluded.includes(k));
};

// Array lists setting keys, object maps fields to `#/` paths or literal values
const fill = (template) =>
	Array.isArray(template)
		? Object.fromEntries(expandKeys(template).map((k) => [k, lookup(k)]))
		: Object.fromEntries(
				Object.entries(template).map(([key, value]) => [
					key,
					String(value).startsWith("#/") ? lookup(value.slice(2)) : value,
				]),
			);

for (const [file, template] of Object.entries(templates)) {
	fs.mkdirSync(path.dirname(file), { recursive: true });
	fs.writeFileSync(file, JSON.stringify(fill(template), null, 2) + "\n");
}
