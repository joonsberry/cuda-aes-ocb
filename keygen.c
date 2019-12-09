#include <sys/random.h>
#include <stdio.h>

#define KEY_SIZE 32 // bytes

int main(void) {

  FILE *key_file;
  ssize_t key_size_actual;
  unsigned char key[KEY_SIZE];

  key_size_actual = getrandom(key, KEY_SIZE, NULL);

  if(key_size_actual != KEY_SIZE) {
    printf("System returned insufficient random bytes.\n");
    return 1;
  }

  key_file = fopen("./data/key.txt", "w");

  fprintf(key_file, "%s", key);

  fclose(key_file);

  return 0;
}