void setup() {
    size(800, 800);
    grid(400, 400, 700);
}

void grid(int x, int y, int s) {
    int i = 0;
    while (i < 10) {
        line((x-s/2)+(i*s/9), (y-s/2), (x-s/2)+(i*s/9), (y+s/2));
        line((x-s/2), (y-s/2)+(i*s/9), (x+s/2), (y-s/2)+(i*s/9));
        i++;
    }
}