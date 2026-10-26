#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROJECT="${PROJECT:-PourCraft.xcodeproj}"
SCHEME="${SCHEME:-PourCraft}"
IPHONE_DEVICE_NAME="${IPHONE_DEVICE_NAME:-iPhone 17 Pro Max}"
# App Store Connect requires at least one 6.3-inch (Dynamic Island, medium) iPhone screenshot.
IPHONE_MEDIUM_DEVICE_NAME="${IPHONE_MEDIUM_DEVICE_NAME:-iPhone 17 Pro}"
IPAD_DEVICE_NAME="${IPAD_DEVICE_NAME:-iPad Pro 13-inch (M5)}"
SCREENSHOT_ROOT="${SCREENSHOT_ROOT:-$ROOT_DIR/screenshots/appstore}"
RESULT_ROOT="${RESULT_ROOT:-$ROOT_DIR/build/appstore-screenshot-results}"
PRIVACY_URL="${PRIVACY_URL:-https://www.pourcraftcoffee.com/privacy.html}"

IPHONE_DIR="$SCREENSHOT_ROOT/iphone-6.9"
IPHONE_MEDIUM_DIR="$SCREENSHOT_ROOT/iphone-6.3"
IPAD_DIR="$SCREENSHOT_ROOT/ipad-13"
MANIFEST="$SCREENSHOT_ROOT/README.md"
IPHONE_RESULT="$RESULT_ROOT/iphone-6.9.xcresult"
IPHONE_MEDIUM_RESULT="$RESULT_ROOT/iphone-6.3.xcresult"
IPAD_RESULT="$RESULT_ROOT/ipad-13.xcresult"

log() {
  printf '[screenshots] %s\n' "$*"
}

fail() {
  printf '[screenshots] ERROR: %s\n' "$*" >&2
  exit 1
}

find_device_id() {
  local device_name="$1"
  xcrun simctl list devices available iOS \
    | grep -F "$device_name (" \
    | sed -E 's/.*\(([0-9A-Fa-f-]{36})\).*/\1/' \
    | tail -n 1
}

image_size() {
  local file="$1"
  sips -g pixelWidth -g pixelHeight "$file" \
    | awk '/pixelWidth/ { width = $2 } /pixelHeight/ { height = $2 } END { print width "x" height }'
}

validate_size() {
  local kind="$1"
  local size="$2"

  case "$kind:$size" in
    iphone:1260x2736|iphone:2736x1260|iphone:1290x2796|iphone:2796x1290|iphone:1320x2868|iphone:2868x1320) ;;
    iphone-medium:1179x2556|iphone-medium:2556x1179|iphone-medium:1206x2622|iphone-medium:2622x1206) ;;
    ipad:2064x2752|ipad:2752x2064|ipad:2048x2732|ipad:2732x2048) ;;
    *) fail "$kind screenshot has unsupported App Store size: $size" ;;
  esac
}

validate_dir() {
  local kind="$1"
  local dir="$2"
  local count=0
  local file
  shopt -s nullglob
  for file in "$dir"/*.png; do
    local size
    size="$(image_size "$file")"
    validate_size "$kind" "$size"
    count=$((count + 1))
  done
  shopt -u nullglob

  if [[ "$count" -eq 0 ]]; then
    fail "No PNG screenshots were generated in $dir"
  fi
}

run_ui_test() {
  local device_id="$1"
  local output_dir="$2"
  local result_bundle="$3"
  shift 3

  mkdir -p "$output_dir"
  log "Running UI screenshots on $device_id"
  env POURCRAFT_SCREENSHOT_DIR="$output_dir" \
    xcodebuild \
      -quiet \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -sdk iphonesimulator \
      -destination "platform=iOS Simulator,id=$device_id" \
      -resultBundlePath "$result_bundle" \
      "$@" \
      test
}

export_result_screenshots() {
  local result_bundle="$1"
  local output_dir="$2"
  local export_dir="$3"
  local copied=0

  rm -rf "$export_dir"
  mkdir -p "$export_dir"

  xcrun xcresulttool export attachments \
    --path "$result_bundle" \
    --output-path "$export_dir" \
    >/dev/null

  if [[ ! -f "$export_dir/manifest.json" ]]; then
    fail "Xcode result bundle did not contain an attachment manifest: $result_bundle"
  fi

  while IFS=$'\t' read -r exported_file clean_name; do
    if [[ -z "$exported_file" || -z "$clean_name" ]]; then
      continue
    fi

    if [[ ! -f "$export_dir/$exported_file" ]]; then
      fail "Attachment listed in manifest was not exported: $exported_file"
    fi

    cp "$export_dir/$exported_file" "$output_dir/$clean_name"
    copied=$((copied + 1))
  done < <(
    MANIFEST_JSON="$export_dir/manifest.json" osascript -l JavaScript -e '
      ObjC.import("stdlib");
      const app = Application.currentApplication();
      app.includeStandardAdditions = true;
      const manifestPath = $.getenv("MANIFEST_JSON");
      const manifest = JSON.parse(app.read(Path(manifestPath)));
      const pairs = [];

      for (const test of manifest) {
        for (const attachment of (test.attachments || [])) {
          const exported = attachment.exportedFileName || "";
          const suggested = attachment.suggestedHumanReadableName || "";
          if (!exported.endsWith(".png") || !suggested.endsWith(".png")) {
            continue;
          }
          const clean = suggested.replace(/_0_[0-9A-Fa-f-]+\.png$/, ".png");
          pairs.push(exported + "\t" + clean);
        }
      }

      pairs.join("\n");
    '
  )

  if [[ "$copied" -eq 0 ]]; then
    fail "No screenshot PNG attachments were exported from $result_bundle"
  fi
}

repair_ipad_landscape_screenshots() {
  local file
  shopt -s nullglob
  for file in "$IPAD_DIR"/*Landscape*.png; do
    local size
    size="$(image_size "$file")"
    case "$size" in
      2064x2752|2048x2732)
        log "Rotating $(basename "$file") to landscape orientation"
        sips -r 270 "$file" >/dev/null
        ;;
      2752x2064|2732x2048)
        ;;
      *)
        fail "iPad landscape screenshot has unexpected pre-rotation size: $size"
        ;;
    esac
    clear_orientation_tag "$file"
  done
  shopt -u nullglob
}

# The landscape capture carries EXIF and XMP orientation tags, and sips keeps
# them after rotating the pixels. Viewers that honor the tag then show the
# screenshot sideways, so clear it once the pixels are upright.
clear_orientation_tag() {
  local file="$1"
  exiftool -quiet -overwrite_original -EXIF:Orientation= -XMP:Orientation= "$file"
  log "Cleared orientation tag on $(basename "$file")"
}

write_manifest() {
  {
    printf '# PourCraft App Store Screenshots\n\n'
    printf 'Generated by `scripts/generate-appstore-screenshots.sh`.\n\n'
    printf 'Privacy URL: <%s>\n\n' "$PRIVACY_URL"
    printf '## iPhone 6.9-inch\n\n'
    local file
    for file in "$IPHONE_DIR"/*.png; do
      printf -- '- `%s` - `%s`\n' "$(basename "$file")" "$(image_size "$file")"
    done
    printf '\n## iPhone 6.3-inch\n\n'
    for file in "$IPHONE_MEDIUM_DIR"/*.png; do
      printf -- '- `%s` - `%s`\n' "$(basename "$file")" "$(image_size "$file")"
    done
    printf '\n## iPad 13-inch\n\n'
    for file in "$IPAD_DIR"/*.png; do
      printf -- '- `%s` - `%s`\n' "$(basename "$file")" "$(image_size "$file")"
    done
  } > "$MANIFEST"
}

IPHONE_DEVICE_ID="$(find_device_id "$IPHONE_DEVICE_NAME")"
IPHONE_MEDIUM_DEVICE_ID="$(find_device_id "$IPHONE_MEDIUM_DEVICE_NAME")"
IPAD_DEVICE_ID="$(find_device_id "$IPAD_DEVICE_NAME")"

if [[ -z "$IPHONE_DEVICE_ID" ]]; then
  fail "Could not find simulator named $IPHONE_DEVICE_NAME"
fi

if [[ -z "$IPHONE_MEDIUM_DEVICE_ID" ]]; then
  fail "Could not find simulator named $IPHONE_MEDIUM_DEVICE_NAME"
fi

if [[ -z "$IPAD_DEVICE_ID" ]]; then
  fail "Could not find simulator named $IPAD_DEVICE_NAME"
fi

log "Using iPhone simulator: $IPHONE_DEVICE_NAME ($IPHONE_DEVICE_ID)"
log "Using iPhone 6.3-inch simulator: $IPHONE_MEDIUM_DEVICE_NAME ($IPHONE_MEDIUM_DEVICE_ID)"
log "Using iPad simulator: $IPAD_DEVICE_NAME ($IPAD_DEVICE_ID)"

command -v exiftool >/dev/null 2>&1 \
  || fail "exiftool is required to clear orientation tags on landscape screenshots (brew install exiftool)"

log "Checking privacy URL"
curl -fsSI "$PRIVACY_URL" >/dev/null

log "Regenerating Xcode project"
xcodegen generate

rm -rf "$SCREENSHOT_ROOT" "$RESULT_ROOT"
mkdir -p "$IPHONE_DIR" "$IPHONE_MEDIUM_DIR" "$IPAD_DIR" "$RESULT_ROOT"

run_ui_test \
  "$IPHONE_DEVICE_ID" \
  "$IPHONE_DIR" \
  "$IPHONE_RESULT" \
  -only-testing:PourCraftUITests/PourCraftUITests/testCompactPhoneScreenshots

export_result_screenshots "$IPHONE_RESULT" "$IPHONE_DIR" "$RESULT_ROOT/iphone-attachments"

run_ui_test \
  "$IPHONE_MEDIUM_DEVICE_ID" \
  "$IPHONE_MEDIUM_DIR" \
  "$IPHONE_MEDIUM_RESULT" \
  -only-testing:PourCraftUITests/PourCraftUITests/testCompactPhoneScreenshots

export_result_screenshots "$IPHONE_MEDIUM_RESULT" "$IPHONE_MEDIUM_DIR" "$RESULT_ROOT/iphone-medium-attachments"

run_ui_test \
  "$IPAD_DEVICE_ID" \
  "$IPAD_DIR" \
  "$IPAD_RESULT" \
  -only-testing:PourCraftUITests/PourCraftUITests/testIPadWideScreenshotsAndSplitSelection \
  -only-testing:PourCraftUITests/PourCraftUITests/testIPadLandscapeShellAndAccessibilityState

export_result_screenshots "$IPAD_RESULT" "$IPAD_DIR" "$RESULT_ROOT/ipad-attachments"
repair_ipad_landscape_screenshots

validate_dir iphone "$IPHONE_DIR"
validate_dir iphone-medium "$IPHONE_MEDIUM_DIR"
validate_dir ipad "$IPAD_DIR"
write_manifest

log "Generated App Store screenshots in $SCREENSHOT_ROOT"
