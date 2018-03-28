#include <cv.h>  
#include <highgui.h>  
#include <opencv2/imgproc/imgproc.hpp>    
#include <opencv2/highgui/highgui.hpp>    
#include <iostream>   
using namespace cv;
using namespace std;
stringstream ss1;
stringstream ss2;

void RemoveSmallRegion(Mat& Src, Mat& Dst, int AreaLimit = 50, int CheckMode = 1, int NeihborMode = 0);


int main()
{
	bool blank = false;
	char *path1 = "slam/seg/";
	char *path2 = "slam/output/";
	
	char *suffix1 = ".jpg";
	char *suffix2 = ".jpg";

	for (int ii = 1440; ii <= 2248; ii++){
		
		char *imagePath = new char[strlen(path1) + sizeof(ii)+strlen(suffix1)];
		sprintf(imagePath, "%s%06d%s", path1, ii, suffix1);

		char *OutPath = new char[strlen(path2) + sizeof(ii)+strlen(suffix2)];
		sprintf(OutPath, "%s%06d%s", path2, ii, suffix2);

		double t = (double)getTickCount();


		Mat Src = imread(imagePath, CV_LOAD_IMAGE_GRAYSCALE);
		Mat Dst = Mat::zeros(Src.size(), CV_8UC1);


		//��ֵ������  
		for (int i = 0; i < Src.rows; ++i)
		{
			uchar* iData = Src.ptr<uchar>(i);
			for (int j = 0; j < Src.cols; ++j)
			{
				if (iData[j] == 0 || iData[j] == 255) continue;
				else if (iData[j] < 10)
				{
					iData[j] = 0;
					//cout<<'#';  
				}
				else if (iData[j] > 10)
				{
					iData[j] = 255;
					//cout<<'!';  
				}
			}
		}
		cout << "Image Binary processed." << endl;

		RemoveSmallRegion(Src, Dst, 100000, 1, 0);
		RemoveSmallRegion(Dst, Dst, 100000, 0, 0);
		cout << "Done!" << endl;
		imwrite(OutPath, Dst);

		t = ((double)getTickCount() - t) / getTickFrequency();
		cout << "Time cost: " << t << " sec." << endl;

	}
	return 0;
}

//CheckMode: 0����ȥ��������1����ȥ��������; NeihborMode��0����4����1����8����;  
void RemoveSmallRegion(Mat& Src, Mat& Dst, int AreaLimit, int CheckMode, int NeihborMode)
{
	int RemoveCount = 0;       //��¼��ȥ�ĸ���  
	//��¼ÿ�����ص����״̬�ı�ǩ��0����δ��飬1�������ڼ��,2�����鲻�ϸ���Ҫ��ת��ɫ����3������ϸ������  
	Mat Pointlabel = Mat::zeros(Src.size(), CV_8UC1);

	if (CheckMode == 1)
	{
		cout << "Mode: ȥ��С����. ";
		for (int i = 0; i < Src.rows; ++i)
		{
			uchar* iData = Src.ptr<uchar>(i);
			uchar* iLabel = Pointlabel.ptr<uchar>(i);
			for (int j = 0; j < Src.cols; ++j)
			{
				if (iData[j] < 10)
				{
					iLabel[j] = 3;
				}
			}
		}
	}
	else
	{
		cout << "Mode: ȥ���׶�. ";
		for (int i = 0; i < Src.rows; ++i)
		{
			uchar* iData = Src.ptr<uchar>(i);
			uchar* iLabel = Pointlabel.ptr<uchar>(i);
			for (int j = 0; j < Src.cols; ++j)
			{
				if (iData[j] > 10)
				{
					iLabel[j] = 3;
				}
			}
		}
	}

	vector<Point2i> NeihborPos;  //��¼�����λ��  
	NeihborPos.push_back(Point2i(-1, 0));
	NeihborPos.push_back(Point2i(1, 0));
	NeihborPos.push_back(Point2i(0, -1));
	NeihborPos.push_back(Point2i(0, 1));
	if (NeihborMode == 1)
	{
		cout << "Neighbor mode: 8����." << endl;
		NeihborPos.push_back(Point2i(-1, -1));
		NeihborPos.push_back(Point2i(-1, 1));
		NeihborPos.push_back(Point2i(1, -1));
		NeihborPos.push_back(Point2i(1, 1));
	}
	else cout << "Neighbor mode: 4����." << endl;
	int NeihborCount = 4 + 4 * NeihborMode;
	int CurrX = 0, CurrY = 0;
	//��ʼ���  
	for (int i = 0; i < Src.rows; ++i)
	{
		uchar* iLabel = Pointlabel.ptr<uchar>(i);
		for (int j = 0; j < Src.cols; ++j)
		{
			if (iLabel[j] == 0)
			{
				//********��ʼ�õ㴦�ļ��**********  
				vector<Point2i> GrowBuffer;                                      //��ջ�����ڴ洢������  
				GrowBuffer.push_back(Point2i(j, i));
				Pointlabel.at<uchar>(i, j) = 1;
				int CheckResult = 0;                                               //�����жϽ�����Ƿ񳬳���С����0Ϊδ������1Ϊ����  

				for (int z = 0; z<GrowBuffer.size(); z++)
				{

					for (int q = 0; q<NeihborCount; q++)                                      //����ĸ������  
					{
						CurrX = GrowBuffer.at(z).x + NeihborPos.at(q).x;
						CurrY = GrowBuffer.at(z).y + NeihborPos.at(q).y;
						if (CurrX >= 0 && CurrX<Src.cols&&CurrY >= 0 && CurrY<Src.rows)  //��ֹԽ��  
						{
							if (Pointlabel.at<uchar>(CurrY, CurrX) == 0)
							{
								GrowBuffer.push_back(Point2i(CurrX, CurrY));  //��������buffer  
								Pointlabel.at<uchar>(CurrY, CurrX) = 1;           //���������ļ���ǩ�������ظ����  
							}
						}
					}

				}
				if (GrowBuffer.size()>AreaLimit) CheckResult = 2;                 //�жϽ�����Ƿ񳬳��޶��Ĵ�С����1Ϊδ������2Ϊ����  
				else { CheckResult = 1;   RemoveCount++; }
				for (int z = 0; z<GrowBuffer.size(); z++)                         //����Label��¼  
				{
					CurrX = GrowBuffer.at(z).x;
					CurrY = GrowBuffer.at(z).y;
					Pointlabel.at<uchar>(CurrY, CurrX) += CheckResult;
				}
				//********�����õ㴦�ļ��**********  


			}
		}
	}

	CheckMode = 255 * (1 - CheckMode);
	//��ʼ��ת�����С������  
	for (int i = 0; i < Src.rows; ++i)
	{
		uchar* iData = Src.ptr<uchar>(i);
		uchar* iDstData = Dst.ptr<uchar>(i);
		uchar* iLabel = Pointlabel.ptr<uchar>(i);
		for (int j = 0; j < Src.cols; ++j)
		{
			if (iLabel[j] == 2)
			{
				iDstData[j] = CheckMode;
			}
			else if (iLabel[j] == 3)
			{
				iDstData[j] = iData[j];
			}
		}
	}

	cout << RemoveCount << " objects removed." << endl;
}