#include<stdio.h>

void main()
{
	int c;
	char output[128];
	int i;
	for (i=0; i<128; i++) {
		output[i] = 0;
	}
	int pos;
	int goodies = 1;


	while ((c = getchar() ) != EOF) {
		if ( goodies > 0) {
			if (c < 65 || c > 122) {
				goodies = 0;
			} else {
				output[pos] = c;
				pos++;
			}
		}
	}
	printf("%s", output);
}

