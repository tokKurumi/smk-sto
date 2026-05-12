// Стиль документа по СМК СТО 004–2020.

#import "constants.typ": (
  default-font, default-text-size, default-small-size,
  default-indent, default-margin, default-leading, default-spacing,
  structural-headings,
)
#import "utils.typ": table-label

#let structural-titles = structural-headings.values()

#let is-structural-heading(it) = {
  if it.level != 1 { return false }
  if it.numbering != none { return false }
  return it.body in structural-titles
}

#let smk-style(
  text-size: default-text-size,
  small-size: default-small-size,
  indent: default-indent,
  margin: default-margin,
  font: default-font,
  hide-title-page-number: true,
  add-pagebreaks: true,
  body,
) = {
  set page(
    paper: "a4",
    margin: margin,
    numbering: "1",
    number-align: center + bottom,
  )

  set text(
    font: font,
    size: text-size,
    lang: "ru",
    hyphenate: false,
  )

  set par(
    justify: true,
    first-line-indent: (amount: indent, all: true),
    leading: default-leading,
    spacing: default-spacing,
  )

  // Списки по СТО 8.1.5: маркер «–», нумерация «1)», абзацный отступ.
  set list(
    marker: [–],
    indent: indent,
    body-indent: 0.5em,
    spacing: default-leading,
  )
  set enum(
    indent: indent,
    body-indent: 0.5em,
    spacing: default-leading,
    numbering: "1)",
    full: true,
  )

  // Заголовки.
  set heading(numbering: "1.1 ", hanging-indent: 0pt)
  show heading: set text(size: text-size, weight: "bold")
  show heading: it => {
    set par(first-line-indent: 0pt, justify: false)
    let body = it.body
    if it.numbering != none {
      let n = counter(heading).display(it.numbering)
      block(below: default-spacing, above: default-spacing)[
        #h(indent)#n#body
      ]
    } else {
      block(below: default-spacing, above: default-spacing)[#body]
    }
  }

  // Структурные заголовки (Содержание, Введение, ...) — по центру, заглавные,
  // без номера; новый лист.
  show heading.where(level: 1): it => {
    set par(first-line-indent: 0pt, justify: false)
    if is-structural-heading(it) {
      if add-pagebreaks { pagebreak(weak: true) }
      align(center, block(above: default-spacing, below: default-spacing)[
        #upper(it.body)
      ])
    } else {
      if add-pagebreaks { pagebreak(weak: true) }
      let n = counter(heading).display(it.numbering)
      block(above: default-spacing, below: default-spacing)[#h(indent)#n#it.body]
    }
  }

  // Содержание: номер раздела + название с заполнителем-точками + страница.
  // Приложения выводятся как «Приложение А Название».
  show outline: set par(first-line-indent: 0pt)
  set outline(indent: indent, depth: 3, title: structural-headings.contents)
  show outline.entry: it => context {
    let el = it.element
    let is-app = (
      el != none
        and el.func() == heading
        and el.supplement == [Приложение]
        and el.level == 1
    )
    let fill = box(width: 1fr, repeat[.#h(2pt)])
    if is-app {
      let letter = numbering(el.numbering, ..counter(heading).at(el.location()))
      link(el.location(), it.indented(
        [Приложение #letter],
        el.body + h(0.5em) + fill + sym.space + it.page(),
      ))
    } else {
      it
    }
  }

  // Формулы. Ссылки вида «… в формуле (1)…» по СТО 8.4.4.
  set math.equation(numbering: "(1)", supplement: none)
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      let n = numbering(el.numbering, ..counter(math.equation).at(el.location()))
      link(el.location(), n)
    } else {
      it
    }
  }
  show math.equation.where(block: true): it => {
    block(width: 100%, breakable: false)[
      #set align(center)
      #it
    ]
  }

  // Рисунки. По СТО разделитель — тире «–» с пробелами.
  set figure.caption(separator: [ – ])
  show figure.caption: set par(first-line-indent: 0pt, justify: false)
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): set figure.caption(position: bottom)
  show figure.where(kind: image): set align(center)

  // Таблицы: подпись «Таблица N — ...» слева, сверху, с разрядкой буквы.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set align(left)
  show figure.where(kind: table): set block(breakable: true)
  show figure.caption.where(kind: table): it => context {
    set par(first-line-indent: 0pt, justify: false)
    let num = numbering(
      it.numbering,
      ..counter(figure.where(kind: table)).at(it.location()),
    )
    table-label(num: num, caption: it.body)
  }

  // Кавычки — ёлочки.
  set smartquote(quotes: (single: "‹›", double: "«»"))

  // Ссылки внутри документа.
  set ref(supplement: none)

  // Скрыть номер на первой странице (титульный лист).
  set page(footer: context {
    let p = counter(page).get().first()
    if p == 1 and hide-title-page-number {
      []
    } else {
      align(center)[#counter(page).display("1")]
    }
  })

  body
}
