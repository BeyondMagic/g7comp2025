int main()
{
	int a = 1;
	int b = 0;
	int c = a && !b;
	int d = b || a;
	bool cond = a && b;
	printf("logic %d %d\n", c, d);
	return 0;
}
