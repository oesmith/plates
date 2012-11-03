#include <ccv.h>

int main(int argc, char** argv)
{
  int counter = 0;
  ccv_dense_matrix_t* image = 0;

  ccv_enable_default_cache();

  ccv_read(argv[1], &image, CCV_IO_GRAY | CCV_IO_ANY_FILE);
  if (image != 0)
  {
    ccv_array_t* words = ccv_swt_detect_words(image, ccv_swt_default_params);
    if (words)
    {
      int i;
      for (i = 0; i < words->rnum; i++)
      {
        char filename[256];
        ccv_matrix_t* box = 0;
        ccv_rect_t* rect = (ccv_rect_t*)ccv_array_get(words, i);
        ccv_slice(image, &box, 0, rect->y, rect->x, rect->height, rect->width);
        printf("%d %d %d %d\n", rect->x, rect->y, rect->width, rect->height);
        snprintf(filename, 256, "out-%d.png", ++counter);
        ccv_write(box, filename, NULL, CCV_IO_PNG_FILE, NULL);
      }
    }
    ccv_array_free(words);
  }

  ccv_drain_cache();
  return 0;
}
