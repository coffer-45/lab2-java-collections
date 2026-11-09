#set page(
  paper: "a4",
  margin: (left: 2.2cm, right: 1.8cm, top: 1.8cm, bottom: 1.8cm),
  numbering: none,
)
#set text(font: "New Computer Modern", lang: "uk", size: 11.5pt)
#set par(justify: true, leading: 0.65em, first-line-indent: 1.25cm)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => block(above: 1em, below: 0.5em)[
  #set text(size: 14pt, weight: "bold")
  #it
]
#show heading.where(level: 2): it => block(above: 0.7em, below: 0.35em)[
  #set text(size: 12.5pt, weight: "bold")
  #it
]
#let noindent(body) = par(first-line-indent: 0pt, body)

// Титульний аркуш оформлено за зразком лабораторної роботи №1.
#set par(first-line-indent: 0pt, justify: false)
#align(center)[
  #image("letterhead.png", width: 68%)
  #v(0.35cm)
  #text(size: 14pt)[Національний технічний університет України] \
  #text(size: 14pt)[«Київський політехнічний інститут імені Ігоря Сікорського»]
  #v(0.4cm)
  #text(size: 13pt)[Факультет інформатики та обчислювальної техніки] \
  #text(size: 13pt)[Кафедра обчислювальної техніки]
]

#v(1fr)
#align(center)[
  #text(size: 20pt, weight: "bold")[Технології розробки на платформі Java]
  #v(0.45cm)
  #text(size: 18pt, weight: "bold")[Лабораторна робота №2]
  #v(0.18cm)
  #text(size: 13pt)[«Збірка проєкту за допомогою Gradle та робота з Java Collections Framework»]
]

#v(1fr)
#align(right)[
  #block(width: 8.5cm)[
    #align(left)[
      Виконав: студент 3 курсу ФІОТ, \
      групи ІО-41 \
      #emph[Вовк Андрій Андрійович] \
      Залікова книжка № 4103
    ]
  ]
]

#v(1fr)
#align(center)[Київ --- 2026]

#pagebreak()
#set page(numbering: "1", number-align: center + bottom)
#counter(page).update(1)
#set par(first-line-indent: 1.25cm, justify: true)

= Тема, мета та завдання

#noindent[*Тема:* збірка проєкту за допомогою Gradle та робота з Java Collections Framework.]

#noindent[*Мета:* навчитися налаштовувати збірку Gradle із Version Catalogs, застосовувати стандартні колекції Java для обробки тексту та перевіряти граничні випадки за допомогою юніт-тестів.]

#noindent[*Визначення варіанта:* номер залікової книжки $N = 4103$.]

#align(center)[$ V = N mod 3 = 4103 mod 3 = 2. $]

Для варіанта $V=2$ потрібно створити клас #raw("WordCounter") у пакеті #raw("ua.kpi.comsys.collections"). Метод #raw("countWords(List<String>)") повертає відповідність «слово — кількість входжень», а #raw("getUniqueWords(List<String>)") — множину унікальних слів. Словом вважається послідовність латинських букв і цифр. Слова приводяться до нижнього регістру, порожні фрагменти пропускаються. Якщо список дорівнює #raw("null"), обидва методи повинні кидати #raw("IllegalArgumentException").

= Проєктування та реалізація

Для пошуку слів використано регулярний вираз #raw("[A-Za-z0-9]+") і #raw("Matcher.find()"). Збіг нормалізується через #raw("toLowerCase(Locale.ROOT)"), тому результат не залежить від поточної локалі системи. Кількості зберігаються у #raw("HashMap<String, Integer>") та збільшуються за допомогою #raw("Map.merge()"). Унікальні слова повертаються як окрема множина #raw("HashSet<String>"). Порядок елементів у результатах не визначено і завдання його не вимагає.

#figure(
  table(
    columns: (4.4cm, 9.7cm),
    align: (left, left),
    inset: 5pt,
    stroke: 0.55pt,
    table.header([*Метод*], [*Результат і перевірки*]),
    [#raw("countWords()")], [Повертає #raw("Map<String, Integer>") і підраховує входження слів у всіх рядках.],
    [#raw("getUniqueWords()")], [Повертає #raw("Set<String>") без повторень на основі результату підрахунку.],
    [Обидва методи], [
      #set par(justify: false)
      Для #raw("null")-списку викидають #raw("IllegalArgumentException"). Також відхиляють #raw("null")-рядок у списку.
    ],
  ),
  caption: [Поведінка методів класу WordCounter],
)

Залежності JUnit 5 задано в каталозі версій #raw("gradle/libs.versions.toml"). Файл #raw("build.gradle.kts") використовує Java-плагін, Maven Central, JUnit Platform та JaCoCo для перевірки покриття. Проєкт містить Gradle Wrapper. Для реалізації колекцій застосовано лише класи стандартної бібліотеки #raw("java.util").

#pagebreak()
= Перевірка роботи

Тести JUnit 5 перевіряють обидва методи на кількох рядках, нормалізацію регістру, цифри у словах, розділові знаки, порожній вхід, #raw("null") та незалежність повернутих колекцій. Окремий тест змінює системну локаль і перевіряє, що латинська #raw("I") переходить у #raw("i").

#figure(
  table(
    columns: (6.3cm, 7.8cm),
    align: (left, left),
    inset: 5pt,
    stroke: 0.55pt,
    table.header([*Набір перевірок*], [*Результат*]),
    [#raw("Hello world"), #raw("HELLO, World! hello")], [#raw("hello → 3"), #raw("world → 2")],
    [#raw("One, one; TWO"), #raw("two 3")], [Множина унікальних слів: #raw("{one, two, 3}").],
    [Порожні рядки й лише роздільники], [Результати порожні, порожні слова не з’являються.],
    [Список або його елемент — #raw("null")], [#raw("IllegalArgumentException") для обох методів.],
  ),
  caption: [Приклади та граничні випадки],
)

Команди #raw("./gradlew test") і #raw("./gradlew build") виконано успішно. У звіті Gradle зафіксовано *10 тестів, 0 помилок, 0 пропущених*. JaCoCo показав для #raw("WordCounter") *16 із 16 покритих рядків і 8 із 8 покритих гілок* (100% в обох випадках). Завдання #raw("build") перевіряє цей поріг автоматично; HTML-звіт зберігається в #raw("build/reports/jacoco/test/html/").

Програму, тести, конфігурацію Gradle та інструкцію із запуску опубліковано у відкритому репозиторії: #link("https://github.com/coffer-45/lab2-java-collections")[github.com/coffer-45/lab2-java-collections].

= Висновок

У роботі налаштовано Java-проєкт із Gradle Wrapper і Version Catalogs та реалізовано частотний аналіз слів стандартними колекціями Java. Додано перевірку некоректних даних і JUnit 5 тести. Збірка успішна; клас #raw("WordCounter") має повне покриття рядків і гілок за результатами JaCoCo.
