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
    ~SKRNMLKitPoseDetectioniOSMLKPose();
    virtual std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> landmarks();
    virtual SKRNMLKitPoseDetectionMLKPoseLandmark landmarkOfType(std::string landmarkType);
    virtual facebook::jsi::Object toJSIObject(facebook::jsi::Runtime &runtime);
};

class SKRNMLKitPoseDetectioniOSMLKPoseHostObject : public SKRNMLKitPoseDetectionMLKPoseHostObject {
    SKRNMLKitPoseDetectioniOSMLKPose pose;
public:
    SKRNMLKitPoseDetectioniOSMLKPoseHostObject(facebook::jsi::Runtime &_runtime, SKRNMLKitPoseDetectioniOSMLKPose _pose);
    virtual std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> landmarks() {
        return pose.landmarks();
    };
    virtual SKRNMLKitPoseDetectionMLKPoseLandmark landmarkOfType(std::string landmarkType) {
        return pose.landmarkOfType(landmarkType);
    }
};



class SKRNMLKitiOSPoseDetector : public SKRNMLKitPoseDetector {
private:
    MLKPoseDetector *poseDetector;
public:
    SKRNMLKitiOSPoseDetector(facebook::jsi::Runtime &_runtime, bool _accurate = false, SKRNMLKitPoseDetection::PoseDetectorDetectionMode _detectionMode = SKRNMLKitPoseDetection::PoseDetectorDetectionModeStream);
    ~SKRNMLKitiOSPoseDetector();
#ifdef HAS_SKRN_NATIVE_VIDEO
    virtual std::vector<std::shared_ptr<SKRNMLKitPoseDetection::SKRNMLKitPoseDetectionMLKPose>> process(std::shared_ptr<SKRNNativeVideo::SKNativeFrameWrapper>);
#endif
};

}

#endif
#endif
