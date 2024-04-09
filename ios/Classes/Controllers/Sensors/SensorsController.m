//
//  SensorsController.m
//  camerawesome
//
//  Created by Dimitri Dessus on 28/03/2023.
//

#import "SensorsController.h"
#import "Pigeon.h"
#import <ARKit/ARKit.h>

@implementation SensorsController

+ (NSArray *)getSensors:(AVCaptureDevicePosition)position {
  NSMutableArray *sensors = [NSMutableArray new];
  
  NSArray *sensorsType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera, AVCaptureDeviceTypeBuiltInUltraWideCamera, AVCaptureDeviceTypeBuiltInTrueDepthCamera, AVCaptureDeviceTypeBuiltInLiDARDepthCamera];
  
  AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession
                                                       discoverySessionWithDeviceTypes:sensorsType
                                                       mediaType:AVMediaTypeVideo
                                                       position:AVCaptureDevicePositionUnspecified];
  
  for (AVCaptureDevice *device in discoverySession.devices) {
    PigeonSensorType type;
    if (device.deviceType == AVCaptureDeviceTypeBuiltInTelephotoCamera) {
      type = PigeonSensorTypeTelephoto;
    } else if (device.deviceType == AVCaptureDeviceTypeBuiltInUltraWideCamera) {
      type = PigeonSensorTypeUltraWideAngle;
    } else if (device.deviceType == AVCaptureDeviceTypeBuiltInTrueDepthCamera) {
      type = PigeonSensorTypeTrueDepth;
    } else if (device.deviceType == AVCaptureDeviceTypeBuiltInWideAngleCamera) {
      type = PigeonSensorTypeWideAngle;
    } else if (@available(iOS 15.4, *)) {
        if (device.deviceType == AVCaptureDeviceTypeBuiltInLiDARDepthCamera) {
            type = PigeonSensorTypeLidar;
        } else {
            type = PigeonSensorTypeUnknown;
        }
    } else {
        type = PigeonSensorTypeUnknown;
    }
    
    PigeonSensorTypeDevice *sensorType = [PigeonSensorTypeDevice makeWithSensorType:type name:device.localizedName iso:[NSNumber numberWithFloat:device.ISO] flashAvailable:[NSNumber numberWithBool:device.flashAvailable] uid:device.uniqueID];
    
    if (device.position == position) {
      [sensors addObject:sensorType];
    }
  }
  
  return sensors;
}

@end
