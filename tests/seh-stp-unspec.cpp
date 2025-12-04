#include "gtest_like_c.h"

__attribute__((optimize("O2")))
static int fn6(int* v1, int* v2, int* v3, int* v4, int* v5, int* v6)
{
    register int v13 asm("x20") = *v1;
    register int v14 asm("x27") = *v2;
    if (v13 != v14)
      return 1;

    register int v15 asm("x23") = *v3;
    register int v16 asm("x24") = *v4;
    v15 += 1;
    v16 += 2;
    if (v15 == v16)
      throw (unsigned) 1;

    register int v17 asm("x21") = *v5;
    register int v18 asm("x22") = *v6;
    v15 += 1;
    v16 += 2;
    if (v15 != v16)
      throw (unsigned) 1;

    return 0;
}

static int fn5()
{
  try
  {
    int value4 = 0xC0DE3;
    fn6(&value4, &value4, &value4, &value4, &value4, &value4);
  }
  catch(unsigned) {
  }

  return 0;
}

static void test_seh_stp_unspec(void)
{
  register int value asm("x24") = 0xC0DE2;
  ASSERT_EQ(value, 0xC0DE2);
  fn5();
  ASSERT_EQ(value, 0xC0DE2);
}

extern "C" {

    TEST(Aarch64MinGW, SEHSTPUnspec)
    {
        test_seh_stp_unspec();
    }
}
