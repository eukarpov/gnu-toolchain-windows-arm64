#include "gtest_like_c.h"

#pragma GCC push_options
#pragma GCC optimize ("O0")

static void fn4()
{
  register double value asm("d12") = 105;
  ASSERT_EQ(value, 105);
  throw (unsigned) 0x1CE;
}

static void fn3()
{
  register double value asm("d9") = 103;
  register double value2 asm("d12") = 104;
  ASSERT_EQ(value, 103);
  ASSERT_EQ(value2, 104);

  try
  {
    fn4();
  }
  catch(unsigned e)
  {
    ASSERT_EQ(value, 103);
    ASSERT_EQ(value2, 104);
  }
}

static void fn2()
{
  register int value asm("x25") = 0xC0DE3;
  ASSERT_EQ(value, 0xC0DE3);
  throw (unsigned) 0x1CE;
}

static void fn1()
{
  register int value asm("x25") = 0xC0DE2;
  ASSERT_EQ(value, 0xC0DE2);

  try
  {
    fn2();
  }
  catch(unsigned e)
  {
    ASSERT_EQ(value, 0xC0DE2);
  }
}

void test_seh_stp_not_consecutive(void)
{
  register int value asm("x20") = 0xC0DE1;
  ASSERT_EQ(value, 0xC0DE1);
  fn1();
  ASSERT_EQ(value, 0xC0DE1);

  register double value2 asm("d9") = 101;
  register double value3 asm("d12") = 102;
  ASSERT_EQ(value2, 101);
  ASSERT_EQ(value3, 102);
  fn3();
  ASSERT_EQ(value2, 101);
  ASSERT_EQ(value3, 102);
}

#pragma GCC pop_options

extern "C" {

    TEST(Aarch64MinGW, SEHSTPNonconsecutive)
    {
        test_seh_stp_not_consecutive();
    }
}
