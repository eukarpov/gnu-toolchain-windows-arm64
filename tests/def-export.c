/* Creating a DLL with functions exported using in a .def file.  */

int __cdecl fn_def(int a, int b)
{
  return a + b;
}

int __stdcall fn_std_def(int a, int b)
{
  return a + b;
}

void fn_not_def_exported() {
}
