#!/usr/bin/env bash
# Налаштування GitHub для ЛР2–ЛР3: labels, milestones (спринти), issues, GitHub Project.
# Потрібно: gh CLI (https://cli.github.com), виконати `gh auth login` та `gh auth refresh -s project`.
# Запуск з кореня репозиторію:  bash scripts/setup_github.sh
set -euo pipefail
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
OWNER=${REPO%%/*}
echo "Репозиторій: $REPO"

# ---- ЛР2: мітки ----
mk() { gh label create "$1" --color "$2" --description "$3" --force; }
mk "user-story"            "1D76DB" "Функціональна вимога у форматі User Story"
mk "enhancement"           "A2EEEF" "Покращення існуючої функціональності"
mk "bug"                   "D73A4A" "Дефект або помилка"
mk "documentation"         "0075CA" "Задача з документування"
mk "priority: high"        "B60205" "Високий пріоритет"
mk "priority: medium"      "FBCA04" "Середній пріоритет"
mk "priority: low"         "0E8A16" "Низький пріоритет"
# ---- ЛР3: MoSCoW ----
mk "priority: must-have"   "5319E7" "MoSCoW: Must Have"
mk "priority: should-have" "8A63D2" "MoSCoW: Should Have"
mk "priority: could-have"  "C5DEF5" "MoSCoW: Could Have"
mk "priority: wont-have"   "EDEDED" "MoSCoW: Won't Have"

# ---- ЛР3: milestones (спринти) ----
gh api "repos/$REPO/milestones" -f title="Sprint 1" -f description="Фундамент: акаунти та каталог" -f due_on="2026-11-08T21:00:00Z" >/dev/null || true
gh api "repos/$REPO/milestones" -f title="Sprint 2" -f description="Ядро обліку" -f due_on="2026-11-22T21:00:00Z" >/dev/null || true
gh api "repos/$REPO/milestones" -f title="Sprint 3" -f description="Швидкість і контроль" -f due_on="2026-12-06T21:00:00Z" >/dev/null || true
gh api "repos/$REPO/milestones" -f title="Sprint 4" -f description="Інвентаризація та реліз MVP" -f due_on="2026-12-20T21:00:00Z" >/dev/null || true

# ---- ЛР2: issues ----
ME=$(gh api user -q .login)
create_issue() {
  local title="$1" file="$2" labels="$3" ms="$4"
  if [ -n "$ms" ]; then
    gh issue create --title "$title" --body-file "$file" --label "$labels" --assignee "$ME" --milestone "$ms"
  else
    gh issue create --title "$title" --body-file "$file" --label "$labels" --assignee "$ME"
  fi
}
create_issue "[US-001] Реєстрація бізнесу" "issues/US-001.md" "user-story,priority: high,priority: must-have" "Sprint 1"
create_issue "[US-002] Запрошення працівників і ролі" "issues/US-002.md" "user-story,priority: high,priority: must-have" "Sprint 1"
create_issue "[US-003] Картка товару" "issues/US-003.md" "user-story,priority: high,priority: must-have" "Sprint 1"
create_issue "[US-004] Прихід товару" "issues/US-004.md" "user-story,priority: high,priority: must-have" "Sprint 2"
create_issue "[US-005] Продаж / списання" "issues/US-005.md" "user-story,priority: high,priority: must-have" "Sprint 2"
create_issue "[US-006] Сканування штрихкоду" "issues/US-006.md" "user-story,priority: medium,priority: should-have" "Sprint 3"
create_issue "[US-007] Перегляд залишків" "issues/US-007.md" "user-story,priority: high,priority: must-have" "Sprint 2"
create_issue "[US-008] Сповіщення про критичний залишок" "issues/US-008.md" "user-story,priority: medium,priority: should-have" "Sprint 3"
create_issue "[US-009] Інвентаризація" "issues/US-009.md" "user-story,priority: medium,priority: should-have" "Sprint 4"
create_issue "[US-010] Звіт про рух товарів" "issues/US-010.md" "user-story,priority: medium,priority: should-have" "Sprint 3"
create_issue "[US-011] Дашборд власника" "issues/US-011.md" "user-story,priority: low,priority: could-have" "Sprint 4"
create_issue "[US-012] Переміщення між точками" "issues/US-012.md" "user-story,priority: low,priority: wont-have" ""

# ---- ЛР3: GitHub Project (Kanban) ----
PNUM=$(gh project create --owner "$OWNER" --title "StockKeeper" --format json -q .number)
gh project link "$PNUM" --owner "$OWNER" --repo "$REPO"
for n in $(gh issue list --state all --limit 100 --json number -q '.[].number'); do
  gh project item-add "$PNUM" --owner "$OWNER" --url "https://github.com/$REPO/issues/$n" >/dev/null
done
gh project field-create "$PNUM" --owner "$OWNER" --name "Story Points" --data-type NUMBER
gh project field-create "$PNUM" --owner "$OWNER" --name "Priority" --data-type SINGLE_SELECT --single-select-options "High,Medium,Low"
gh project field-create "$PNUM" --owner "$OWNER" --name "Start date" --data-type DATE
gh project field-create "$PNUM" --owner "$OWNER" --name "End date" --data-type DATE
echo "Готово. Далі вручну у вебінтерфейсі Project: колонки Status (Backlog, To Do, In Progress, In Review, Done),"
echo "значення Story Points/Priority/дат, Board- і Roadmap-вигляди, workflow 'Item closed -> Done'."
