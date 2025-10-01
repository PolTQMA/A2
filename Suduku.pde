//Suduku
import android.os.Environment;

char[][] board;
boolean[][] canEdit = new boolean[9][9];

float centerX, centerY, gridSize;
final int GRID_SIZE = 9;
float cellSize;
int edge = 50;
float cellHalf;
float bottomOffset;
int selectedRow = -1;
int selectedCol = -1;
char cur = '.';

void setup() {
    fullScreen();
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
    centerY = gridSize/2 + edge/2;
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
    drawNum();
    highlightSelectedCell();
    stroke(0);
    fill(0);
    drawGrid();
    drawSelectionRow();
    text("Stage: " + isValidSudoku(board), width/2, height - 30);
}

void drawGrid() {
    for (int i = 0; i < GRID_SIZE + 1; i++) {
        int weight = (i % 3 == 0) ? 3 : 1;
        strokeWeight(weight);
        line((centerX-gridSize/2)+(i*cellSize), (centerY-gridSize/2), (centerX-gridSize/2)+(i*cellSize), (centerY+gridSize/2));
        line((centerX-gridSize/2), (centerY-gridSize/2)+(i*cellSize), (centerX+gridSize/2), (centerY-gridSize/2)+(i*cellSize));
    }
}

void drawNum() {
    for (int row = 0; row < GRID_SIZE; row++) {
        for (int col = 0; col < GRID_SIZE; col++) {
            float cx = centerX - gridSize/2 + col*cellSize + cellHalf;
            float cy = centerY - gridSize/2 + row*cellSize + cellHalf;
            
            if (!canEdit[row][col]) {
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

void drawSelectionRow() {
    strokeWeight(1);
    line(centerX - gridSize/2, centerY + bottomOffset, centerX + gridSize/2, centerY + bottomOffset);
    line(centerX - gridSize/2, centerY + bottomOffset + cellSize, centerX + gridSize/2, centerY + bottomOffset + cellSize);
    line(centerX - gridSize/2, centerY + bottomOffset + 2*cellSize, centerX + gridSize/2, centerY + bottomOffset + 2*cellSize);
    line(centerX - gridSize/2, centerY + bottomOffset, centerX - gridSize/2, centerY + bottomOffset + 2*cellSize);
    line(centerX - gridSize/2 + 9*cellSize, centerY + bottomOffset, centerX - gridSize/2 + 9*cellSize, centerY + bottomOffset + 2*cellSize);
    for (int i = 0; i < GRID_SIZE; i++) {
        float cx = centerX - gridSize/2 + i*cellSize + cellHalf;
        float cy = centerY + bottomOffset + cellHalf;
        text(i+1, cx, cy);
        line(centerX - gridSize/2 + i*cellSize, centerY + bottomOffset, centerX - gridSize/2 + i*cellSize, centerY + bottomOffset + cellSize);
    }
    text('X', centerX, centerY + bottomOffset + cellSize + cellHalf);
    line(centerX - gridSize/2 + GRID_SIZE*cellSize, centerY + bottomOffset, centerX - gridSize/2 + GRID_SIZE*cellSize, centerY + bottomOffset + cellSize);
}

void highlightSelectedCell() {
    if (selectedRow != -1 && selectedCol != -1) { 
        fill(0, 0, 255, 100);
        rect(centerX - gridSize/2 + selectedRow*cellSize,
             centerY - gridSize/2 + selectedCol*cellSize,
             cellSize, cellSize);
    }
}

void mousePressed() {
    // inside Sudoku grid
    if (mouseX > centerX - gridSize/2 && mouseX < centerX + gridSize/2 &&
        mouseY > centerY - gridSize/2 && mouseY < centerY + gridSize/2) {
        
        // pick cell
        selectedRow = (int)((mouseX - (centerX - gridSize/2)) / cellSize);
        selectedCol = (int)((mouseY - (centerY - gridSize/2)) / cellSize);
    }
    
    // inside number selection row (1–9)
    else if (mouseY > centerY + bottomOffset && 
             mouseY < centerY + bottomOffset + cellSize) {
        
        int index = (int)((mouseX - (centerX - gridSize/2)) / cellSize);
        
        if (index >= 0 && index < GRID_SIZE) {
            cur = (char)('1' + index);  // set current number
        }

        // update board if a cell is selected and editable
        if (selectedRow != -1 && selectedCol != -1 && canEdit[selectedCol][selectedRow]) {
            board[selectedCol][selectedRow] = cur;
            selectedRow = -1;
            selectedCol = -1;
        }
    }

    // inside "X" row (clear)
    else if (mouseY > centerY + bottomOffset + cellSize && 
             mouseY < centerY + bottomOffset + 2*cellSize) {
        
        cur = '.';  // clear value

        // update board if a cell is selected and editable
        if (selectedRow != -1 && selectedCol != -1 && canEdit[selectedCol][selectedRow]) {
            board[selectedCol][selectedRow] = cur;
            selectedRow = -1;
            selectedCol = -1;
        }
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