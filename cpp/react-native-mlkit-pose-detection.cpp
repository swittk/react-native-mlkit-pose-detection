#include "react-native-mlkit-pose-detection.h"
#include <jsi/jsi.h>
#include <map>
#include <string>
#include <ReactCommon/CallInvoker.h>
#include "CPPNumericStringHashCompare.h"
#include <sstream>

using namespace facebook;
using namespace jsi;
using namespace SKRNMLKitPoseDetection;

jsi::Object Point3D::toJSIObject(facebook::jsi::Runtime &runtime) {
    jsi::Object ret = jsi::Object(runtime);
    ret.setProperty(runtime, "x", x);
    ret.setProperty(runtime, "y", y);
    ret.setProperty(runtime, "z", z);
    return ret;
}

jsi::Object SKRNMLKitPoseDetectionMLKPoseLandmark::toJSIObject(facebook::jsi::Runtime &runtime) {
    jsi::Object ret = jsi::Object(runtime);
    ret.setProperty(runtime, "inFrameLikelihood", inFrameLikelihood);
    ret.setProperty(runtime, "type", jsi::String::createFromUtf8(runtime, type));
    ret.setProperty(runtime, "position", position.toJSIObject(runtime));
//    printf("conv %f, %s, (%f,%f,%f)", inFrameLikelihood, type.c_str(), position.x, position.y, position.z);
    return ret;
}

facebook::jsi::Value SKRNMLKitPoseDetectionMLKPose::get(facebook::jsi::Runtime &runtime, const facebook::jsi::PropNameID &name) {
    std::string methodName = name.utf8(runtime);
    long long methodSwitch = string_hash(methodName.c_str());
    switch (methodSwitch) {
        case "landmarks"_sh:{
            return jsi::Function::createFromHostFunction
            (runtime, name, 0, [&](jsi::Runtime &runtime, const jsi::Value &thisValue, const jsi::Value *arguments, size_t count) -> jsi::Value
             {
                std::vector<SKRNMLKitPoseDetectionMLKPoseLandmark> lm = landmarks();
                jsi::Array ret = jsi::Array(runtime, lm.size());
                for(int i = 0; i < lm.size(); i++) {
                    ret.setValueAtIndex(runtime, i, lm[i].toJSIObject(runtime));
                }
                return ret;
            });
        } break;
        case "landmarkOfType"_sh:{
            return jsi::Function::createFromHostFunction
            (runtime, name, 1, [&](jsi::Runtime &runtime, const jsi::Value &thisValue, const jsi::Value *arguments, size_t count) -> jsi::Value
             {
                if(count < 1) return jsi::Value::undefined();
                std::string landmarkType = arguments[0].asString(runtime).utf8(runtime);
                return landmarkOfType(landmarkType).toJSIObject(runtime);
            });
        } break;
        default: return jsi::Value::undefined();
    }
    return jsi::Value::undefined();
}
static std::vector<std::string> nativeMLKPoseHostObjectKeys = {
    "landmarks",
    "landmarkOfType",
};

std::vector<facebook::jsi::PropNameID> SKRNMLKitPoseDetectionMLKPose::getPropertyNames(facebook::jsi::Runtime& rt) {
    std::vector<jsi::PropNameID> ret;
    for(std::string key : nativeMLKPoseHostObjectKeys) {
        ret.push_back(jsi::PropNameID::forUtf8(rt, key));
    }
    return ret;
}


facebook::jsi::Value SKRNMLKitPoseDetector::get(facebook::jsi::Runtime &runtime, const facebook::jsi::PropNameID &name) {
    std::string methodName = name.utf8(runtime);
    long long methodSwitch = string_hash(methodName.c_str());
    switch (methodSwitch) {
#ifdef HAS_SKRN_NATIVE_VIDEO
        case "process"_sh:{
            return jsi::Function::createFromHostFunction(runtime, name, 1, [&](jsi::Runtime &runtime, const jsi::Value &thisValue, const jsi::Value *arguments,
                                                                               size_t count) -> jsi::Value
                                                         {
                if(count < 1) {
                    throw jsi::JSError(runtime, "1 argument is expected for `process`");
                }
                std::shared_ptr<SKRNNativeVideo::SKNativeFrameWrapper> obj = arguments[0].asObject(runtime).asHostObject<SKRNNativeVideo::SKNativeFrameWrapper>(runtime);
                std::vector<std::shared_ptr<SKRNMLKitPoseDetectionMLKPose>> results = process(obj);
                jsi::Array ret = jsi::Array(runtime, results.size());
                for(int i = 0; i < results.size(); i++) {
                    ret.setValueAtIndex(runtime, i, jsi::Object::createFromHostObject(runtime, results[i]));
                }
                return ret;
            });
        } break;
#endif
        default: return jsi::Value::undefined();
    }
    return jsi::Value::undefined();
}
static std::vector<std::string> nativeSKRNMLKitPoseDetectorKeys = {
#ifdef HAS_SKRN_NATIVE_VIDEO
    "process"
#endif
};

std::vector<facebook::jsi::PropNameID> SKRNMLKitPoseDetector::getPropertyNames(facebook::jsi::Runtime& rt) {
    std::vector<jsi::PropNameID> ret;
    for(std::string key : nativeSKRNMLKitPoseDetectorKeys) {
        ret.push_back(jsi::PropNameID::forUtf8(rt, key));
    }
    return ret;
}



void SKRNMLKitPoseDetection::install(facebook::jsi::Runtime &jsiRuntime, std::function<std::shared_ptr<SKRNMLKitPoseDetector>(facebook::jsi::Runtime&, bool accurate, PoseDetectorDetectionMode detectionMode)> poseDetectorConstructor) {
    
    auto poseDetectorConstructorFunction =
    jsi::Function::createFromHostFunction
    (
     jsiRuntime,
     PropNameID::forAscii(jsiRuntime, "SKRNMLKitPoseDetectionNewPoseDetector"),
     2,
     //                                          [&, invoker](Runtime &runtime, const Value &thisValue, const Value *arguments,
     [&, poseDetectorConstructor](Runtime &runtime, const Value &thisValue, const Value *arguments,
                                  size_t count) -> Value
     {
         bool accurate = (count >= 1 && arguments[0].isBool()) ? arguments[0].getBool() : false;
         std::string detectionModeString = (count >= 2 && arguments[1].isString()) ? arguments[1].getString(runtime).utf8(runtime) : "stream";
         PoseDetectorDetectionMode mode = (detectionModeString == "stream") ? PoseDetectorDetectionModeStream : PoseDetectorDetectionModeSingleImage;
        std::shared_ptr<SKRNMLKitPoseDetector> obj = poseDetectorConstructor(runtime, accurate, mode);
         jsi::Object object = jsi::Object::createFromHostObject(runtime, obj);
         return object;
     });
    jsiRuntime.global().setProperty(jsiRuntime, "SKRNMLKitPoseDetectionNewPoseDetector",
                                    std::move(poseDetectorConstructorFunction));
}
//void install(facebook::jsi::Runtime &jsiRuntime, std::shared_ptr<facebook::react::CallInvoker> invoker);
void SKRNMLKitPoseDetection::cleanup(facebook::jsi::Runtime &jsiRuntime) {
    
}
