// Обозначение лабораторной работы по СМК СТО 004–2020 п. 8.1.12:
//
//   ЛР–02069964–DDD–NN–YY
//
// где DDD — код направления подготовки, NN — номер/вариант ЛР,
// YY — две последние цифры года.

#let lab-report-designation(designation, default-okpo: "02069964", current-year: none) = {
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
