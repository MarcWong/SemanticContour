#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <fstream>
#include <string.h>
#include <legacy/legacy.hpp>
#include <cv.h>
#include <highgui.h>


IplImage *image = 0; //原始图像
IplImage *image2 = 0, *image3 = 0; //原始图像copy
IplImage *image4 = 0;
using namespace std;
int Thresholdness = 100;
int ialpha = 20;
int ibeta = 20;
int igamma = 20;
int gdwStart = 0;
CvPoint *point, *point2;
int length;
const int x[16] = { 360, 368, 415, 415, 363, 363, 374, 372, 371, 316, 313, 310, 308, 250, 250, 360 };
const int y[16] = { 148, 148, 202, 209, 253, 259, 273, 280, 281, 326, 326, 325, 324, 253, 243, 148 };
void onmouse(int event, int x, int y, int flags, void* param)
{
	switch (event)
	{
	case CV_EVENT_MOUSEMOVE:

		break;
	case CV_EVENT_LBUTTONDOWN:
		point[length++] = cvPoint(x, y);
		printf("%d,%d;\n", x, y);
		break;
	case CV_EVENT_RBUTTONDOWN:
		length = 0;
		break;
	}
}

void onChange(int pos)
{

	float alpha = ialpha / 100.0f;
	float beta = ibeta / 100.0f;
	float gamma = igamma / 100.0f;

	CvSize size;
	size.width = 3;
	size.height = 3;
	CvTermCriteria criteria;
	criteria.type = CV_TERMCRIT_ITER;
	criteria.max_iter = 1000;
	criteria.epsilon = 0.1;

	memcpy(point2, point, length * sizeof(CvPoint));

	cvSnakeImage(image, point2, length, &alpha, &beta, &gamma, CV_VALUE, size, criteria, 0);
}
int main(int argc, char* argv[])
{

	if (image3) cvReleaseImage(&image3);
	if (image2) cvReleaseImage(&image2);
	if (image) cvReleaseImage(&image);

	char *pbyFN = "nms.jpg";
	image2 = cvLoadImage(pbyFN, 1);
	image3 = cvLoadImage(pbyFN, 1);
	image = cvLoadImage(pbyFN, 0);

	point = new CvPoint[1000]; //分配轮廓点
	point2 = new CvPoint[1000];

	cvShowImage("win0", image2); //显示图片
	
	/*
	char *contour = "contour.jpg";
	double tmp;
	image4 = cvLoadImage(contour, 0);

	cvNamedWindow("1");
	cvShowImage("1", image4);
	for (int i = 0; i < image4->height; i++)
	for (int j = 0; j < image4->width; j++){
		tmp = cvGet2D(image4, i, j).val[0];
		if (tmp > 128)
		{
			//cout << tmp <<endl;
			point[length++] = cvPoint(j, i);
		}
			
	}
	*/
	
	for (int i = 0; i <= 15; i++){
		point[length++] = cvPoint(int(x[i] + (-x[i] + 256)*0), int(y[i] + (-y[i]+342)*0));
	}
	
	//cvSetMouseCallback("win0", onmouse, 0);
#if 1
	while (1)
	{
		//显示轮廓曲线

		for (int i = 0; i < length - 1; i++)
		{
				cvLine(image2, point[i], point[i + 1], CV_RGB(255, 0, 0), 2, 8, 0);
		}
		cvCopyImage(image2, image3);
		cvShowImage("win0", image3);
		uchar key = cvWaitKey(40);
		if (key == 'c') break;
		//        printf("-\n");
	}
#endif
	printf("point number:%d\n", length);

	if (length < 10)
	{
		printf("point number must be bigger than 10.\n");
		return 0;
	}



	cvNamedWindow("win1", 0);
	cvCreateTrackbar("Thd", "win1", &Thresholdness, 255, onChange);
	cvCreateTrackbar("alpha", "win1", &ialpha, 100, onChange);
	cvCreateTrackbar("beta", "win1", &ibeta, 100, onChange);
	cvCreateTrackbar("gamma", "win1", &igamma, 100, onChange);
	cvResizeWindow("win1", 300, 500);

	onChange(0);

	while (1)
	{
		//显示曲线
		cvCopyImage(image2, image3);
		for (int i = 0; i < length - 1; i++)
		{
			cvLine(image3, point2[i], point2[i + 1], CV_RGB(0, 255, 0), 2, 8, 0);
		}

		cvShowImage("win1", image3);
		uchar key = cvWaitKey(40);
		if (key == 'q') break;
	}

	delete[]point;
	delete[]point2;

	return 0;
}