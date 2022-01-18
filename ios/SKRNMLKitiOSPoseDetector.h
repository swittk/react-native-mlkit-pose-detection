//
//  SKRNMLKitiOSPoseDetector.h
//  react-native-mlkit-pose-detection
//
//  Created by Switt Kongdachalert on 18/1/2565 BE.
//
#ifdef __cplusplus
#ifndef SKRNMLKitiOSPoseDetector_H
#define SKRNMLKitiOSPoseDetector_H

#import <Foundation/Foundation.h>
#import "react-native-mlkit-pose-detection.h"
#import <MLKitVision/MLKitVision.h>
#import <MLKitPoseDetectionCommon/MLKitPoseDetectionCommon.h>
#import <MLKitPoseDetection/MLKitPoseDetection.h>
#import <MLKitPoseDetectionAccurate/MLKitPoseDetectionAccurate.h>

namespace SKRNMLKitPoseDetection {
class SKRNMLKitPoseDetectioniOSMLKPose : public SKRNMLKitPoseDetectionMLKPose {
private:
    MLKPose *pose;
public:
    SKRNMLKitPoseDetectioniOSMLKPose(MLKPose *pose);
    virtual std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> landmarks();
    virtual SKRNMLKitPoseDetectionMLKPoseLandmark landmarkOfType(std::string landmarkType);
};

class SKRNMLKitiOSPoseDetector : public SKRNMLKitPoseDetector {
private:
    MLKPoseDetector *poseDetector;
public:
    SKRNMLKitiOSPoseDetector(facebook::jsi::Runtime &_runtime, bool _accurate = false, SKRNMLKitPoseDetection::PoseDetectorDetectionMode _detectionMode = SKRNMLKitPoseDetection::PoseDetectorDetectionModeStream);
#ifdef HAS_SKRN_NATIVE_VIDEO
    virtual std::vector<SKRNMLKitPoseDetection::SKRNMLKitPoseDetectionMLKPose> process(std::shared_ptr<SKRNNativeVideo::SKNativeFrameWrapper>);
#endif
};

}

#endif
#endif
