#ifdef __cplusplus
extern "C"
{
#endif
#include <stdint.h>

/**
 * @brief Read barcode from image bytes.
 * @param bytes Image bytes.
 * @param format Specify a set of BarcodeFormats that should be searched for.
 * @param width Image width in pixels.
 * @param height Image height in pixels.
 * @param cropWidth Crop width.
 * @param cropHeight Crop height.
 * @param tryHarder Spend more time to try to find a barcode; optimize for accuracy, not speed.
 * @param tryRotate Also try detecting code in 90, 180 and 270 degree rotated images.
 * @return The barcode result.
 */
char* readBarcode(uint8_t* data, int width, int height, int pixStride, int rowStride);

#ifdef __cplusplus
}
#endif