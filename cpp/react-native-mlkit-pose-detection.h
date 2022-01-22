#ifndef SKRNMLKitPoseDetection_H
#define SKRNMLKitPoseDetection_H
#include <memory>
#include <jsi/jsi.h>
#if __has_include(<react-native-native-video/react-native-native-video.h>)
#define HAS_SKRN_NATIVE_VIDEO 1
#include <react-native-native-video/react-native-native-video.h>
#endif
namespace facebook {
namespace jsi {
class Runtime;
class Value;
class Object;
}
namespace react {
class CallInvoker;
}
}

namespace SKRNMLKitPoseDetection {
  int multiply(float a, float b);

class Point3D {
public:
    double x;
    double y;
    double z;
    facebook::jsi::Object toJSIObject(facebook::jsi::Runtime &runtime);
};

enum PoseDetectorDetectionMode {
    PoseDetectorDetectionModeStream = 0,
    PoseDetectorDetectionModeSingleImage = 1
};

class SKRNMLKitPoseDetectionMLKPoseLandmark {
public:
    float inFrameLikelihood;
    Point3D position;
    std::string type;
    virtual facebook::jsi::Object toJSIObject(facebook::jsi::Runtime &runtime);
//    std::string type() {return "";}
};

/**
 This class should be initialized based on each native platform.
 */
class SKRNMLKitPoseDetectionMLKPose : public facebook::jsi::HostObject {
public:
    virtual std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> landmarks() {return std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark>(); };
    virtual SKRNMLKitPoseDetectionMLKPoseLandmark landmarkOfType(std::string landmarkType) {
        return SKRNMLKitPoseDetectionMLKPoseLandmark();
    }
    facebook::jsi::Value get(facebook::jsi::Runtime &runtime, const facebook::jsi::PropNameID &name);
    std::vector<facebook::jsi::PropNameID> getPropertyNames(facebook::jsi::Runtime& rt);
};
/**
 This class should be initialized based on each native platform.
 */
class SKRNMLKitPoseDetector : public facebook::jsi::HostObject {
public:
    bool accurate;
    PoseDetectorDetectionMode detectionMode;
    
    facebook::jsi::Value get(facebook::jsi::Runtime &runtime, const facebook::jsi::PropNameID &name);
    std::vector<facebook::jsi::PropNameID> getPropertyNames(facebook::jsi::Runtime& rt);
    SKRNMLKitPoseDetector(bool _accurate = false, PoseDetectorDetectionMode _detectionMode = PoseDetectorDetectionModeStream) : accurate(_accurate), detectionMode(_detectionMode) {};
#ifdef HAS_SKRN_NATIVE_VIDEO
    virtual std::vector<std::shared_ptr<SKRNMLKitPoseDetection::SKRNMLKitPoseDetectionMLKPose>> process(std::shared_ptr<SKRNNativeVideo::SKNativeFrameWrapper>) {return std::vector<std::shared_ptr<SKRNMLKitPoseDetectionMLKPose>>(); };
#endif
};


void install(facebook::jsi::Runtime &jsiRuntime, std::function<std::shared_ptr<SKRNMLKitPoseDetector>(facebook::jsi::Runtime&, bool accurate, PoseDetectorDetectionMode detectionMode)> poseDetectorConstructor);
//void install(facebook::jsi::Runtime &jsiRuntime, std::shared_ptr<facebook::react::CallInvoker> invoker);
void cleanup(facebook::jsi::Runtime &jsiRuntime);
}

#endif /* SKRNMLKitPoseDetection_H */
