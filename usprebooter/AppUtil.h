//
//  AppUtil.h
//  usprebooter
//
//  Created by LL on 7/12/23.
//

#ifndef AppUtil_h
#define AppUtil_h
typedef struct __SecCode const *SecStaticCodeRef;
typedef CF_OPTIONS(uint32_t, SecCSFlags) {
    kSecCSDefaultFlags = 0
};
#define kSecCSRequirementInformation 1 << 2
extern const CFStringRef kSecCodeInfoTeamIdentifier;
#define kSecCSSigningInformation 1 << 1
OSStatus SecStaticCodeCreateWithPathAndAttributes(CFURLRef path, SecCSFlags flags, CFDictionaryRef attributes, SecStaticCodeRef *staticCode);
OSStatus SecCodeCopySigningInformation(SecStaticCodeRef code, SecCSFlags flags, CFDictionaryRef *information);
CFDataRef SecCertificateCopyExtensionValue(SecCertificateRef certificate, CFTypeRef extensionOID, bool *isCritical);

NSString *getTeamID(NSString *bundleID);
//NSArray<App *> *getUserApps(void);

#endif /* AppUtil_h */
