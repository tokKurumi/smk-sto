// Обозначение отчёта о практике по СМК СТО 014–2025 п. 5.6:
//
//   ОП–02069964–В–DD.NN.NN–NN–YYYY
//
// где В — вид практики (У — учебная, П — производственная);
// DD.NN.NN — код направления подготовки/специальности;
// NN — порядковый номер обучающегося по списку из приказа;
// YYYY — четыре цифры года прохождения практики.
//
// Пример из стандарта: «ОП–02069964–У–27.03.01–01–2025».
//
// Код 02069964 — для МГУ им. Н.П. Огарёва; 05121346 — для Рузаевского
// института машиностроения (филиал).

#let practice-report-designation(
  designation,
  default-okpo: "02069964",
  current-year: none,
) = {
  if designation == none { return none }
  if type(designation) == str { return designation }
  if type(designation) == dictionary {
    let kind = designation.at("kind", default: none)
    let direction = designation.at("direction", default: none)
    let variant = designation.at("variant", default: none)
    let year = designation.at("year", default: current-year)
    let okpo = designation.at("okpo", default: default-okpo)
    if type(year) == int { year = str(year) }
    if type(variant) == int { variant = str(variant) }
    if type(variant) == str and variant.len() == 1 { variant = "0" + variant }
    let parts = ("ОП", okpo, kind, direction, variant, year)
      .filter(p => p != none)
    return parts.join("–")
  }
  panic("Некорректный тип поля designation: ожидалась строка или словарь")
}
