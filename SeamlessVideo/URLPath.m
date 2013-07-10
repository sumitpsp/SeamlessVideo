//
//  URLPath.m
//  SmartShare
//
//  Created by Sumit Pasupalak on 7/1/13.
//  Copyright (c) 2013 Sumit Pasupalak. All rights reserved.
//

#import "URLPath.h"

@implementation URLPath

+(NSString*) urlwithHost:(NSString*)host andPort:(NSInteger) port {
    NSString* url = [NSString stringWithFormat:@"http://%@:%d", host, port];
    return url;
}

+(NSString*) urlForPresentation:(NSString*) type withHost:(NSString*)host andPort:(NSInteger) port {
    NSString* url;
    if([type isEqualToString:@"open"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/presentation/open", host, port];
    }
    else if([type isEqualToString:@"close"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/presentation/close", host, port];
    }
    else if([type isEqualToString:@"next"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/presentation/next", host, port];
    }
    else if([type isEqualToString:@"previous"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/presentation/previous", host, port];
    }
    else {
        url = nil;
    }
    NSLog(@"Presentation Request url is %@", url);
    return url;
}

+(NSString*) urlForPhotos:(NSString*) type withHost:(NSString*)host andPort:(NSInteger) port {
    NSString* url;
    if([type isEqualToString:@"open"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/photos/open", host, port];
    }
    else if([type isEqualToString:@"close"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/photos/close", host, port];
    }
    else if([type isEqualToString:@"background"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/photos/background", host, port];
    }
    else {
        url = nil;
    }
    NSLog(@"Photos url is %@", url);
    return url;
}

+(NSString*) urlForVideos:(NSString*) type withHost:(NSString*)host andPort:(NSInteger) port {
    NSString* url;
    if([type isEqualToString:@"open"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/videos/open", host, port];
    }
    else if([type isEqualToString:@"play"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/videos/play", host, port];
    }
    else if([type isEqualToString:@"pause"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/videos/pause", host, port];
    }
    else if([type isEqualToString:@"close"]) {
        url = [NSString stringWithFormat:@"http://%@:%d/videos/close", host, port];
    }
    else {
        url = nil;
        
    }
    NSLog(@"Videos url is %@", url);
    return url;
}

@end
