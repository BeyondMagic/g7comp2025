int sum(int a, int b)
{
  return a + b;
}

int main()
{
  int r = sum(1, 3);
  print_int(r); // assume que o runtime exporta print_int
  return 0;
}
