//
//  URLPath.h
//  SmartShare
//
//  Created by Sumit Pasupalak on 7/1/13.
//  Copyright (c) 2013 Sumit Pasupalak. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLPath : NSObject

+(NSString*) urlwithHost:(NSString*)host andPort:(NSInteger) port;
+(NSString*) urlForPresentation:(NSString*) type withHost:(NSString*)host andPort:(NSInteger) port;
+(NSString*) urlForPhotos:(NSString*) type withHost:(NSString*)host andPort:(NSInteger) port;
+(NSString*) urlForVideos:(NSString*) type withHost:(NSString*)host andPort:(NSInteger) port;

@end
