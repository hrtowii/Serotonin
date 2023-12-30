//
//  AppUtil.m
//  usprebooter
//
//  Created by LL on 7/12/23.
//

#import <Foundation/Foundation.h>
#import "AppUtil.h"
#include "CoreServices.h"
@interface App : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation App
@end


NSArray<App *> *getUserApps(void) {
    NSMutableArray<App *> *allApps = [NSMutableArray array];

    NSURL *userAppsDir = [NSURL fileURLWithPath:@"/var/containers/Bundle/Application" isDirectory:true];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:userAppsDir.path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];

    for (NSURL *urls in array) {
        NSArray *finalArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:urls.path] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];

        for (NSURL *url in finalArray) {
            if (![url.absoluteString hasSuffix:@".app/"]) continue;

            NSURL *infoPlistURL = [url URLByAppendingPathComponent:@"Info.plist"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:infoPlistURL.path]) continue;

            NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfURL:infoPlistURL error:nil];
            NSString *appName = [infoPlist objectForKey:@"CFBundleDisplayName"];

            if (appName == nil) {
                NSString *path = urls.path;
                appName = [[[url.absoluteString stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:path withString:@""] stringByReplacingOccurrencesOfString:@"file:/" withString:@""];
            }

            NSString *appIdentifier = [infoPlist objectForKey:@"CFBundleIdentifier"];
            App *app = [App new];
            app.appName = appName;
            app.appIdentifier = appIdentifier;
            app.filePath = url.path;

            [allApps addObject:app];
        }
    }

    return [allApps copy];
}


SecStaticCodeRef getStaticCodeRef(NSString *binaryPath)
{
    if(binaryPath == nil)
    {
        return NULL;
    }
    
    CFURLRef binaryURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)binaryPath, kCFURLPOSIXPathStyle, false);
    if(binaryURL == NULL)
    {
        NSLog(@"[getStaticCodeRef] failed to get URL to binary %@", binaryPath);
        return NULL;
    }
    
    SecStaticCodeRef codeRef = NULL;
    OSStatus result;
    
    result = SecStaticCodeCreateWithPathAndAttributes(binaryURL, kSecCSDefaultFlags, NULL, &codeRef);
    
    CFRelease(binaryURL);
    
    if(result != errSecSuccess)
    {
        NSLog(@"[getStaticCodeRef] failed to create static code for binary %@", binaryPath);
        return NULL;
    }
        
    return codeRef;
}


NSString *getTeamID(NSString *bundleID) {
    LSApplicationProxy *app = [LSApplicationProxy applicationProxyForIdentifier:bundleID];
    NSString *binaryPath = app.canonicalExecutablePath;

    SecStaticCodeRef staticCodeRef = getStaticCodeRef(binaryPath);
    CFDictionaryRef signingInformation = NULL;
    OSStatus result;

    result = SecCodeCopySigningInformation(staticCodeRef, kSecCSSigningInformation, &signingInformation);
    if (result != errSecSuccess) {
        NSLog(@"ERROR: SecCodeCopySigningInformation failed with error: %d", result);
        return NULL;
    }
    CFStringRef teamID = CFDictionaryGetValue(signingInformation, kSecCodeInfoTeamIdentifier);

    return (__bridge NSString *)teamID;
}
