const fs = require('fs');
const writeFileSync = fs.writeFileSync;

const str =
  `/** The landmark which corresponds to the nose. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeNose;

/** The landmark which corresponds to the left eye inner edge. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftEyeInner;

/** The landmark which corresponds to the left eye. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftEye;

/** The landmark which corresponds to the left eye outer edge. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftEyeOuter;

/** The landmark which corresponds to the right eye inner edge. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightEyeInner;

/** The landmark which corresponds to the right eye. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightEye;

/** The landmark which corresponds to the right eye outer edge. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightEyeOuter;

/** The landmark which corresponds to the left ear. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftEar;

/** The landmark which corresponds to the right ear. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightEar;

/** The landmark which corresponds to the left mouth edge. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeMouthLeft;

/** The landmark which corresponds to the right mouth edge. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeMouthRight;

/** The landmark which corresponds to the left shoulder. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftShoulder;

/** The landmark which corresponds to the right shoulder. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightShoulder;

/** The landmark which corresponds to the left elbow. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftElbow;

/** The landmark which corresponds to the right elbow. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightElbow;

/** The landmark which corresponds to the left wrist. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftWrist;

/** The landmark which corresponds to the right wrist. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightWrist;

/** The landmark which corresponds to the pinky finger on the left hand. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftPinkyFinger;

/** The landmark which corresponds to the pinky finger on the right hand. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightPinkyFinger;

/** The landmark which corresponds to the index finger on the left hand. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftIndexFinger;

/** The landmark which corresponds to the index finger on the right hand. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightIndexFinger;

/** The landmark which corresponds to the left thumb. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftThumb;

/** The landmark which corresponds to the right thumb. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightThumb;

/** The landmark which corresponds to the left hip. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftHip;

/** The landmark which corresponds to the right hip. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightHip;

/** The landmark which corresponds to the left knee. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftKnee;

/** The landmark which corresponds to the right knee. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightKnee;

/** The landmark which corresponds to the left ankle. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftAnkle;

/** The landmark which corresponds to the right ankle. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightAnkle;

/** The landmark which corresponds to the left heel. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftHeel;

/** The landmark which corresponds to the right heel. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightHeel;

/** The landmark which corresponds to the toe on the left foot. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeLeftToe;

/** The landmark which corresponds to the toe on the right foot. */
extern MLKPoseLandmarkType const MLKPoseLandmarkTypeRightToe;`

const startNameIdx = `extern MLKPoseLandmarkType const MLKPoseLandmarkType`.length;
const nameToNative = str.split('\n').filter((line) => line.startsWith('extern MLKPoseLandmarkType')).map((v) => {
  const fromNameOnwards = v.slice(startNameIdx);
  const name = fromNameOnwards.split(';')[0];
  const nativeName = v.slice(`extern MLKPoseLandmarkType const `.length).split(';')[0];
  return { name, nativeName };
})

const outStr = `{
  ${nameToNative.map(({ name, nativeName }) => {
  return `@"${name}": ${nativeName}`
}).join(',\n  ')}
}`;
const outStr2 = `{
  ${nameToNative.map(({ name, nativeName }) => {
  return `${nativeName}: @"${name}"`
}).join(',\n  ')}
}`;
const outStr3 = `${nameToNative.map((v)=>{return `"${v.name}"`}).join(', ')}`

writeFileSync('./nativeObjCMap.txt', outStr);
writeFileSync('./nativeCtoObjCMap.txt', outStr2);
writeFileSync('./tsnames.txt', outStr3);