#include <iostream>
#include <vector>
#include <string>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#pragma warning(disable:4996)

using namespace std;
using namespace cv;

vector<Mat> ImageLayered(const Mat& image) {
    vector<Mat> imageLayer;
    for (int i = 0; i < 256; i++) {
        Mat tmp = Mat::zeros(image.size(), CV_8UC1);
        imageLayer.push_back(tmp);
    }

    for (int i = 0; i < image.rows; i++) {
        for (int j = 0; j < image.cols; j++) {
            imageLayer[image.at<uchar>(i, j)].at<uchar>(i, j) = 255;
        }
    }

    for (int i = 0; i < 256; i++) {
        char name[20];
        sprintf(name, "img/layer/%d.bmp", i);
        imwrite(name, imageLayer[i]);
    }
    return imageLayer;
}

void MorphologicaOperation(vector<Mat>& imageLayer) {
    Mat kernel = getStructuringElement(MORPH_RECT, Size(5, 5));
    for (int i = 0; i < 256; i++) {
        erode(imageLayer[i], imageLayer[i], kernel);
        dilate(imageLayer[i], imageLayer[i], kernel);
        char name[30];
        sprintf(name, "img/morphological/%d.bmp", i);
        imwrite(name, imageLayer[i]);
    }
}

bool MosaicDetection(Mat &image,  vector<Mat>& imageLayer) {
    double EPS = 0.000001;

    double Tangle = 0.1;

    double Tminarea = 240.0;
    double Tmaxarea = 5000.0;

    const double TR1 = 0.1;
    const double TR2 = 0.1;

    int mosaicNums = 0;
    int mosaicThreshold = 10;

    double lowcannyThreshold = 100.0;
    double highcannyThreshold = 200.0;

    for (int i = 0; i < 256; i++) {
        Mat imageCanny, imageBinary;
        Canny(imageLayer[i], imageCanny, lowcannyThreshold, highcannyThreshold, 3);
        threshold(imageCanny, imageBinary, 50, 255, THRESH_BINARY);

        vector<vector<Point> > contours;
        findContours(imageBinary, contours, RETR_LIST, CHAIN_APPROX_NONE, Point(0, 0));

        int nums = 0;
        for (size_t k = 0; k < contours.size(); k++) {
            Rect rect = boundingRect(contours[k]);
            RotatedRect rrect = minAreaRect(contours[k]);

            double R1 = contours[k].size() / (2 * (rrect.size.width + rrect.size.height) + EPS) - 1.0;
            double contoursArea = fabs(contourArea(contours.at(k)));
            double R2 = contoursArea / (rrect.size.width * rrect.size.height + EPS) - 1.0;

            if ((abs(rrect.angle) < Tangle) && (abs(R1) < TR1) && (abs(R2) < TR2) \
                && (contoursArea > Tminarea)/* && (contoursArea < Tmaxarea)*/){
                rectangle(image, rect, Scalar(0, 0, 255), 1, 8, 0);
                mosaicNums++;
                nums++;
            }
            //if (mosaicNums > mosaicThreshold) {
            //    return true;
            //}
        }
        cout << i << " : " << nums << endl;
    }

    return mosaicNums > mosaicThreshold ? true : false;
    //return false;
}

int main() {
    Mat image = imread("./mosaic/m_2.bmp");
    Mat imageGray;
    cvtColor(image, imageGray, COLOR_BGR2GRAY);
    imwrite("gray.jpg", imageGray);

    //double t = (double)getTickCount();
    
    vector<Mat> imageLayer = ImageLayered(imageGray);
    MorphologicaOperation(imageLayer);
    bool result = MosaicDetection(image, imageLayer);

    //t = (double)cvGetTickCount() - t;

    //printf("exec time = %lfms\n", 1000.0 * t / getTickFrequency());

    if (result) {
        imwrite("./res.bmp", image);
        cout << "there is mosaic." << endl;
    }

    imshow("find mosaics", image);
    waitKey();

    fgetchar();
    return 0;
}