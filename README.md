# Лабораторна робота №2 — Java Collections Framework і Gradle

Проєкт реалізує частотний аналіз тексту (`WordCounter`) за допомогою стандартних колекцій Java. Слова — послідовності латинських літер та цифр; регістр ігнорується. Метод `countWords` повертає кількість входжень кожного слова, а `getUniqueWords` — множину різних слів. Якщо список рядків або будь-який його елемент дорівнює `null`, методи кидають `IllegalArgumentException`.

## Варіант

Номер залікової книжки: **4103**. За формулою `V = N mod 3` отримуємо `4103 mod 3 = 2`, отже завдання — **варіант 2, WordCounter**.

## Запуск

Потрібна встановлена Java (JDK 17 або новіша). Gradle окремо встановлювати не потрібно: проєкт містить Gradle Wrapper.

```bash
./gradlew test
./gradlew build
```

Залежності тестів (JUnit 5) задано через `gradle/libs.versions.toml`. Вихідний код розташований у `src/main/java/ua/kpi/comsys/collections/`, тести — у `src/test/java/ua/kpi/comsys/collections/`.

Команда `./gradlew build` також перевіряє 100% покриття рядків і гілок класу `WordCounter`. HTML-звіт покриття створюється в `build/reports/jacoco/test/html/`.
