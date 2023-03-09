//
//  ExposePrivateHeader.h
//  deviceID
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNCDeviceInfo : NSObject

+ (BNCDeviceInfo *)getInstance;

- (void)registerPluginName:(NSString *)name version:(NSString *)version;

- (NSDictionary *) v2dictionary;

/*
 Thread safety is the callee's responsibility!
 
 BNCServerInterface.updateDeviceInfoToMutableDictionary, BNCAppGroupsData.saveAppClipData and unit tests use these.
 */

- (void)checkAdvertisingIdentifier;

@property (nonatomic, copy, readwrite) NSString *hardwareId;
@property (nonatomic, copy, readwrite) NSString *hardwareIdType;
@property (nonatomic, assign, readwrite) BOOL isRealHardwareId;

@property (nonatomic, copy, readwrite) NSString *advertiserId;
@property (nonatomic, copy, readwrite) NSString *vendorId;
@property (nonatomic, copy, readwrite) NSString *optedInStatus;
@property (nonatomic, assign, readwrite) BOOL isFirstOptIn;
@property (nonatomic, assign, readwrite) BOOL isAdTrackingEnabled;
@property (nonatomic, assign, readwrite) BOOL unidentifiedDevice;
- (NSString *)localIPAddress;
- (NSString *)connectionType;

@property (nonatomic, copy, readwrite) NSString *brandName;
@property (nonatomic, copy, readwrite) NSString *modelName;
@property (nonatomic, copy, readwrite) NSString *osName;
@property (nonatomic, copy, readwrite) NSString *osVersion;
@property (nonatomic, copy, readwrite) NSString *osBuildVersion;
@property (nonatomic, copy, readwrite) NSString *environment;
@property (nonatomic, copy, readwrite) NSString *cpuType;
@property (nonatomic, copy, readwrite) NSNumber *screenWidth;
@property (nonatomic, copy, readwrite) NSNumber *screenHeight;
@property (nonatomic, copy, readwrite) NSNumber *screenScale;
@property (nonatomic, copy, readwrite) NSString *carrierName;
@property (nonatomic, copy, readwrite) NSString *locale;
@property (nonatomic, copy, readwrite) NSString *country; //!< The iso2 Country name (us, in,etc).
@property (nonatomic, copy, readwrite) NSString *language; //!< The iso2 language code (en, ml).
- (NSString *)userAgentString;

@property (nonatomic, copy, readwrite) NSString *applicationVersion;
@property (nonatomic, copy, readwrite) NSString *pluginName;
@property (nonatomic, copy, readwrite) NSString *pluginVersion;
@property (nonatomic, copy, readwrite) NSString *branchSDKVersion;

- (BOOL)isAppClip;

@end


@interface ExposePrivateHeader : NSObject

@end

NS_ASSUME_NONNULL_END
