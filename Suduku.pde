//Suduku
import android.os.Environment;

char[][] board;
boolean[][] canEdit = new boolean[9][9];

float centerX, centerY, gridSize;
final int GRID_SIZE = 9;
float cellSize;
int edge = 0;
float cellHalf;
float bottomOffset;
int selectedRow = -1;
int selectedCol = -1;
char cur = '.';
String statusMessage = "";
boolean keyboard = false;

void setup() {
    fullScreen();
    orientation(PORTRAIT);
    String[] lines = loadStrings("board.txt");
  
    // make 9x9 board
    board = new char[9][9];
  
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          char c = lines[i].charAt(j);
          board[i][j] = c;
          if (c == '.') canEdit[i][j] = true;
        }
    }
    gridSize = min(width, height) - edge;
    centerX = width/2;
    centerY = height/2;
    cellSize = gridSize / GRID_SIZE;
    cellHalf = cellSize / 2;       // for centering text
    bottomOffset = gridSize/2;     // for selection row under grid
    
    background(200);
    textSize(50);
}

void draw() {
    background(200);
    noStroke();
    textAlign(CENTER, CENTER);

    // highlight selected cell (under everything so text draws on top)
    highlightSelectedCell();

    // draw numbers and clue shading
    drawNum();

    // draw grid lines on top
    drawGrid();


    // status message
    fill(0);
    textSize(40);
    text(statusMessage, width/10, centerY - gridSize/2 - cellSize/2);
}

void drawGrid() {
    stroke(0);
    for (int i = 0; i <= GRID_SIZE; i++) {
        int weight = (i % 3 == 0) ? 3 : 1;
        strokeWeight(weight);
        float x = (centerX - gridSize/2.0) + i*cellSize;
        line(x, centerY - gridSize/2.0, x, centerY + gridSize/2.0);
        float y = (centerY - gridSize/2.0) + i*cellSize;
        line(centerX - gridSize/2.0, y, centerX + gridSize/2.0, y);
    }
}

void drawNum() {
    textSize(50);
    for (int row = 0; row < GRID_SIZE; row++) {
        for (int col = 0; col < GRID_SIZE; col++) {
            float cx = centerX - gridSize/2 + col*cellSize + cellHalf;
            float cy = centerY - gridSize/2 + row*cellSize + cellHalf;
            
            if (!canEdit[row][col] && (selectedRow != row || selectedCol != col)) {
                fill(180);
                rect(cx - cellHalf, cy - cellHalf, cellSize, cellSize);
            }
            if (board[row][col] != '.') {
                fill(0);
                text(board[row][col], cx, cy);
            }
        }
    }
}

void highlightSelectedCell() {
    if (selectedRow != -1 && selectedCol != -1) { 
        fill(255);
        rect(centerX - gridSize/2 + selectedCol*cellSize,
             centerY - gridSize/2 + selectedRow*cellSize,
             cellSize, cellSize);
    }
}

void mousePressed() {
    float left = centerX - gridSize/2.0;
    float top = centerY - gridSize/2.0;

    // inside Sudoku grid
    if (mouseX > left && mouseX < left + gridSize &&
        mouseY > top && mouseY < top + gridSize) {
        
        // compute row, col
        int col = (int)((mouseX - left) / cellSize);
        int row = (int)((mouseY - top) / cellSize);

        // set selection
        selectedRow = row;
        selectedCol = col;

        if (!keyboard) {
            openKeyboard();
            keyboard = true;
        }
        return;
    }
}

void keyPressed() {
    // check if a cell is selected
    if (selectedRow >= 0 && selectedCol >= 0) {
        // check if the cell is editable (true means editable)
        if (canEdit[selectedRow][selectedCol]) {
            // numeric keys (both main row and numpad)
            if ((key >= '1' && key <= '9')) {
                char tried = key;
                char prev = board[selectedRow][selectedCol];
                board[selectedRow][selectedCol] = tried;
                if (isValidSudoku(board)) {
                    statusMessage = "Okay :)";
                } else {
                    board[selectedRow][selectedCol] = prev; // revert
                    statusMessage = "Not Okay :(";
                }
                // deselect after attempt
                selectedRow = -1;
                selectedCol = -1;
            } else if (key == BACKSPACE || key == DELETE || key == ' ') {
                board[selectedRow][selectedCol] = '.';
                statusMessage = "Cleared";
                selectedRow = -1;
                selectedCol = -1;
            }
        } else {
            statusMessage = "Cell not editable";
            selectedRow = -1;
            selectedCol = -1;
        }
        closeKeyboard();
        keyboard = false;
    }
}


boolean isValidSudoku(char[][] arr) {
    // check rows and cols
    for (int i = 0; i < GRID_SIZE; i++) {
        boolean[] row = new boolean[10];
        boolean[] col = new boolean[10];
        for (int j = 0; j < GRID_SIZE; j++) {
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
    for (int boxRow = 0; boxRow < GRID_SIZE; boxRow += 3) {
        for (int boxCol = 0; boxCol < GRID_SIZE; boxCol += 3) {
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