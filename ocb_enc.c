#include <sys/random.h>
#include <stdio.h>
#include "./OCB-AES/ocb.h"

#define KEY_SIZE 32 // bytes
#define NONCE_SIZE 12
#define MESSAGE_MAX 1024

int main(void) {

  FILE *key_file;
  ssize_t nonce_seize_actual;
  unsigned char key[KEY_SIZE];
  unsigned char nonce[NONCE_SIZE];
  unsigned char message[MESSAGE_MAX];
  unsigned char ciphertext[MESSAGE_MAX + 16];

  *message = "Hello, secure world.";

  key_file = fopen("./data/key.txt", "r");

  fgets(key, KEY_SIZE, key_file);

  nonce_size_actual = getrandom(nonce, NONCE_SIZE, NULL);
  
  ocb_encrypt(key, nonce, NONCE_SIZE, message, MESSAGE_MAX, NULL, 0, ciphertext);

  fclose(key_file);

  return 0;
}