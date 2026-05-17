// Внутренние хелперы для форм-приложений к отчёту о практике
// (титульный лист, задание, дневник, анкета, отзыв).
//
// Эти функции не реэкспортируются в публичный API пакета — они
// используются только внутри `src/practice/*.typ`.

#import "../utils.typ": nbsp-name

// Подпись 9 pt по центру под линией заполнения.
#let small-label(body) = align(center, text(size: 9pt, body))

// Ячейка-«линия» под значением: бокс c нижней границей.
//
// Логика выравнивания: если значение по своей естественной ширине
// помещается в одну строку — центрируем (как «впечатанное» в бланк);
// если оно длиннее ширины бокса и будет переноситься — оставляем
// левое выравнивание, чтобы перенос начинался от левого края, а не
// болтался по центру.
#let underlined-box(value, width: 100%) = box(
  width: width,
  stroke: (bottom: 0.5pt),
  inset: (bottom: 3pt),
  outset: 0pt,
  if value == none {
    sym.zws
  } else {
    layout(size => {
      let m = measure(value)
      if m.width <= size.width {
        align(center, value)
      } else {
        value
      }
    })
  },
)

// Гибкая «линия-заполнитель»: пустой инлайн-бокс шириной `1fr`, который
// раскрывается до правого края своей визуальной строки.
//
// `baseline: 2pt` сдвигает baseline бокса на 2 pt вниз от baseline текста;
// нижняя граница пустого (height: 0pt) бокса оказывается на Y = baseline + 2pt,
// что точно совпадает с положением `underline(offset: 2pt)`. Подчёркивание
// текста значения и заполнитель образуют одну непрерывную линию.
#let _fill-line = box(
  width: 1fr,
  height: 0pt,
  baseline: 2pt,
  stroke: (bottom: 0.5pt),
)

// Поле формы: «Название значение__________» — значение подчёркивается,
// после значения линия тянется до правого края, под значением по центру —
// 9 pt подпись-комментарий.
//
// Реализация — без `measure`/`place`/`layout`, на штатных примитивах:
// • Имя поля и значение в одном абзаце, переносятся естественно.
// • Значение обёрнуто в `underline(...)` — линия появляется под каждой
//   визуальной строкой текста значения.
// • После значения — `_fill-line`, гибкий заполнитель шириной `1fr`,
//   который встаёт на последнюю строку и продлевает линию до правого края.
// • Подпись — следующая строка с `align(center, ...)` и 9 pt.
#let field-line(name, value, label: none) = block(
  width: 100%,
  breakable: false,
  spacing: 0.55em,
)[
  #block(width: 100%)[
    #name #h(0.5em) #if value != none {
      underline(stroke: 0.5pt, evade: false, offset: 2pt, value)
    } #_fill-line
  ]
  #if label != none {
    v(2pt, weak: false)
    small-label(label)
  }
]

// Подпись (signature row): «Должность ____подпись____ И.О. Фамилия».
// Имя/должность выровнены по нижней линии (с подписью на месте).
#let sign-line(position, name) = {
  let pos-cell = if position == none { [] } else { position }
  let name-cell = if name == none { [] } else { nbsp-name(name) }
  block(width: 100%, breakable: false, spacing: 0.55em)[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.8em,
      row-gutter: 3pt,
      align: (left + bottom, center + bottom, left + bottom),
      pos-cell, underlined-box(none), name-cell,
      [], small-label[подпись, дата], [],
    )
  ]
}

// Многострочное поле для развёрнутого текстового ответа.
// `lines: N` рисует N горизонтальных линий-«линеек» под значением,
// чтобы у формы было место заполнить от руки.
#let multiline-field(name, value, lines: 2) = block(
  width: 100%,
  breakable: false,
  spacing: 0.4em,
)[
  #context layout(size => {
    let line-h = measure([Xg]).height + 0.55em
    let name-width = measure([#name #h(0.5em)]).width
    block(width: 100%, inset: (top: 0pt, bottom: 0pt))[
      // Первая линия — после имени поля.
      #place(
        top + left,
        dx: name-width,
        dy: line-h - 1pt,
        line(length: size.width - name-width, stroke: 0.5pt),
      )
      // Дополнительные пустые линии на всю ширину для рукописного заполнения.
      #for i in range(2, lines + 1) {
        place(
          top + left,
          dy: i * line-h - 1pt,
          line(length: size.width, stroke: 0.5pt),
        )
      }
      // Само значение — текст значения «затекает» на первую линию.
      // Если значение длинное, оно автоматически переносится на следующие
      // линии, а недостающие отрисовываются пустыми.
      #name #h(0.5em) #if value != none { value } else { sym.zws }
      // Резервируем высоту под `lines` визуальных строк.
      #v(((lines - 1)) * line-h, weak: false)
    ]
  })
]

// Чекбокс «☐» (пустой) / «☑» (отмеченный).
#let checkbox(checked: false) = {
  if checked { sym.ballot.check } else { sym.ballot }
}
