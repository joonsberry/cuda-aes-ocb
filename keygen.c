#include <stdio.h>
#include <sodium.h>

#define KEY_SIZE 32 // bytes

int main(void) {

  FILE *key_file;
  unsigned char key[KEY_SIZE];

  randombytes_buf(key, KEY_SIZE);

  key_file = fopen("./data/key.txt", "w");

  fprintf(key_file, "%s", key);

  fclose(key_file);

  return 0;
}