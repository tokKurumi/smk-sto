// smk-sto — Typst-шаблон для оформления учебной отчётности
// в ФГБОУ ВО «МГУ им. Н.П. Огарёва»:
//
//   • отчёт о лабораторной работе — СМК СТО 004–2020 (`lab-report`);
//   • отчёт о практике           — СМК СТО 014–2025 (`practice-report`).
//
// Подключение:
//
//   #import "@preview/smk-sto:0.2.0": *
//
//   #show: lab-report.with(...)       // для лабораторной работы
//   // или
//   #show: practice-report.with(...)  // для отчёта о практике

#import "constants.typ": (
  default-font, default-text-size, default-small-size,
  default-indent, default-margin,
  default-okpo, default-city, default-ministry, default-organization,
)
#import "style.typ": smk-style
#import "utils.typ": (
  enum-letter, sign-field, where-block,
  table-label, table-continuation, nbsp-name,
)
#import "appendix.typ": appendix
#import "diagram.typ": diagram, node, edge

// Лабораторные работы (СМК СТО 004–2020).
#import "lab/report.typ": lab-report
#import "lab/title.typ": lab-report-title-page
#import "lab/designation.typ": lab-report-designation

// Отчёт о практике (СМК СТО 014–2025).
#import "practice/report.typ": practice-report
#import "practice/title.typ": practice-report-title-page
#import "practice/designation.typ": practice-report-designation
// Сопровождающие формы (Приложения Б, Г, Д, Ж к СТО 014–2025).
#import "practice/task.typ": practice-report-task
#import "practice/diary.typ": practice-report-diary
#import "practice/survey.typ": practice-report-survey
#import "practice/feedback.typ": practice-report-feedback
