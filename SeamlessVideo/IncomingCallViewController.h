//
//  IncomingCallViewController.h
//  SeamlessVideo
//
//  Created by Sumit Pasupalak on 7/9/13.
//  Copyright (c) 2013 Sumit Pasupalak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Opentok/Opentok.h>

@class IncomingCallViewController;

@protocol IncomingCallViewControllerDelegate <NSObject>
- (void)answerCall:(IncomingCallViewController *)controller response:(BOOL)answer stream:(OTStream*) stream;
@end

@interface IncomingCallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *accept;
@property (weak, nonatomic) IBOutlet UIButton *reject;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *device;
@property (strong, nonatomic) OTStream* stream;
@property (nonatomic, weak) id <IncomingCallViewControllerDelegate> delegate;

@end
