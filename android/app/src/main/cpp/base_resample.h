#include <stdint.h>

void resizeBilinear(uint8_t *pixels, uint8_t *out, int w1, int h1, int w2, int h2) {
    int a, b, c, d, x, y, index;
    float x_ratio = ((float) (w1 - 1)) / w2;
    float y_ratio = ((float) (h1 - 1)) / h2;
    float x_diff, y_diff;
    int offset = 0;
    for (int i = 0; i < h2; i++) {
        for (int j = 0; j < w2; j++) {
            x = (int) (x_ratio * j);
            y = (int) (y_ratio * i);
            x_diff = (x_ratio * j) - x;
            y_diff = (y_ratio * i) - y;
            index = (y * w1 + x);
            a = pixels[index];
            b = pixels[index + 1];
            c = pixels[index + w1];
            d = pixels[index + w1 + 1];

            // blue element
            // Yb = Ab(1-w1)(1-h1) + Bb(w1)(1-h1) + Cb(h1)(1-w1) + Db(wh)
            out[offset++] = (a * (1 - x_diff) * (1 - y_diff) + b * (x_diff) * (1 - y_diff) +
                   c * (y_diff) * (1 - x_diff) + d * (x_diff * y_diff));
        }
    }
}