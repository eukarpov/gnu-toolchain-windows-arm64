/* Creating a DLL with functions exported using __declspec(dllexport).  */

__declspec(dllexport) int __cdecl fn_export(int a, int b)
{
  return a + b;
}

__declspec(dllexport) int __stdcall fn_std_export(int a, int b)
{
  return a + b;
}
