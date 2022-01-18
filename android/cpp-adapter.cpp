#include <jni.h>
#include "react-native-mlkit-pose-detection.h"

extern "C"
JNIEXPORT jint JNICALL
Java_com_reactnativemlkitposedetection_MlkitPoseDetectionModule_nativeMultiply(JNIEnv *env, jclass type, jint a, jint b) {
    return SKRNMLKitPoseDetection::multiply(a, b);
}
