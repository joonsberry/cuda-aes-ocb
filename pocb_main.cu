#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "pocb.cu"

#define KEY_SIZE 32 // bytes
#define NONCE_SIZE 15
#define MESSAGE_MAX 15000

int stringlen(unsigned char *in) {
  int size = 0;

  while(in[size] != '\0') {
    size++;
  }

  size++;

  return size;
}

int main(void) {

  FILE *k_file, *m_file, *c_file, *r_file;
  struct timeval start, end;
  char skey[KEY_SIZE];
  unsigned char snonce[NONCE_SIZE] = "abcdefghijklmn";
  unsigned char *key, *nonce;
  
  
  k_file = fopen("./data/key.txt", "r");
  m_file = fopen("./data/m_file.txt", "r");
  c_file = fopen("./data/c_file.txt", "w");
  r_file = fopen("./data/result.txt", "w");

  fseek(m_file, 0, SEEK_END);
  long fsize = ftell(m_file);
  rewind(m_file);

  unsigned char *message = (unsigned char *)malloc(fsize + 1);
  fread(message, 1, fsize, m_file);

  fgets(skey, KEY_SIZE, k_file);

  int message_size = stringlen(message);

  unsigned char ciphertext[message_size + 16];
  unsigned char result[message_size];

  key = (unsigned char *)skey;
  nonce = (unsigned char *)snonce;

  printf("Key: %s\n", key);
  
  gettimeofday(&start, NULL);

  pocb_encrypt(key, nonce, NONCE_SIZE, message, message_size, ciphertext);
  
  gettimeofday(&end, NULL);
  long seconds = (end.tv_sec - start.tv_sec);
  long micros = ((seconds * 1000000) + end.tv_usec) - (start.tv_usec);
  printf("Total Encryption Time: %d\n", micros);

  printf("Key size: %d\n", stringlen(key));
  printf("Message size: %d\n", message_size);
  printf("Ciphertext size: %d\n", stringlen(ciphertext));
  
  fwrite(ciphertext, 1, sizeof(ciphertext), c_file);

  gettimeofday(&start, NULL);

  pocb_decrypt(key, nonce, NONCE_SIZE, ciphertext, message_size, result);

  gettimeofday(&end, NULL);
  seconds = (end.tv_sec - start.tv_sec);
  micros = ((seconds * 1000000) + end.tv_usec) - (start.tv_usec);
  printf("Total Decryption Time: %d\n", micros);

  printf("Result size: %d\n", stringlen(result));

  fwrite(result, 1, sizeof(result), r_file);

  fclose(k_file);
  fclose(m_file);
  fclose(c_file);
  fclose(r_file);

  return 0;
}