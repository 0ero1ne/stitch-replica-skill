#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

usage() {
  cat <<'EOF'
Usage:
  ./skill.sh list
  ./skill.sh path <skill-name>
  ./skill.sh install-local [target-dir]

Commands:
  list                         List all skills in this repository.
  path <skill-name>            Print the SKILL.md path for a skill.
  install-local [target-dir]   Install all skills to target-dir.
                               Default target: .agents/skills

This script installs the whole skill set. It does not install single skills.
EOF
}

require_skills_dir() {
  if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "Error: skills directory not found: $SKILLS_DIR" >&2
    exit 1
  fi
}

list_skills() {
  require_skills_dir

  local found=0
  local skill_dir
  for skill_dir in "$SKILLS_DIR"/*; do
    [[ -d "$skill_dir" ]] || continue
    local name
    name="$(basename "$skill_dir")"
    if [[ -f "$skill_dir/SKILL.md" ]]; then
      printf '%s\t%s\n' "$name" "$skill_dir/SKILL.md"
      found=1
    fi
  done

  if [[ "$found" -eq 0 ]]; then
    echo "Error: no skills with SKILL.md found under: $SKILLS_DIR" >&2
    exit 1
  fi
}

skill_path() {
  require_skills_dir

  local skill_name="${1:-}"
  if [[ -z "$skill_name" ]]; then
    echo "Error: missing skill name." >&2
    usage >&2
    exit 1
  fi

  local skill_file="$SKILLS_DIR/$skill_name/SKILL.md"
  if [[ ! -f "$skill_file" ]]; then
    echo "Error: skill not found: $skill_name" >&2
    echo "Expected: $skill_file" >&2
    exit 1
  fi

  echo "$skill_file"
}

install_local() {
  require_skills_dir

  local target_dir="${1:-.agents/skills}"
  mkdir -p "$target_dir"

  local installed=()
  local found=0
  local skill_dir
  for skill_dir in "$SKILLS_DIR"/*; do
    [[ -d "$skill_dir" ]] || continue
    local name
    name="$(basename "$skill_dir")"
    if [[ -f "$skill_dir/SKILL.md" ]]; then
      rm -rf "$target_dir/$name"
      cp -R "$skill_dir" "$target_dir/"
      installed+=("$name")
      found=1
    fi
  done

  if [[ "$found" -eq 0 ]]; then
    echo "Error: no skills with SKILL.md found under: $SKILLS_DIR" >&2
    exit 1
  fi

  echo "Installed all skills to: $target_dir"
  for name in "${installed[@]}"; do
    echo "- $name"
  done
}

main() {
  local command="${1:-}"
  case "$command" in
    list)
      list_skills
      ;;
    path)
      shift || true
      skill_path "${1:-}"
      ;;
    install-local)
      shift || true
      install_local "${1:-.agents/skills}"
      ;;
    -h|--help|help|"")
      usage
      ;;
    *)
      echo "Error: unknown command: $command" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
