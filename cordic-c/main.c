#include <math.h>
#include <stdio.h>

//Scale (2^30) used to operate on fixed-point integers
#define SCALE 1073741824.0

//Cordic K constant multiplied by 2**30 -> 652032874
#define K_CONST 0x26DD3B6A

//Size of precomputed atan lookup table
#define TABLE_COUNT 32

//Precomputed Atan table used for CORDIC alg
//Each record stands for atan(2^-n) where n is from range <0, 31>
//Each record is multiplied by SCALE (2^30)
int ATAN_TAB[] = {
	0x3243f6a8, 0x1dac6705, 0x0fadbafc, 0x07f56ea6, 0x03feab76,
	0x01ffd55b, 0x00fffaaa, 0x007fff55, 0x003fffea, 0x001ffffd,
	0x000fffff, 0x0007ffff, 0x0003ffff, 0x0001ffff, 0x0000ffff, 0x00007fff, 0x00003fff,
	0x00001fff, 0x00000fff, 0x000007ff, 0x000003ff, 0x000001ff, 0x000000ff, 0x0000007f, 0x0000003f, 0x0000001f,
	0x0000000f, 0x00000008, 0x00000004, 0x00000002, 0x00000001, 0x00000000,
};


int* cordic(int angle)
{
	int x = K_CONST;
	int y = 0;
	int z = angle;
	int i;
	
	for (i = 0; i < TABLE_COUNT; ++i)
	{
		int dx = y >> i;
		int dy = x >> i;
		int dz = ATAN_TAB[i];
		if (z < 0)
		{
			x += dx;
			y -= dy;
			z += dz;
		}
		else
		{
			x -= dx;
			y += dy;
			z -= dz;
			
		}
	}
	int result[2] = {x, y};
	return result;
}


int main()
{
	double angle = M_PI / 2;
	double fixed_angle = angle * SCALE;
	double actual_sin = sin(angle);
	double actual_cos = cos(angle);
	int* cordic_res = cordic(fixed_angle);
	double cordic_sin = cordic_res[1] / SCALE;
	double cordic_cos = cordic_res[0] / SCALE;
	printf("angle: %f\n", angle);
	printf("sin: %f\n", actual_sin);
	printf("cordic sin: %f\n", cordic_sin);
	printf("cos: %f\n", actual_cos);
	printf("cordic cos: %f\n", cordic_cos);
	return 0;
}






















