package ua.kpi.comsys.collections;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import org.junit.jupiter.api.Test;

class WordCounterTest {
    private final WordCounter counter = new WordCounter();

    @Test
    void countsWordsAcrossLinesIgnoringCase() {
        assertEquals(
                Map.of("hello", 3, "world", 2),
                counter.countWords(List.of("Hello world", "HELLO, World! hello")));
    }

    @Test
    void keepsNumbersAndLettersInTheSameWord() {
        assertEquals(
                Map.of("java21", 2, "42", 1, "r2d2", 1),
                counter.countWords(List.of("Java21 42 R2D2", "java21")));
    }

    @Test
    void splitsOnPunctuationWhitespaceAndNonLatinCharacters() {
        assertEquals(
                Map.of("a", 2, "b", 2, "c", 1, "caf", 1, "2", 1),
                counter.countWords(List.of("a-b_a\tB\nc", "café 2", "...")));
    }

    @Test
    void ignoresEmptyLinesAndSeparatorsWithoutCreatingEmptyWords() {
        assertTrue(counter.countWords(List.of("", " \t", ",.;!", "Україна")).isEmpty());
    }

    @Test
    void returnsEmptyCollectionsForAnEmptyList() {
        assertTrue(counter.countWords(List.of()).isEmpty());
        assertTrue(counter.getUniqueWords(List.of()).isEmpty());
    }

    @Test
    void returnsUniqueNormalizedWords() {
        assertEquals(
                Set.of("one", "two", "3"),
                counter.getUniqueWords(List.of("One, one; TWO", "two 3")));
    }

    @Test
    void doesNotDependOnTheSystemLocale() {
        Locale previous = Locale.getDefault();
        try {
            Locale.setDefault(Locale.forLanguageTag("tr-TR"));
            assertEquals(Map.of("i", 2), counter.countWords(List.of("I i")));
        } finally {
            Locale.setDefault(previous);
        }
    }

    @Test
    void rejectsNullListInBothMethods() {
        assertThrows(IllegalArgumentException.class, () -> counter.countWords(null));
        assertThrows(IllegalArgumentException.class, () -> counter.getUniqueWords(null));
    }

    @Test
    void rejectsNullLineInBothMethods() {
        List<String> lines = java.util.Arrays.asList("valid", null);
        assertThrows(IllegalArgumentException.class, () -> counter.countWords(lines));
        assertThrows(IllegalArgumentException.class, () -> counter.getUniqueWords(lines));
    }

    @Test
    void returnsIndependentCollections() {
        List<String> lines = List.of("first first");
        Map<String, Integer> counts = counter.countWords(lines);
        Set<String> words = counter.getUniqueWords(lines);
        counts.clear();
        words.clear();

        assertEquals(Map.of("first", 2), counter.countWords(lines));
        assertEquals(Set.of("first"), counter.getUniqueWords(lines));
    }
}
