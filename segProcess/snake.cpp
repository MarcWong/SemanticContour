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
IplImage *imageout = 0;
using namespace std;

bool window = false;
int Thresholdness = 100;
int ialpha = 5;
int ibeta = 100;
int igamma = 100;
CvPoint *point, *point2;
int length;
/*const int x[16] = { 360, 368, 415, 415, 363, 363, 374, 372, 371, 316, 313, 310, 308, 250, 250, 360 };
const int y[16] = { 148, 148, 202, 209, 253, 259, 273, 280, 281, 326, 326, 325, 324, 253, 243, 148 };
*/


/*convex sort*/
struct Point
{
	double x, y;

	Point operator-(Point & p)
	{
		Point t;
		t.x = x - p.x;
		t.y = y - p.y;
		return t;
	}

	double det(Point p)//向量叉积
	{
		return x*p.y - p.x*y;
	}

	double dist(Point & p)//两点距离公式
	{
		return sqrt((x - p.x)*(x - p.x) + (y - p.y)*(y - p.y));
	}
};

bool cmp(Point & p1, Point & p2)
{
	if (p1.x != p2.x)
		return p1.x < p2.x;

	return p1.y < p2.y;
}

void onChange(int pos)
{

	float alpha = ialpha / 100.0f;
	float beta = ibeta / 100.0f;
	float gamma = igamma / 100.0f;

	CvSize size;
	size.width = 21;
	size.height = 21;
	CvTermCriteria criteria;
	criteria.type = CV_TERMCRIT_ITER;
	criteria.max_iter = 500;
	criteria.epsilon = 0.1;

	memcpy(point2, point, length * sizeof(CvPoint));

	cvSnakeImage(image, point2, length, &alpha, &beta, &gamma, CV_VALUE, size, criteria, 0);
}
int main(int argc, char* argv[])
{
	char *nms = "big/1/1_nms_mask.jpg";
	char *path1 = "big/1/contour/";
	char *path2 = "big/1/result/";

	bool blank = false;
	for (int ii = 403; ii <= 417; ii++){
		//char *input = "4/result/out1.jpg";

		char *prefix1 = "contour";
		char *prefix2 = "out";

		char *suffix1 = ".txt";
		char *suffix2 = ".jpg";

		char *pointTxt = new char[strlen(path1) + strlen(prefix1) + sizeof(ii)+strlen(suffix1)];
		sprintf(pointTxt, "%s%s%d%s", path1, prefix1, ii, suffix1);

		char *output = new char[strlen(path2) + strlen(prefix2) + sizeof(ii)+strlen(suffix2)];
		sprintf(output, "%s%s%d%s", path2, prefix2, ii, suffix2);

		CvSize s;
		s.width = 2500;
		s.height = 2500;

		if (image3) cvReleaseImage(&image3);
		if (image2) cvReleaseImage(&image2);
		if (image) cvReleaseImage(&image);


		image2 = cvLoadImage(nms, 1);
		image3 = cvLoadImage(nms, 1);
		image = cvLoadImage(nms, 0);


		//////////////////////////////////
		//set output file

		/*if (!blank){
		imageout = cvLoadImage(input, 1);
		}
		else{*/
		imageout = cvCreateImage(s, 8, 3);
		for (int i = 0; i < imageout->height; i++){
			for (int j = 0; j < imageout->width; j++){
				cvSet2D(imageout, i, j, cvScalar(0, 0, 0));
			}
		}
		//}


		point = new CvPoint[1000]; //分配轮廓点
		point2 = new CvPoint[1000];

		//cvShowImage("win0", image2); //显示图片


		/////////////////////////////////////////////////////
		////load contour and intialize pointset+
		/*char *contour = "contour.jpg";
		image4 = cvLoadImage(contour, 0);


		cvNamedWindow("1");
		cvShowImage("1", image4);


		N = 0;
		for (int i = 0; i < image4->height; i++)
		for (int j = 0; j < image4->width; j++){
		int tmp;
		tmp = cvGet2D(image4, i, j).val[0];
		if (tmp > 128)
		{
		pointC[N].x = double(j);
		pointC[N].y = double(i);
		N++;
		}

		}
		int convexNum = getConvexHull();
		cout << convexNum << endl;

		/*
		ofstream out("/Users/marcWong/Desktop/snakeDemo/2.txt", ios::out);
		for (int i = 0; i< convexNum; i++){
		out << pointC[convex[i]].x << " " << pointC[convex[i]].y << endl;
		}
		*/
		/////////////////////////////////////////////////////
		////save ordered points to cvPoint

		/*for (int i = 0; i <= 15; i++){
		point[length++] = cvPoint(int(x[i] + (x[i] - 342)*0.7), int(y[i] + (y[i] - 256)*0.7));
		}*/


		ifstream in(pointTxt, ios::in);
		length = 0;
		double xCenter = 0, yCenter = 0;
		int x[5000], y[5000];
		int cnt = 0;
		if (!in)
			return 0;
		while (!in.eof()){
			cnt++;
			if (cnt % 10 == 0){
				int tmp1, tmp2;
				in >> tmp1 >> tmp2;
				x[length] = tmp2;
				y[length] = tmp1;
				xCenter += tmp2;
				yCenter += tmp1;
				length++;
			}
		}

		xCenter /= length;
		yCenter /= length;

		for (int i = 0; i < length; i++){
			point[i] = cvPoint(int(x[i] + (x[i] - xCenter)*0.1), int(y[i] + (y[i] - yCenter)*0.1));
		}


		/////////////////////////////////////////////////////
		////save convex points to cvPoint
		/*//显示轮廓曲线
		*/

		//cvSetMouseCallback("win0", onmouse, 0);
		/*
		#if 1
		while (1)
		{
		cvCopyImage(image2, image3);
		cvShowImage("win0", image3);
		uchar key = cvWaitKey(40);
		if (key == 'c') break;
		//        printf("-\n");
		}
		#endif
		*/
		printf("point number:%d\n", length);

		for (int i = 0; i < length - 1; i++)
		{
			cvLine(image2, point[i], point[i + 1], CV_RGB(255, 0, 0), 1, 8, 0);
		}
		cvLine(image2, point[length - 1], point[0], CV_RGB(255, 0, 0), 1, 8, 0);

		//rechecked
		if (length < 10)
		{
			printf("point number must be bigger than 10.\n");
			continue;
		}

		if (window)
		{
			cvNamedWindow("win1", 0);
			cvCreateTrackbar("Thd", "win1", &Thresholdness, 255, onChange);
			cvCreateTrackbar("alpha", "win1", &ialpha, 100, onChange);
			cvCreateTrackbar("beta", "win1", &ibeta, 100, onChange);
			cvCreateTrackbar("gamma", "win1", &igamma, 100, onChange);
			cvResizeWindow("win1", 400, 500);
		}

		onChange(0);

		if (window)
		{

			while (1)
			{
				//显示曲线
				cvCopyImage(image2, image3);
				for (int i = 0; i < length - 1; i++)
				{
					cvLine(image3, point2[i], point2[i + 1], CV_RGB(0, 255, 0), 2, 8, 0);
					cvLine(imageout, point2[i], point2[i + 1], CV_RGB(255, 255, 255), 1, 8, 0);
				}
				cvLine(image3, point2[length - 1], point2[0], CV_RGB(0, 255, 0), 2, 8, 0);
				cvLine(imageout, point2[length - 1], point2[0], CV_RGB(255, 255, 255), 1, 8, 0);
				cvShowImage("win1", image3);
				uchar key = cvWaitKey(40);
				if (key == 'q') break;
			}
		}

		for (int i = 0; i < length - 1; i++)
		{
			cvLine(imageout, point2[i], point2[i + 1], CV_RGB(255, 255, 255), 1, 8, 0);
		}
		cvLine(imageout, point2[length - 1], point2[0], CV_RGB(255, 255, 255), 1, 8, 0);

		cvSaveImage(output, imageout);
		delete[]point;
		delete[]point2;
	}
	return 0;
}