//Suduku
char[][] board = {
    {'5','3','0','0','7','0','0','0','0'},
    {'6','0','0','1','9','5','0','0','0'},
    {'0','9','8','0','0','0','0','6','0'},
    {'8','0','0','0','6','0','0','0','3'},
    {'4','0','0','8','0','3','0','0','1'},
    {'7','0','0','0','2','0','0','0','6'},
    {'0','6','0','0','0','0','2','8','0'},
    {'0','0','0','4','1','9','0','0','5'},
    {'0','0','0','0','8','0','0','7','9'}
};

int x, y, s;
char cur = '0';

void setup() {
    fullScreen();
    s = min(width, height)-100;
    x = width/2;
    y = s/2+50;
    background(150);
}

void draw() {
    if (mousePressed) {
        if (mouseY > y + s/2 && mouseY < y + s/2 + 2*s/9) {
            for (int i = 0; i < 10; i++) {
                if (mouseX > x - s/2 + i*(s/9) && mouseX < x - s/2 + (i+1)*(s/9)) {
                    if (i != 9) {
                        cur = char(i + '1');
                    }
                    else
                        cur = '0';
                    }
                }
            }
        
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++){
                if (mouseY > y - s/2 + i*(s/9) && mouseY < y - s/2 + (i+1)*(s/9)) {
                    if (mouseX > x - s/2 + j*(s/9) && mouseX < x - s/2 + (j+1)*(s/9)) {
                        board[i][j] = cur;
                    }
                }
            }
        }
    }
    background(150);
    grid(x, y, s);
    fill(0);
    textSize(50);
    drawNum(x, y, s);
    drawSelection(x, y, s);
    textSize(30);
    text("Selected: " + cur, width/2 - width/6, height - 50);
    text("valid: " + isValidSudoku(board), width/2 - width/6, height - 10);
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
            if (board[i][j] != '0')
                text(board[i][j], x - s/2 + s/18 + (j*s/9) - 12, y - s/2 + s/18 + (i*s/9) + 17);
        }
    }
}

void drawSelection(int x, int y, int s) {
    line(x + s/2, y + s/2 + s/18, x - s/2, y + s/2 + s/18);
    line(x + s/2, y + s/2 + s/18 + s/9, x - s/2, y + s/2 + s/18 + s/9);
    for (int i = 0; i < 9; i++) {
        text(i+1, x - s/2 + s/18 + (i*s/9) - 12, y + s/2 + s/9 + 17);
        line(x - s/2 + (i*s/9), y + s/2 + s/18, x - s/2 + (i*s/9), y + s/2 + s/18 + s/9);
    }
    line(x - s/2 + s, y + s/2 + s/18, x - s/2 + s, y + s/2 + s/18 + s/9);
    text('X', x - s/2 + s/18 + (10*s/9) - 12, y + s/2 + s/9 + 17);
}


boolean isValidSudoku(char[][] arr) {
    // check rows and cols
    for (int i = 0; i < 9; i++) {
        boolean[] row = new boolean[10];
        boolean[] col = new boolean[10];
        for (int j = 0; j < 9; j++) {
            // check row
            if (arr[i][j] != '0') {
                int num = arr[i][j] - '0';
                if (row[num]) return false;
                row[num] = true;
            }
            // check col
            if (arr[j][i] != '0') {
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
                    if (c != '0') {
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