// Титульный лист отчёта о практике.
// Форма — Приложение В к СМК СТО 014–2025.

#import "../constants.typ": (
  default-city, default-ministry, default-organization, default-okpo,
)
#import "designation.typ": practice-report-designation
#import "form-helpers.typ": small-label, underlined-box, field-line, sign-line

#let practice-report-title-page(
  ministry: default-ministry,
  organization: default-organization,
  institute: none,
  department: none,
  kind: none,            // строка: «учебной» / «производственной» (в форме «по __ практике»)
  practice-type: none,   // строка: тип в соответствии с ОПОП ВО
  // Обращение к обучающемуся: для стандартной формы — «Обучающийся(аяся)»;
  // для распространённого варианта факультета — «студента» / «студентки» и т. п.
  student-prefix: "Обучающийся(аяся)",
  author: none,          // dict (name, course, group) или строка-имя
  direction: none,       // dict (code, name) или строка целиком
  profile: none,
  location: none,
  period: none,          // dict (start, end) или строка
  designation: none,
  supervisor-org: none,  // dict (name, position, org)
  supervisor-uni: none,  // dict (name, position, org)
  defense: none,         // dict (mark, date) — обычно остаются пустыми
  city: default-city,
  year: auto,
) = {
  if year == auto {
    year = int(datetime.today().display("[year]"))
  }

  let org = if type(organization) == str {
    (preamble: none, full: organization, short: none)
  } else if type(organization) == dictionary {
    (
      preamble: organization.at("preamble", default: none),
      full: organization.at("full", default: none),
      short: organization.at("short", default: none),
    )
  } else {
    panic("Некорректный тип поля organization")
  }

  let author-rec = if type(author) == str {
    (name: author, course: none, group: none)
  } else if type(author) == dictionary {
    author
  } else if author == none {
    (name: none, course: none, group: none)
  } else {
    panic("Некорректный тип поля author")
  }

  let dir-str = if type(direction) == str {
    direction
  } else if type(direction) == dictionary {
    let code = direction.at("code", default: none)
    let name = direction.at("name", default: none)
    if code != none and name != none {
      [#code #name]
    } else if code != none { [#code] } else if name != none { [#name] } else { none }
  } else if direction == none {
    none
  } else {
    panic("Некорректный тип поля direction")
  }

  let period-str = if type(period) == str {
    period
  } else if type(period) == dictionary {
    let s = period.at("start", default: none)
    let e = period.at("end", default: none)
    if s != none and e != none { [#s – #e] }
    else if s != none { [#s] }
    else if e != none { [#e] }
    else { none }
  } else if period == none {
    none
  } else {
    panic("Некорректный тип поля period")
  }

  let sup-org = if type(supervisor-org) == dictionary {
    supervisor-org
  } else if supervisor-org == none {
    none
  } else {
    panic("Некорректный тип поля supervisor-org")
  }

  let sup-uni = if type(supervisor-uni) == dictionary {
    supervisor-uni
  } else if supervisor-uni == none {
    (name: none, position: none, org: none)
  } else {
    panic("Некорректный тип поля supervisor-uni")
  }

  let defense-rec = if type(defense) == dictionary {
    defense
  } else if defense == none {
    (mark: none, date: none)
  } else {
    panic("Некорректный тип поля defense")
  }

  let desig = practice-report-designation(
    designation,
    default-okpo: default-okpo,
    current-year: year,
  )

  // Локальные хелперы рендеринга вынесены в `form-helpers.typ` —
  // они переиспользуются формами Б / Г / Д / Ж.

  // --- Собственно вёрстка ----------------------------------------------

  set par(
    justify: false,
    first-line-indent: 0pt,
    leading: 0.55em,
    spacing: 0.5em,
  )
  set text(size: 14pt)
  set align(center)

  // Шапка университета.
  block(spacing: 0.65em)[#ministry]
  v(0.6em)
  if org.preamble != none {
    block(spacing: 0.65em)[#org.preamble]
  }
  if org.full != none {
    block(spacing: 0.65em)[«#org.full»]
  }
  if org.short != none {
    block(spacing: 0.65em)[(#org.short)]
  }

  v(0.8em)

  if institute != none {
    block(spacing: 0.65em)[#institute]
    v(0.3em)
  }
  if department != none {
    block(spacing: 0.65em)[#department]
  }

  v(1.2em)

  // Тип документа: «ОТЧЁТ / по __вид__ практике / __тип__».
  block(spacing: 0.65em)[#upper[Отчёт]]

  v(0.2em)

  // «по [учебной] практике» с подписью «вид практики».
  // Блок центрируется и сужен — линия не на всю ширину страницы.
  align(center, block(width: 60%, breakable: false, spacing: 0.4em)[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.5em,
      row-gutter: 3pt,
      align: (right + bottom, center + bottom, left + bottom),
      [по],
      underlined-box(if kind != none { [#kind] } else { none }),
      [практике],
      [], small-label[вид практики], [],
    )
  ])

  // «[ознакомительная]» с подписью «Тип практики в соответствии с ОПОП ВО».
  align(center, block(width: 50%, spacing: 0.4em)[
    #grid(
      columns: 1fr,
      row-gutter: 3pt,
      underlined-box(if practice-type != none { [#practice-type] } else { none }),
      small-label[Тип практики в соответствии с ОПОП ВО],
    )
  ])

  v(0.3em)

  // «студентки/студента/Обучающийся 1 курса 101М группы».
  let course = author-rec.at("course", default: none)
  let group = author-rec.at("group", default: none)
  if course != none or group != none {
    let course-str = if course != none {
      if type(course) == int { str(course) } else { course }
    } else { "___" }
    let group-str = if group != none { group } else { "___" }
    block(spacing: 0.65em)[#student-prefix #course-str курса #group-str группы]
  }

  v(0.4em)

  // Левый блок с полями формы.
  set align(left)

  field-line(
    [Направление подготовки / Специальность],
    dir-str,
    label: [код, наименование направления подготовки/специальности],
  )

  field-line([Профиль / Специализация], profile)

  field-line(
    [Место прохождения практики],
    location,
    label: [населённый пункт, профильная организация, структурное подразделение],
  )

  field-line(
    [Срок прохождения практики],
    period-str,
    label: [начало (дата) – окончание (дата)],
  )

  v(0.2em)

  sign-line([Автор отчёта], author-rec.at("name", default: none))

  if desig != none {
    v(0.2em)
    block(width: 100%)[Обозначение отчёта: #desig]
  }

  // Руководитель от профильной организации (опционально).
  if sup-org != none {
    v(0.4em)
    let pos = sup-org.at("position", default: none)
    let org-name = sup-org.at("org", default: none)
    let org-part = if org-name != none { [ #org-name] } else { [ профильной организации] }
    block(width: 100%, spacing: 0.3em)[Руководитель практики]
    block(width: 100%, spacing: 0.3em)[от#org-part,]
    sign-line(pos, sup-org.at("name", default: none))
  }

  // Руководитель от Университета.
  v(0.4em)
  let uni-org = sup-uni.at("org", default: none)
  let uni-org-part = if uni-org != none { uni-org } else { [ФГБОУ ВО «МГУ им. Н.П. Огарёва»] }
  block(width: 100%, spacing: 0.3em)[Руководитель практики]
  block(width: 100%, spacing: 0.3em)[от #uni-org-part,]
  sign-line(
    sup-uni.at("position", default: none),
    sup-uni.at("name", default: none),
  )

  // Поле «Отчёт защищён … дата + Оценка …» — обычно остаётся пустым
  // на печати, заполняется рукописно после защиты (СТО 014–2025 п. 5.5).
  v(0.4em)
  let mark = defense-rec.at("mark", default: none)
  let date = defense-rec.at("date", default: none)
  block(width: 100%, breakable: false)[
    #grid(
      columns: (auto, 1fr, auto, 1fr),
      column-gutter: 0.8em,
      row-gutter: 3pt,
      align: (left + bottom, center + bottom, left + bottom, center + bottom),
      [Отчёт защищён],
      underlined-box(if date != none { [#date] } else { none }),
      [Оценка],
      underlined-box(if mark != none { [#mark] } else { none }),
      [], small-label[дата], [], [],
    )
  ]

  v(1fr)

  set align(center)
  block[#city #year]
}
