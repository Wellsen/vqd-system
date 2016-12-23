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
        sprintf(name, "img/morphologica/%d.bmp", i);
        imwrite(name, imageLayer[i]);
    }
}

bool MosaicDetection(vector<Mat>& imageLayer) {
    double EPS = 0.000001;
    double lowThreshold = 100.0;
    double highThreshold = 200.0;

    double angleThreshold = 0.2;

    double areaLowThreshold = 50.0;
    double areaHighThreshold = 200.0;

    const double lowAreaRatio = 0.5;
    const double highAreaRatio = 1.5;

    int mosaicNums = 0;
    int mosaicThreshold = 10;

    for (int i = 0; i < 256; i++) {
        Mat imageCanny, imageBinary;
        Canny(imageLayer[i], imageCanny, lowThreshold, highThreshold, 3);
        threshold(imageCanny, imageBinary, 50, 255, THRESH_BINARY);

        vector<vector<Point> > contours;
        findContours(imageBinary, contours, RETR_LIST, CHAIN_APPROX_NONE, Point(0, 0));

        int nums = 0;
        for (size_t k = 0; k < contours.size(); k++) {
            Rect rect = boundingRect(contours[k]);
            RotatedRect rrect = minAreaRect(contours[k]);

            double rectArea = rect.width * rect.height;
            double rrectArea = rrect.size.width * rrect.size.height;
            double areaRatio = rectArea / (rrectArea + EPS);

            double contoursArea = fabs(contourArea(contours.at(k)));

            if ((abs(rrect.angle) < angleThreshold) \
                && (rrectArea > areaLowThreshold && rrectArea < areaHighThreshold) \
                && (areaRatio > lowAreaRatio && areaRatio < highAreaRatio)
                ){
                rectangle(imageLayer[i], rect, Scalar(0, 0, 255), 1, 8, 0);
                mosaicNums++;
                nums++;
            }
            //if (mosaicNums > mosaicThreshold) {
            //    return true;
            //}
        }
        cout << i << " : " << nums << endl;
        imshow("find mosaics", imageLayer[i]);
        waitKey();
    }

    return mosaicNums > mosaicThreshold ? true : false;
    //return false;
}

int main() {
    Mat image = imread("../../database/mosaic.bmp");
    Mat imageGray;
    cvtColor(image, imageGray, COLOR_BGR2GRAY);
    imwrite("gray.jpg", imageGray);

    vector<Mat> imageLayer = ImageLayered(imageGray);
    MorphologicaOperation(imageLayer);
    bool result = MosaicDetection(imageLayer);
    if (result) {
        cout << "there is mosaic." << endl;
    }

    system("pause");
    return 0;
}