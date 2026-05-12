// Параметры оформления по СМК СТО 004–2020 (МГУ им. Н.П. Огарёва).

#let default-font = ("Times New Roman", "Liberation Serif", "DejaVu Serif")
#let default-text-size = 14pt
#let default-small-size = 12pt
#let default-indent = 1.25cm
#let default-margin = (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm)
#let default-leading = 0.75em   // 1,5-строчный интервал
#let default-spacing = 1.5em

#let default-okpo = "02069964"  // ОКПО МГУ им. Н.П. Огарёва
#let default-city = "Саранск"
#let default-ministry = "Министерство науки и высшего образования Российской Федерации"
// Полное наименование по Приложению А — заглавными буквами, кроме «им.»
// (оставлено в строчной форме как в оригинале).
#let default-organization = (
  preamble: "федеральное государственное бюджетное образовательное учреждение высшего образования",
  full: "НАЦИОНАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ МОРДОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ им. Н.П. ОГАРЁВА",
  short: "ФГБОУ ВО «МГУ им. Н.П. Огарёва»",
)

#let structural-headings = (
  contents: [Содержание],
  intro: [Введение],
  conclusion: [Заключение],
  references: [Список использованных источников],
  abbreviations: [Перечень сокращений и обозначений],
  terms: [Термины и определения],
)
