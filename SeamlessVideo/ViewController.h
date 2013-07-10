//
//  ViewController.h
//  SeamlessVideo
//
//  Created by Sumit Pasupalak on 7/8/13.
//  Copyright (c) 2013 Sumit Pasupalak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>
#import "IncomingCallViewController.h"
#import "ServerBrowser.h"
#import "AFNetworking.h"
#import "URLPath.h"

@interface ViewController : UIViewController <OTSessionDelegate, OTSubscriberDelegate, OTPublisherDelegate, IncomingCallViewControllerDelegate> {
    NSString* host;
    NSInteger port;
}

@property (nonatomic, strong) NSString* host;
@property (nonatomic, assign) NSInteger port;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *receiveCall;
@property (strong, nonatomic) ServerBrowser* serverBrowser;

@end
