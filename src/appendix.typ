// Приложения по СТО 8.5/8.6/8.4: нумерация фигур, таблиц и формул
// относительно буквы приложения (А.1, А.2 и т.п.).

#import "utils.typ": cyrillic-letters

// Буквы для приложений: А, Б, В, Г, Д, Е, Ж, И, К, Л, М, Н, П, Р, С, Т, У, Ф, Х, Ц, Ч, Ш, Щ, Э, Ю, Я.
// Без Ё, З, Й, О, Ъ, Ы, Ь — по ГОСТ Р 7.0.97/2.105.
#let appendix-letters = cyrillic-letters.map(upper)

#let appendix-letter(n) = {
  appendix-letters.at(n - 1)
}

#let appendix-heading-numbering(..nums) = {
  let n = nums.pos()
  appendix-letter(n.first())
}

#let appendix-figure-numbering = it => {
  let h = counter(heading).get().first()
  if h <= 0 { return }
  [#appendix-letter(h).#it]
}

#let appendix-equation-numbering = it => {
  let h = counter(heading).get().first()
  if h <= 0 { return }
  [(#appendix-letter(h).#it)]
}

// Применяется как `#show: appendix` — далее все `= Заголовок` становятся
// приложениями с автоматической буквой.
#let appendix(body) = {
  // Сбросить счётчик заголовков уровня 1 (приложения нумеруются отдельно).
  counter(heading).update(0)
  // Перенумеровать фигуры, таблицы, формулы относительно приложения.
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)

  set heading(numbering: appendix-heading-numbering, supplement: [Приложение])
  show heading.where(level: 1): it => context {
    pagebreak(weak: true)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    set par(first-line-indent: 0pt, justify: false)
    align(center)[
      #block(above: 1.5em, below: 0.5em)[
        Приложение #counter(heading).display(it.numbering)
      ]
      #block(below: 1.5em)[(обязательное)]
      #block(below: 1.5em)[#it.body]
    ]
  }

  set figure(numbering: appendix-figure-numbering)
  set math.equation(numbering: appendix-equation-numbering)

  body
}
