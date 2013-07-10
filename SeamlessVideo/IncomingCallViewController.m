//
//  IncomingCallViewController.m
//  SeamlessVideo
//
//  Created by Sumit Pasupalak on 7/9/13.
//  Copyright (c) 2013 Sumit Pasupalak. All rights reserved.
//

#import "IncomingCallViewController.h"

@interface IncomingCallViewController ()

@end

@implementation IncomingCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.accept.alpha = 0.5;
    self.reject.alpha = 0.5;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)acceptedCall:(id)sender {
    [self.delegate answerCall:self response:YES stream:self.stream];
    
}

- (IBAction)rejectedCall:(id)sender {
    [self.delegate answerCall:self response:NO stream:self.stream];
    
}

@end
