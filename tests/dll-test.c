/* Tests using the functions imported from a DLL.  */

#include "gtest_like_c.h"

#include <stdlib.h>
#include <stdio.h>

// Declare imported function.
// These functions were exported from the dll using __declspec( dllexport )
__declspec(dllimport) int __cdecl fn_export(int a, int b);
__declspec(dllimport) int __stdcall fn_std_export(int a, int b);

// These functions were exported via a def file.
int __cdecl fn_def(int a, int b);
int __stdcall fn_std_def(int a, int b);

/* This function was not exported via a .def file.  */
__attribute__((weak)) void fn_not_def_exported();

// call a pointer to a function
int test_func_pointer(int __cdecl (*f)(int, int))
{
  return f(6, 23);
}

// Test calling a DLL with methods exported in different ways
void check_dll()
{
  ASSERT_EQ(fn_export(7, 3), 10);
  ASSERT_EQ(fn_export(7, 3), 10);
  ASSERT_EQ(fn_def(7, 3), 10);
  ASSERT_EQ(fn_std_def(7, 3), 10);
  ASSERT_EQ(test_func_pointer(fn_export), 29);
  ASSERT_EQ(test_func_pointer(fn_def), 29);
  ASSERT_EQ(fn_not_def_exported, NULL);
}

TEST(Aarch64MinGW, DllTest)
{
  check_dll();
}
