//Suduku
import android.os.Environment;

char[][] board;
boolean[][] changed = new boolean[9][9];

int x, y, s;
int rows = 9, cals = 9;
int hilightX, hilightY;
int edge = 100;
int adjust1, adjust2;
char cur = '.';

void setup() {
    fullScreen();
    String[] lines = loadStrings("board.txt");
  
    // make 9x9 board
    board = new char[9][9];
  
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          board[i][j] = lines[i].charAt(j);
        }
    }
    
    s = min(width, height) - edge;
    x = width/2;
    y = s/2 + edge/2;
    adjust1 = s/2 - s/18; //center cell
    adjust2 = s/2 + s/18; //outline grid
    background(150);
}

void draw() {
    if (mousePressed) {
        if (mouseY > y + s/2 && mouseY < y + s/2 + 2*s/9) {
            for (int i = 0; i < 10; i++) {
                if (mouseX > x - adjust2 + i*(s/9) && mouseX < x - adjust2 + (i+1)*(s/9)) {
                    if (i != 9) {
                        cur = char(i + '1');
                    }
                    else
                        cur = '.';
                    }
                }
            }
        
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++){
                if ((mouseY > y - s/2 + i*(s/9) && mouseY < y - s/2 + (i+1)*(s/9)) && mouseX > x - s/2 + j*(s/9) && mouseX < x - s/2 + (j+1)*(s/9)) {
                    if ((cur == '.' && changed[i][j]) || board[i][j] == '.') {
                        board[i][j] = cur;
                        changed[i][j] = true;
                        hilightX = j;
                        hilightY = i;
                    }
                }
            }
        }
    }
    background(150);
    grid(x, y, s);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(50);
    drawNum(x, y, s);
    drawSelection(x, y, s);
    textSize(30);
    text("Selected: " + cur, width/2, height - 50);
    text("Stage: " + isValidSudoku(board), width/2, height - 20);
}

void grid(int x, int y, int s) {
    for (int i = 0; i < rows + 1; i++) {
        if (i % 3 == 0)
            strokeWeight(3);
        line((x-s/2)+(i*s/9), (y-s/2), (x-s/2)+(i*s/9), (y+s/2));
        line((x-s/2), (y-s/2)+(i*s/9), (x+s/2), (y-s/2)+(i*s/9));
        strokeWeight(1);
    }
}

void drawNum(int x, int y, int s) {
    for (int i = 0; i < cals; i++) {
        for (int j = 0; j < rows; j++) {
            if (board[i][j] != '.')
                text(board[i][j], x - adjust1 + (j*s/9), y - adjust1 + (i*s/9));
        }
    }
}

void drawSelection(int x, int y, int s) {
    line(x - adjust2, y + adjust2, x + adjust2, y + adjust2);
    line(x - adjust2, y + adjust2 + s/9, x + adjust2, y + adjust2 + s/9);
    for (int i = 0; i < 9; i++) {
        text(i+1, x - s/2 + (i*s/9), y + s/2 + s/9);
        line(x - adjust2 + (i*s/9), y + adjust2, x - adjust2 + (i*s/9), y + adjust2 + s/9);
    }
    text('X', x - s/2 + s, y + s/2 + s/9);
    line(x - adjust2 + s, y + adjust2, x - adjust2 + s, y + adjust2 + s/9);
    
}

void hilight(int row, int cal) {
    fill(0, 0, 200);
    rect(x - s/2 + row*(s/9) + row/3, y - s/2 + cal*(s/9) + cal/3, int(s/9), int(s/9));
}

boolean isValidSudoku(char[][] arr) {
    // check rows and cols
    for (int i = 0; i < cals; i++) {
        boolean[] row = new boolean[10];
        boolean[] col = new boolean[10];
        for (int j = 0; j < rows; j++) {
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
    for (int boxRow = 0; boxRow < rows; boxRow += 3) {
        for (int boxCol = 0; boxCol < cals; boxCol += 3) {
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