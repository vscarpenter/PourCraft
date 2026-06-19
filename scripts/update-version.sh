#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROJECT_YML="$ROOT_DIR/project.yml"
XCODEPROJ="$ROOT_DIR/PourCraft.xcodeproj"
SCHEME="PourCraft"
RUN_SCREENSHOTS=0
DRY_RUN=0

usage() {
  cat <<'USAGE'
Usage:
  scripts/update-version.sh MAJOR MINOR PATCH [--screenshots] [--dry-run]
  scripts/update-version.sh MAJOR.MINOR.PATCH [--screenshots] [--dry-run]

Updates project.yml to the supplied marketing version and increments the build
number by one from the highest build found in project.yml or the generated
Xcode project. Then regenerates PourCraft.xcodeproj with XcodeGen.

Options:
  --screenshots  Regenerate App Store screenshots after the version bump.
  --dry-run      Print the planned version/build without changing files.
  -h, --help     Show this help.
USAGE
}

fail() {
  printf '[version] ERROR: %s\n' "$*" >&2
  exit 1
}

is_nonnegative_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

project_yml_build() {
  sed -nE 's/^[[:space:]]*CURRENT_PROJECT_VERSION:[[:space:]]*"?([0-9]+)"?[[:space:]]*$/\1/p' "$PROJECT_YML" \
    | head -n 1
}

xcodeproj_build() {
  local pbxproj="$XCODEPROJ/project.pbxproj"
  if [[ ! -f "$pbxproj" ]]; then
    return 0
  fi

  sed -nE 's/^[[:space:]]*CURRENT_PROJECT_VERSION = ([0-9]+);[[:space:]]*$/\1/p' "$pbxproj" \
    | sort -n \
    | tail -n 1
}

max_build() {
  local max=0
  local candidate

  for candidate in "$(project_yml_build)" "$(xcodeproj_build)"; do
    if [[ -n "$candidate" && "$candidate" =~ ^[0-9]+$ && "$candidate" -gt "$max" ]]; then
      max="$candidate"
    fi
  done

  if [[ "$max" -eq 0 ]]; then
    fail "Could not find an existing numeric CURRENT_PROJECT_VERSION"
  fi

  printf '%s\n' "$max"
}

verify_generated_settings() {
  local expected_version="$1"
  local expected_build="$2"
  local settings actual_version actual_build

  settings="$(xcodebuild -project "$XCODEPROJ" -scheme "$SCHEME" -showBuildSettings 2>/dev/null)"
  actual_version="$(awk -F'= ' '/MARKETING_VERSION =/ { print $2; exit }' <<<"$settings")"
  actual_build="$(awk -F'= ' '/CURRENT_PROJECT_VERSION =/ { print $2; exit }' <<<"$settings")"

  if [[ "$actual_version" != "$expected_version" ]]; then
    fail "Generated project MARKETING_VERSION is $actual_version, expected $expected_version"
  fi

  if [[ "$actual_build" != "$expected_build" ]]; then
    fail "Generated project CURRENT_PROJECT_VERSION is $actual_build, expected $expected_build"
  fi
}

version_args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --screenshots)
      RUN_SCREENSHOTS=1
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      fail "Unknown option: $1"
      ;;
    *)
      version_args+=("$1")
      ;;
  esac
  shift
done

major=""
minor=""
patch=""

case "${#version_args[@]}" in
  1)
    if [[ "${version_args[0]}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
      major="${BASH_REMATCH[1]}"
      minor="${BASH_REMATCH[2]}"
      patch="${BASH_REMATCH[3]}"
    else
      fail "Version must be MAJOR.MINOR.PATCH, e.g. 2.3.0"
    fi
    ;;
  3)
    major="${version_args[0]}"
    minor="${version_args[1]}"
    patch="${version_args[2]}"
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

is_nonnegative_integer "$major" || fail "Major version must be a non-negative integer"
is_nonnegative_integer "$minor" || fail "Minor version must be a non-negative integer"
is_nonnegative_integer "$patch" || fail "Patch version must be a non-negative integer"

[[ -f "$PROJECT_YML" ]] || fail "Missing project.yml"

current_build="$(max_build)"
next_build="$((current_build + 1))"
next_version="$major.$minor.$patch"

if [[ "$DRY_RUN" -eq 1 ]]; then
  printf '[version] Would set MARKETING_VERSION=%s\n' "$next_version"
  printf '[version] Would increment CURRENT_PROJECT_VERSION from %s to %s\n' "$current_build" "$next_build"
  if [[ "$RUN_SCREENSHOTS" -eq 1 ]]; then
    printf '[version] Would regenerate App Store screenshots\n'
  fi
  exit 0
fi

command -v xcodegen >/dev/null 2>&1 || fail "xcodegen is not installed or not on PATH"

VERSION="$next_version" BUILD="$next_build" perl -0pi -e '
  s/(MARKETING_VERSION:\s*)"?\d+\.\d+\.\d+"?/${1}"$ENV{VERSION}"/;
  s/(CURRENT_PROJECT_VERSION:\s*)"?\d+"?/${1}"$ENV{BUILD}"/;
' "$PROJECT_YML"

printf '[version] Updated project.yml to %s (%s)\n' "$next_version" "$next_build"
printf '[version] Regenerating Xcode project\n'
xcodegen generate

verify_generated_settings "$next_version" "$next_build"
printf '[version] Verified generated Xcode settings\n'

if [[ "$RUN_SCREENSHOTS" -eq 1 ]]; then
  printf '[version] Regenerating App Store screenshots\n'
  scripts/generate-appstore-screenshots.sh
fi

printf '[version] Done: %s (%s)\n' "$next_version" "$next_build"
