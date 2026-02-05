const { GLib, St, Clutter, Pango } = imports.gi;
const main = imports.ui.main;
const ExtensionUtils = imports.misc.extensionUtils;

let clockDisplays = [];
let formatLabels = [];
let settings;
let timeoutID = 0;

/**
 * Initialising function which will be invoked at most once directly after your source JS file is loaded.
 */
function init() {}

/**
 * Enable, called when extension is enabled or when screen is unlocked.
 */
function enable() {
	clockDisplays = _getAllClockDisplays();
	formatLabels = [];
	settings = ExtensionUtils.getSettings();

	// FIXME: Set settings first time to make it visible in dconf Editor
	if (!settings.get_string("format")) {
		settings.set_string("format", "%Y.%m.%d %H:%M");
	}

	for (const clock of clockDisplays) {
		const lbl = new St.Label({ style_class: "clock" });
		lbl.clutter_text.y_align = Clutter.ActorAlign.CENTER;
		lbl.clutter_text.ellipsize = Pango.EllipsizeMode.NONE;

		clock.hide();
		clock.get_parent().insert_child_below(lbl, clock);

		formatLabels.push(lbl);
	}

	timeoutID = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1000, tick);
}

/**
 * Disable, called when extension is disabled or when screen is locked.
 */
function disable() {
	GLib.Source.remove(timeoutID);
	timeoutID = 0;
	for (let i = 0; i < clockDisplays.length; i++) {
		const orig = clockDisplays[i];
		const lbl = formatLabels[i];
		orig.get_parent().remove_child(lbl);
		orig.show();
		lbl.destroy();
	}

	settings = null;
	formatLabels = [];
	clockDisplays = [];
}

/**
 * It runs every time we need to update clock.
 * @return {boolean} Always returns true to loop.
 */
function tick() {
	const format = settings.get_string("format");
	const text = new GLib.DateTime().format(format);

	// NEW: update all labels
	for (const lbl of formatLabels) {
		lbl.set_text(text);
	}

	return true;
}

function _getAllClockDisplays() {
	const list = [];

	// primary panel
	list.push(main.panel.statusArea.dateMenu._clockDisplay);

	// dash-to-panel extra monitors
	if (global.dashToPanel && global.dashToPanel.panels) {
		for (const p of global.dashToPanel.panels) {
			const panel = p.panel;
			const dm = panel.statusArea.dateMenu;
			if (dm && dm._clockDisplay) list.push(dm._clockDisplay);
		}
	}

	// remove duplicates (Dash-to-Panel sometimes includes primary)
	return [...new Set(list)];
}
