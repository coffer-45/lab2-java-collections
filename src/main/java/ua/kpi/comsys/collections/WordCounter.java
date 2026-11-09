package ua.kpi.comsys.collections;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WordCounter {
    private static final Pattern WORD_PATTERN = Pattern.compile("[A-Za-z0-9]+");

    public Map<String, Integer> countWords(List<String> textLines) {
        if (textLines == null) {
            throw new IllegalArgumentException("textLines cannot be null");
        }

        Map<String, Integer> counts = new HashMap<>();
        for (String line : textLines) {
            if (line == null) {
                throw new IllegalArgumentException("textLines cannot contain null");
            }

            Matcher matcher = WORD_PATTERN.matcher(line);
            while (matcher.find()) {
                String word = matcher.group().toLowerCase(Locale.ROOT);
                counts.merge(word, 1, Integer::sum);
            }
        }
        return counts;
    }

    public Set<String> getUniqueWords(List<String> textLines) {
        return new HashSet<>(countWords(textLines).keySet());
    }
}
