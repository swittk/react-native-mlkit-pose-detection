//
//  SKRNMLKitiOSPoseDetector.m
//  react-native-mlkit-pose-detection
//
//  Created by Switt Kongdachalert on 18/1/2565 BE.
//

#import "SKRNMLKitiOSPoseDetector.h"
#ifdef HAS_SKRN_NATIVE_VIDEO
#import <react-native-native-video/SKiOSNativeVideoCPP.h>
#endif
using namespace SKRNNativeVideo;
using namespace SKRNMLKitPoseDetection;

static NSDictionary *mapStringLandmarkNamesToNativeNames = @{
    @"Nose": MLKPoseLandmarkTypeNose,
    @"LeftEyeInner": MLKPoseLandmarkTypeLeftEyeInner,
    @"LeftEye": MLKPoseLandmarkTypeLeftEye,
    @"LeftEyeOuter": MLKPoseLandmarkTypeLeftEyeOuter,
    @"RightEyeInner": MLKPoseLandmarkTypeRightEyeInner,
    @"RightEye": MLKPoseLandmarkTypeRightEye,
    @"RightEyeOuter": MLKPoseLandmarkTypeRightEyeOuter,
    @"LeftEar": MLKPoseLandmarkTypeLeftEar,
    @"RightEar": MLKPoseLandmarkTypeRightEar,
    @"MouthLeft": MLKPoseLandmarkTypeMouthLeft,
    @"MouthRight": MLKPoseLandmarkTypeMouthRight,
    @"LeftShoulder": MLKPoseLandmarkTypeLeftShoulder,
    @"RightShoulder": MLKPoseLandmarkTypeRightShoulder,
    @"LeftElbow": MLKPoseLandmarkTypeLeftElbow,
    @"RightElbow": MLKPoseLandmarkTypeRightElbow,
    @"LeftWrist": MLKPoseLandmarkTypeLeftWrist,
    @"RightWrist": MLKPoseLandmarkTypeRightWrist,
    @"LeftPinkyFinger": MLKPoseLandmarkTypeLeftPinkyFinger,
    @"RightPinkyFinger": MLKPoseLandmarkTypeRightPinkyFinger,
    @"LeftIndexFinger": MLKPoseLandmarkTypeLeftIndexFinger,
    @"RightIndexFinger": MLKPoseLandmarkTypeRightIndexFinger,
    @"LeftThumb": MLKPoseLandmarkTypeLeftThumb,
    @"RightThumb": MLKPoseLandmarkTypeRightThumb,
    @"LeftHip": MLKPoseLandmarkTypeLeftHip,
    @"RightHip": MLKPoseLandmarkTypeRightHip,
    @"LeftKnee": MLKPoseLandmarkTypeLeftKnee,
    @"RightKnee": MLKPoseLandmarkTypeRightKnee,
    @"LeftAnkle": MLKPoseLandmarkTypeLeftAnkle,
    @"RightAnkle": MLKPoseLandmarkTypeRightAnkle,
    @"LeftHeel": MLKPoseLandmarkTypeLeftHeel,
    @"RightHeel": MLKPoseLandmarkTypeRightHeel,
    @"LeftToe": MLKPoseLandmarkTypeLeftToe,
    @"RightToe": MLKPoseLandmarkTypeRightToe
};
static NSDictionary *mapNativeLandmarkNamesToStringNames = @{
  MLKPoseLandmarkTypeNose: @"Nose",
  MLKPoseLandmarkTypeLeftEyeInner: @"LeftEyeInner",
  MLKPoseLandmarkTypeLeftEye: @"LeftEye",
  MLKPoseLandmarkTypeLeftEyeOuter: @"LeftEyeOuter",
  MLKPoseLandmarkTypeRightEyeInner: @"RightEyeInner",
  MLKPoseLandmarkTypeRightEye: @"RightEye",
  MLKPoseLandmarkTypeRightEyeOuter: @"RightEyeOuter",
  MLKPoseLandmarkTypeLeftEar: @"LeftEar",
  MLKPoseLandmarkTypeRightEar: @"RightEar",
  MLKPoseLandmarkTypeMouthLeft: @"MouthLeft",
  MLKPoseLandmarkTypeMouthRight: @"MouthRight",
  MLKPoseLandmarkTypeLeftShoulder: @"LeftShoulder",
  MLKPoseLandmarkTypeRightShoulder: @"RightShoulder",
  MLKPoseLandmarkTypeLeftElbow: @"LeftElbow",
  MLKPoseLandmarkTypeRightElbow: @"RightElbow",
  MLKPoseLandmarkTypeLeftWrist: @"LeftWrist",
  MLKPoseLandmarkTypeRightWrist: @"RightWrist",
  MLKPoseLandmarkTypeLeftPinkyFinger: @"LeftPinkyFinger",
  MLKPoseLandmarkTypeRightPinkyFinger: @"RightPinkyFinger",
  MLKPoseLandmarkTypeLeftIndexFinger: @"LeftIndexFinger",
  MLKPoseLandmarkTypeRightIndexFinger: @"RightIndexFinger",
  MLKPoseLandmarkTypeLeftThumb: @"LeftThumb",
  MLKPoseLandmarkTypeRightThumb: @"RightThumb",
  MLKPoseLandmarkTypeLeftHip: @"LeftHip",
  MLKPoseLandmarkTypeRightHip: @"RightHip",
  MLKPoseLandmarkTypeLeftKnee: @"LeftKnee",
  MLKPoseLandmarkTypeRightKnee: @"RightKnee",
  MLKPoseLandmarkTypeLeftAnkle: @"LeftAnkle",
  MLKPoseLandmarkTypeRightAnkle: @"RightAnkle",
  MLKPoseLandmarkTypeLeftHeel: @"LeftHeel",
  MLKPoseLandmarkTypeRightHeel: @"RightHeel",
  MLKPoseLandmarkTypeLeftToe: @"LeftToe",
  MLKPoseLandmarkTypeRightToe: @"RightToe"
};

SKRNMLKitiOSPoseDetector::SKRNMLKitiOSPoseDetector(facebook::jsi::Runtime &_runtime, bool _accurate, SKRNMLKitPoseDetection::PoseDetectorDetectionMode _detectionMode)
: SKRNMLKitPoseDetection::SKRNMLKitPoseDetector(_runtime, _accurate, _detectionMode)
{
    MLKCommonPoseDetectorOptions *options;
    if(accurate) {
        options = [[MLKAccuratePoseDetectorOptions alloc] init];
    }
    else {
        options = [[MLKPoseDetectorOptions alloc] init];
    }
    switch(detectionMode) {
        case PoseDetectorDetectionModeStream: {
            options.detectorMode = MLKPoseDetectorModeStream;
        } break;
        case PoseDetectorDetectionModeSingleImage: {
            options = [[MLKPoseDetectorOptions alloc] init];
            options.detectorMode = MLKPoseDetectorModeSingleImage;
        } break;
    }
    poseDetector = [MLKPoseDetector poseDetectorWithOptions:options];
}
SKRNMLKitiOSPoseDetector::~SKRNMLKitiOSPoseDetector() {
    NSLog(@"freeing poseDetector");
    poseDetector = nil;
}

#ifdef HAS_SKRN_NATIVE_VIDEO
std::vector<SKRNMLKitPoseDetectionMLKPose> SKRNMLKitiOSPoseDetector::process(std::shared_ptr<SKNativeFrameWrapper> frameWrapper) {
    SKiOSNativeFrameWrapper *frame = (SKiOSNativeFrameWrapper *)(frameWrapper.get());
    MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:frame->buffer];
    image.orientation = frame->orientation;
    NSError *error;
    NSArray <MLKPose *>*poses = [poseDetector resultsInImage:image error:&error];
    if(![poses count]) {
        return std::vector<SKRNMLKitPoseDetectionMLKPose>();
    }
    std::vector<SKRNMLKitPoseDetectionMLKPose> ret;
    for(MLKPose *pose in poses) {
        ret.push_back(SKRNMLKitPoseDetectioniOSMLKPose(pose));
    }
    return ret;
}

SKRNMLKitPoseDetectioniOSMLKPose::SKRNMLKitPoseDetectioniOSMLKPose(MLKPose *_pose) {
    pose = _pose;
}
SKRNMLKitPoseDetectioniOSMLKPose::~SKRNMLKitPoseDetectioniOSMLKPose() {
    pose = nil;
}

static SKRNMLKitPoseDetectionMLKPoseLandmark landmarkForMLKPoseLandmark(MLKPoseLandmark *l) {
    auto toPush = SKRNMLKitPoseDetectionMLKPoseLandmark();
    Point3D p;
    p.x = l.position.x; p.y = l.position.y; p.z = l.position.z;
    toPush.type = [mapNativeLandmarkNamesToStringNames[l.type] cStringUsingEncoding:NSUTF8StringEncoding];
    toPush.position = std::move(p);
    toPush.inFrameLikelihood = l.inFrameLikelihood;
    return toPush;
}

std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> SKRNMLKitPoseDetectioniOSMLKPose::landmarks() {
    std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> ret;
    NSArray <MLKPoseLandmark *>*landmarks = [pose landmarks];
    for(MLKPoseLandmark *l in landmarks) {
        auto toPush = landmarkForMLKPoseLandmark(l);
        ret.push_back(std::move(toPush));
    }
    return ret;
}

SKRNMLKitPoseDetectionMLKPoseLandmark SKRNMLKitPoseDetectioniOSMLKPose::landmarkOfType(std::string landmarkType) {
    MLKPoseLandmark *l = [pose landmarkOfType:mapStringLandmarkNamesToNativeNames[[NSString stringWithUTF8String:landmarkType.c_str()]]];
    return landmarkForMLKPoseLandmark(l);
}


#endif
