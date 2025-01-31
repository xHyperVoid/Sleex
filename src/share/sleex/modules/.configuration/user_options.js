const { GLib } = imports.gi;
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import userOverrides from "../../user_options.js";

// Default options.
const defaultConfigPath = `/usr/share/sleex/modules/.configuration/default_config.json`;
let configOptions = {};


try {
  const defaultConfig = Utils.readFile(defaultConfigPath);
  configOptions = JSON.parse(defaultConfig);
} catch (e) {
  console.error('Error loading user_options.default.json:', e);
}

// Override defaults with user's options
let optionsOkay = true;
function overrideConfigRecursive(
  userOverrides,
  configOptions = {},
  check = true
) {
  for (const [key, value] of Object.entries(userOverrides)) {
    if (configOptions[key] === undefined && check) {
      optionsOkay = false;
    } else if (typeof value === "object" && !(value instanceof Array)) {
      if (
        key === "substitutions" ||
        key === "regexSubstitutions" ||
        key === "extraGptModels"
      ) {
        overrideConfigRecursive(value, configOptions[key], false);
      } else overrideConfigRecursive(value, configOptions[key]);
    } else {
      configOptions[key] = value;
    }
  }
}
overrideConfigRecursive(userOverrides, configOptions);
if (!optionsOkay)
  Utils.timeout(2000, () =>
    Utils.execAsync([
      "notify-send",
      "Update your user options",
      "One or more config options don't exist",
      "-a",
      "ags",
    ]).catch(print)
  );

globalThis["userOptions"] = configOptions;
export default configOptions;
