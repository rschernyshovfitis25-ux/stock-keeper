# StockKeeper

**StockKeeper** – хмарна система обліку товарних запасів для малого бізнесу. Дозволяє вести каталог товарів,
оформлювати прихід і списання скануванням штрихкоду зі смартфона, контролювати залишки в реальному часі та
отримувати сповіщення в Telegram, коли товар закінчується.

Навчальний наскрізний проєкт з дисципліни «Основи бізнес-аналізу та проджект-менеджменту в ІТ», ЧДТУ, 2026.
Автор: Чернишов Р. С., група ПЗск-2404.

## Структура репозиторію

```
stock-keeper/
├── README.md              – опис проєкту
├── .gitignore             – виключення для Git (Python + Node)
├── docs/                  – проєктна документація
│   ├── 01_Project_Brief.docx
│   ├── 02_Vision_Document.docx
│   ├── 03_Specification_v0.1.docx
│   ├── 04_Team.docx
│   ├── SRS.docx
│   ├── project_plan.docx
│   └── gantt.png
├── issues/                – тексти User Stories для GitHub Issues
├── scripts/setup_github.sh – створення labels, milestones, issues і GitHub Project
└── src/                   – вихідний код (backend – Django, frontend – React)
```

## Стек
- **Backend:** Python 3.12, Django 5 + Django REST Framework
- **Frontend:** React 18 + TypeScript, Vite, PWA; бібліотека ZXing для сканування штрихкодів
- **База даних:** PostgreSQL 16
- **Інтеграції:** Telegram Bot API, SMTP (email), експорт XLSX через openpyxl
- **Інфраструктура:** Docker, GitHub Actions (CI), хостинг Render / Railway (free tier)
- **Інструменти:** Git, GitHub (Issues, Projects), VS Code + GitHub Copilot, Figma
