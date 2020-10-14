/**
 * titanium-crashlytics
 *
 * Created by Hans Knoechel
 * Copyright (c) 2020 by Hans Knöchel. All rights reserved.
 */

#import "TiCrashlyticsModule.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiExceptionHandler.h"
#import "TiHost.h"
#import "TiUtils.h"

#import <FirebaseCrashlytics/FirebaseCrashlytics.h>

@implementation TiCrashlyticsModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"108ab55a-0cbb-4c63-ade2-536dabdfa250";
}

- (NSString *)moduleId
{
  return @"ti.crashlytics";
}

#pragma Public APIs

- (void)setUserIdentifier:(id)userIdentifier
{
  ENSURE_SINGLE_ARG(userIdentifier, NSString);
  [[FIRCrashlytics crashlytics] setUserID:userIdentifier];
}

- (void)log:(id)value
{
  ENSURE_SINGLE_ARG(value, NSString);
  [[FIRCrashlytics crashlytics] logWithFormat:@"%@", value];
}

- (void)crash:(id)unused
{
  assert(NO); // Forces a crash
}

- (void)recordError:(id)errorInfo
{
  ENSURE_SINGLE_ARG(errorInfo, NSDictionary);

  NSDictionary *userInfo = @{
    NSLocalizedDescriptionKey: NSLocalizedString([errorInfo objectForKey:@"description"], nil),
    NSLocalizedFailureReasonErrorKey: NSLocalizedString([errorInfo objectForKey:@"key"], nil),
    NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString([errorInfo objectForKey:@"suggestion"], nil)
  };

  NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
    code:-1001
    userInfo:userInfo];

  [[FIRCrashlytics crashlytics] recordError:error];
}

- (void)setCustomKeyValue:(id)customKey
{
  ENSURE_SINGLE_ARG(customKey, NSDictionary);
  [[FIRCrashlytics crashlytics] setCustomValue:NSLocalizedString([customKey objectForKey:@"value"], nil) forKey:NSLocalizedString([customKey objectForKey:@"key"], nil)];
}

@end
