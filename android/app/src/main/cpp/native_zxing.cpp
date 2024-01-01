// By https://github.com/zxing-cpp/zxing-cpp

#include "common.h"
#include "zxing-cpp/core/src/ReadBarcode.h"
#include "zxing-cpp/core/src/MultiFormatWriter.h"
#include "zxing-cpp/core/src/BitMatrix.h"
#include "native_zxing.h"
#include "base64.h"
#include "base_resample.h"
// #include "ZXVersion.h" // This file is not existing for iOS

#include <locale>
#include <codecvt>
#include <fstream>
#include <stdarg.h>

using namespace ZXing;

extern "C"
{

void resultToCodeResult(char **code, Result result) {
    if (result.bytes().size() == 0) {
        *code = new char[1];
        *code[0] = '\0';
        return;
    }
    std::string str = Base64::Encode(result.bytes());

    *code = new char[str.size() + 1];
    for (int i = 0; i < str.size(); i++) {
        (*code)[i] = str[i];
    }
    (*code)[str.size()] = '\0';
}

FUNCTION_ATTRIBUTE
char *readBarcode(uint8_t *data, int width, int height, int pixStride,
                  int rowStride) {
    uint8_t *out = new uint8_t[((width * 2 + 2) / 3) * height];
    resizeBilinear(data, out, width, height, (width * 2 + 2) / 3, height);

    ImageView image{out, (width * 2 + 2) / 3, height, ImageFormat::Lum, (width * 2 + 2) / 3, pixStride};
    DecodeHints hints = DecodeHints().setTryHarder(true).setTryRotate(true).setFormats(
            BarcodeFormat::DataMatrix).setTryInvert(true).setReturnErrors(true);
    Result result = ReadBarcode(image, hints);
    delete[] out;

    char *str;
    resultToCodeResult(&str, result);
    return str;
}
}
