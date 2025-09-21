//Suduku
import interfascia.*;

char[][] board = {
    {'5','3','.','.','7','.','.','.','.'},
    {'6','.','.','1','9','5','.','.','.'},
    {'.','9','8','.','.','.','.','6','.'},
    {'8','.','.','.','6','.','.','.','3'},
    {'4','.','.','8','.','3','.','.','1'},
    {'7','.','.','.','2','.','.','.','6'},
    {'.','6','.','.','.','.','2','8','.'},
    {'.','.','.','4','1','9','.','.','5'},
    {'.','.','.','.','8','.','.','7','9'}
};

void setup() {
    size(800, 800);
    background(150);
    grid(400, 300, 500);
    fill(0);
    textSize(20);
    drawNum(x-4, y+6, s);
    drawSelection(x-4, y, s);
    text("Valid: " + isValidSudoku(board), 5, height - 10);
}

void grid(int x, int y, int s) {
    int i = 0;
    while (i < 10) {
        line((x-s/2)+(i*s/9), (y-s/2), (x-s/2)+(i*s/9), (y+s/2));
        line((x-s/2), (y-s/2)+(i*s/9), (x+s/2), (y-s/2)+(i*s/9));
        if (i % 3 == 0) {
            line((x-s/2)+(i*s/9)+1, (y-s/2), (x-s/2)+(i*s/9)+1, (y+s/2));
            line((x-s/2)+(i*s/9)-1, (y-s/2), (x-s/2)+(i*s/9)-1, (y+s/2));
            line((x-s/2), (y-s/2)+(i*s/9)+1, (x+s/2), (y-s/2)+(i*s/9)+1);
            line((x-s/2), (y-s/2)+(i*s/9)-1, (x+s/2), (y-s/2)+(i*s/9)-1);
        }
        i++;
    }
}

void drawNum(int x, int y, int s) {
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (board[i][j] != '.')
                text(board[i][j], x - s/2 + s/18 + (j*s/9), y - s/2 + s/18 + (i*s/9));
        }
    }
}

void drawSelection(int x, int y, int s) {
    line();
    for (int i = 0; i < 9; i++) {
        text(i+1, x - s/2 + s/18 + (i*s/9), y + s/2 + s/9);
    }
}

boolean isValidSudoku(char[][] arr) {
    // check rows and cols
    for (int i = 0; i < 9; i++) {
        boolean[] row = new boolean[10];
        boolean[] col = new boolean[10];
        for (int j = 0; j < 9; j++) {
            // check row
            if (arr[i][j] != '.') {
                int num = arr[i][j] - '0';
                if (row[num]) return false;
                row[num] = true;
            }
            // check col
            if (arr[j][i] != '.') {
                int num = arr[j][i] - '0';
                if (col[num]) return false;
                col[num] = true;
            }
        }
    }

    // check 3x3 boxes
    for (int boxRow = 0; boxRow < 9; boxRow += 3) {
        for (int boxCol = 0; boxCol < 9; boxCol += 3) {
            boolean[] box = new boolean[10];
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    char c = arr[boxRow + i][boxCol + j];
                    if (c != '.') {
                        int num = c - '0';
                        if (box[num]) return false;
                        box[num] = true;
                    }
                }
            }
        }
    }
    return true;
}



