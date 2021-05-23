#include <gtest/gtest.h>


extern "C" {
int _my_strlen(const char *);
void _my_strcpy(char *dst, const char *src, int size);
}


int _my_strlen_assembly_embending(const char *str) {
  if (!str) return 0;
  int res;

  __asm__(
      "mov rax, %1 \n"
      "_testAsm2_loop: \n"
      "    cmpb [rax], 0 \n"
      "    je _testAsm2_loop_ends \n"
      "    inc rax \n"
      "    jmp _testAsm2_loop \n"
      "_testAsm2_loop_ends: \n"
      "sub rax, %1 \n"
      "mov %0, eax\n"
      : "=r"(res)
      : "r"(str)
      : "%rax", "%rdx");

  return res;
}




#define _my_strlen _my_strlen_assembly_embending

TEST(my_strlen, simple) {
  const char *str = "abcdef\ndf";
  EXPECT_EQ(_my_strlen(str), 9);
}

TEST(my_strlen, empty) {
  const char *str = "";
  EXPECT_EQ(_my_strlen(str), 0);
}

TEST(my_strlen, one) {
  const char *str = "a";
  EXPECT_EQ(_my_strlen(str), 1);
}


TEST(my_strlen, nullptr) {
  const char *str = nullptr;
  EXPECT_EQ(_my_strlen(str), 0);
}

TEST(my_strlen, big) {
  int size = 1024 * 64 - 1;
  char *str = new char[size + 1];
  
  for (int i=0; i< size; i++) str[i] = 'a';
  str[size] = '\0';

  EXPECT_EQ(_my_strlen(str), size);

  delete[] str;
}

/*************************************************/

TEST(my_strcpy, simple) {
  char *buffer = new char[255];
  
  const char *str = "some_text";
  _my_strcpy(buffer, str, strlen(str));

  EXPECT_STREQ(str, buffer);
  delete[] buffer;
}

TEST(my_strcpy, big) {
  int size = 1024 * 64 - 1;
  char *str = new char[size + 1];
  char *buffer = new char[size + 1];
  
  for (int i=0; i< size; i++) str[i] = 'a';
  str[size] = '\0';

  _my_strcpy(buffer, str, size);

  EXPECT_STREQ(buffer, str);

  delete[] str;
  delete[] buffer;
}

TEST(my_strcpy, one_symbol) {
  char *buffer = new char[255];
  
  const char *str = "1";
  _my_strcpy(buffer, str, strlen(str));

  EXPECT_STREQ(str, buffer);
  delete[] buffer;
}

TEST(my_strcpy, empty) {
  char *buffer = new char[255];
  
  const char *str = "1";
  _my_strcpy(buffer, str, 0);

  EXPECT_STREQ("", buffer);
  delete[] buffer;
}

TEST(my_strcpy, nullptr_src) {
  char *buffer = new char[1];
  
  _my_strcpy(buffer, nullptr, 0);

  delete[] buffer;
}

TEST(my_strcpy, nullptr_dst) {  
  _my_strcpy(nullptr, "123", 4);
}


TEST(my_strcpy, perekrytie) {  
  char * buffer = new char[16];
  strcpy(buffer, "abcdef");

  _my_strcpy(buffer + 3, buffer, strlen(buffer));
  EXPECT_STREQ(buffer + 3, "abcdef");
  
  delete[] buffer;
}

/**********************/

int main(int argc, char *argv[]) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}