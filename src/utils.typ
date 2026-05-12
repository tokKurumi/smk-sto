// Утилиты: алфавитная нумерация, обозначение ЛР, подпись.

#let cyrillic-letters = (
  "а", "б", "в", "г", "д", "е", "ж", "и", "к", "л",
  "м", "н", "п", "р", "с", "т", "у", "ф", "х", "ц",
  "ч", "ш", "щ", "э", "ю", "я",
)

// Перечисление вида «а)», «б)», ... согласно ГОСТ 2.105 и СТО.
// Буквы «з», «й», «о», «ъ», «ы», «ь» исключены — соответствуют норме.
#let enum-letter(n) = {
  let i = n - 1
  let base = cyrillic-letters.len()
  let s = ""
  if i < 0 { return "" }
  let q = i
  while true {
    s = cyrillic-letters.at(calc.rem(q, base)) + s
    q = calc.floor(q / base)
    if q == 0 { break }
    q -= 1
  }
  s + ")"
}

// Не разбивать ФИО переносом строки.
#let nbsp-name(name) = {
  if name == none { return [] }
  return name.replace(" ", "\u{00A0}")
}

// Поле подписи по Приложению А:
//
//   должность                  ___________________     И.О. Фамилия
//                                  подпись, дата
//
#let sign-field(position, name, line-width: 5cm, hint: "подпись, дата") = {
  set par(justify: false, first-line-indent: 0pt)
  let pos-cell = if position == none { [] } else { position }
  let name-cell = if name == none { [] } else { nbsp-name(name) }
  // Сама подпись: линия сверху и подпись «подпись, дата» под ней.
  let sign-box = box(width: line-width, baseline: 1.0em)[
    #set align(center)
    #v(0.4em, weak: true)
    #line(length: 100%, stroke: 0.5pt)
    #text(size: 0.85em, hint)
  ]
  block(width: 100%, breakable: false, spacing: 0.7em)[
    #pos-cell
    #h(1fr)
    #sign-box
    #h(1fr)
    #name-cell
  ]
}

// Обозначение лабораторной работы: ЛР–02069964–DDD–NN–YY
// designation: либо строка целиком, либо словарь
//   (direction: "27.03.01", variant: "08", year: 24, okpo: "02069964")
#let format-designation(designation, default-okpo: "02069964", current-year: none) = {
  if designation == none { return none }
  if type(designation) == str { return designation }
  if type(designation) == dictionary {
    let direction = designation.at("direction", default: none)
    let variant = designation.at("variant", default: none)
    let year = designation.at("year", default: current-year)
    let okpo = designation.at("okpo", default: default-okpo)
    if type(year) == int { year = str(calc.rem(year, 100)) }
    if type(variant) == int { variant = str(variant) }
    if type(variant) == str and variant.len() == 1 { variant = "0" + variant }
    let parts = ("ЛР", okpo, direction, variant, year).filter(p => p != none)
    return parts.join("–")
  }
  panic("Некорректный тип поля designation: ожидалась строка или словарь")
}

// Разрядка букв «Т а б л и ц а» по СТО 8.6.5 — интервал 1,6 пт.
#let table-label(num: none, caption: none) = {
  set par(first-line-indent: 0pt, justify: false)
  let head = text(tracking: 1.6pt)[Таблица]
  if num != none and caption != none {
    [#head #num – #caption]
  } else if num != none {
    [#head #num]
  } else {
    head
  }
}

// «Продолжение таблицы N» / «Окончание таблицы N» — без разрядки (СТО 8.6.6).
#let table-continuation(num, kind: "Продолжение") = {
  set par(first-line-indent: 0pt, justify: false)
  [#kind таблицы #num]
}
