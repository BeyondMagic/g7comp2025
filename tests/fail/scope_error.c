int main()
{
  int x = 1;
  {
    int y = 2;
  }
  y = 3; // fora do escopo
  return 0;
}
