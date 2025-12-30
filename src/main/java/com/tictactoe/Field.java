package com.tictactoe;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Field {
    private final Map<Integer, Sign> field;
    private List<Integer> winnerOffsets;

    public Field() {
        field = new HashMap<>();
        field.put(0, Sign.EMPTY);
        field.put(1, Sign.EMPTY);
        field.put(2, Sign.EMPTY);
        field.put(3, Sign.EMPTY);
        field.put(4, Sign.EMPTY);
        field.put(5, Sign.EMPTY);
        field.put(6, Sign.EMPTY);
        field.put(7, Sign.EMPTY);
        field.put(8, Sign.EMPTY);
    }


    public List<Integer> getWinnerOffsets() {
        return winnerOffsets;
    }

    public Map<Integer, Sign> getField() {
        return field;
    }

    public int getEmptyFieldIndex() {
        return field.entrySet().stream()
                .filter(e -> e.getValue() == Sign.EMPTY)
                .map(Map.Entry::getKey)
                .findFirst().orElse(-1);
    }

    public List<Sign> getFieldData() {
        return field.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(Map.Entry::getValue)
                .collect(Collectors.toList());
    }

    public Sign checkWin() {
        List<List<Integer>> winPossibilities = List.of(
                List.of(0, 1, 2),
                List.of(3, 4, 5),
                List.of(6, 7, 8),
                List.of(0, 3, 6),
                List.of(1, 4, 7),
                List.of(2, 5, 8),
                List.of(0, 4, 8),
                List.of(2, 4, 6)
        );

        for (List<Integer> winPossibility : winPossibilities) {
            Sign firstSign = field.get(winPossibility.get(0));
            // Проверяем, что ячейка не пустая и все три знака в ряду совпадают
            if (firstSign != Sign.EMPTY
                    && firstSign == field.get(winPossibility.get(1))
                    && firstSign == field.get(winPossibility.get(2))) {

                // Сохраняем выигрышные индексы перед возвратом
                this.winnerOffsets = winPossibility;
                return firstSign;
            }
        }
        return Sign.EMPTY;
    }
}