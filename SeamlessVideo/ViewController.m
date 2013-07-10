//
//  ViewController.m
//  SampleApp
//
//  Created by Charley Robinson on 12/13/11.
//  Copyright (c) 2011 Tokbox, Inc. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}
static double widgetHeight = 0;
static double widgetWidth = 0;

static double subscriberWidgetWidth = 320;
static double subscriberWidgetHeight = 480;

// *** Fill the following variables using your own Project info from the Dashboard  ***
// ***                  (https://dashboard.tokbox.com/projects)                     ***
static NSString* const kApiKey = @"34150602";    // Replace with your API Key
static NSString* const kSessionId = @"1_MX4zNDE1MDYwMn4xMjcuMC4wLjF-V2VkIEp1bCAxMCAxNDo0OTowNCBQRFQgMjAxM34wLjQ3NTgzMTJ-"; // Replace with your generated Session ID
static NSString* const kToken = @"T1==cGFydG5lcl9pZD0zNDE1MDYwMiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz05M2RjNGQ2YmE5NWJjMmE4M2Y2ZDYyOGJmMjZmMDBjYWUzZTRkMTliOnJvbGU9cHVibGlzaGVyJnNlc3Npb25faWQ9MV9NWDR6TkRFMU1EWXdNbjR4TWpjdU1DNHdMakYtVjJWa0lFcDFiQ0F4TUNBeE5EbzBPVG93TkNCUVJGUWdNakF4TTM0d0xqUTNOVGd6TVRKLSZjcmVhdGVfdGltZT0xMzczNDkyOTQ4Jm5vbmNlPTAuNDE3NzQ1NTgwNTgxMzA1NCZleHBpcmVfdGltZT0xMzc2MDg0OTQ5JmNvbm5lY3Rpb25fZGF0YT0=";     // Replace with your generated Token (use Project Tools or from a server-side library)

static bool subscribeToSelf = NO; // Change to NO if you want to subscribe to streams other than your own.

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _session = [[OTSession alloc] initWithSessionId:kSessionId
                                           delegate:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    self.receiveCall.hidden = TRUE;
    //[self.message setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    self.message.font = [self.message.font fontWithSize:24];
    self.serverBrowser = [[ServerBrowser alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverEvent:) name:@"ServerNotification" object:nil];
    [self.serverBrowser start];
    [self doConnect];
}

- (void) serverEvent:(NSNotification *)notification {
    NSLog(@"VideoCall View received New Server Info");
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* temp = [userInfo objectForKey:@"port"];
    host = [userInfo objectForKey:@"host"];
    port = [temp integerValue];
    
    NSLog(@"Host is %@ and port is %d", host, port);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    } else {
        return NO;
    }
}

- (void)updateSubscriber {
    for (NSString* streamId in _session.streams) {
        OTStream* stream = [_session.streams valueForKey:streamId];
        if (![stream.connection.connectionId isEqualToString: _session.connection.connectionId]) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            break;
        }
    }
}


#pragma mark - OpenTok methods

- (void)doConnect
{
    [_session connectWithApiKey:kApiKey token:kToken];
}

- (void)answerCall:(IncomingCallViewController *)controller response:(BOOL)answer stream:(OTStream *)stream {
    
    if(answer == YES) {
        [self.message setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
        self.message.text = @"Your Call is starting";
        [self dismissViewControllerAnimated:YES completion:nil];
        [self doPublish];
        _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    }
    else {
        [self.message setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
        self.message.text = @"Your ended your call";
        [self dismissViewControllerAnimated:YES completion:nil];
        [_session disconnect];
    }
}

- (void)doPublish
{
    _publisher = [[OTPublisher alloc] initWithDelegate:self];
    [_publisher setName:[[UIDevice currentDevice] name]];
    [_session publish:_publisher];
    [_publisher.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
    //[self.view addSubview:_publisher.view];
    //self.view.bounds = _publisher.view.bounds;
}
- (IBAction)receiveCallRequested:(id)sender {
    _session = [[OTSession alloc] initWithSessionId:kSessionId
                                           delegate:self];
    [self doConnect];
}

- (void)sessionDidConnect:(OTSession*)session
{
    self.receiveCall.hidden = TRUE;
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage = [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    //[self showAlert:alertMessage];
    self.receiveCall.hidden = FALSE;
}


- (void)session:(OTSession*)mySession didReceiveStream:(OTStream*)stream
{
    NSLog(@"session didReceiveStream (%@)", stream.streamId);
    
    // See the declaration of subscribeToSelf above.
    if ( (subscribeToSelf && [stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ||
        (!subscribeToSelf && ![stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ) {
        if (!_subscriber) {
            //[self performSegueWithIdentifier:@"call" sender:self];
            NSString * storyboardName = @"MainStoryboard";
            NSString * viewControllerID = @"IncomingCall";
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            IncomingCallViewController * controller = (IncomingCallViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
            controller.delegate = self;
            controller.stream = stream;
            [self presentViewController:controller animated:YES completion:nil];
            //[self doPublish];
            
        }
    }
}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
    NSLog(@"session didDropStream (%@)", stream.streamId);
    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
    if (!subscribeToSelf
        && _subscriber
        && [_subscriber.stream.streamId isEqualToString: stream.streamId])
    {
        UIView* videoView = [self.view viewWithTag:100];
        [videoView removeFromSuperview];
       // [_session unpublish:_publisher];
        _subscriber = nil;
        _publisher = nil;
        [self updateSubscriber];
    }
}

- (IBAction) shareRequested:(id)sender {
    NSLog(@"Share Requested");
    NSString* url = [URLPath urlwithHost:host andPort:port];
    NSLog(@"URL is %@",url);
    NSURL *urlPath = [NSURL URLWithString:url];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlPath];
    [httpClient postPath:@"/videocall/start" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        self.message.text = @"Call transferred";
        UIView* videoView = [self.view viewWithTag:100];
        [videoView removeFromSuperview];
        [_subscriber close];
        [_session unpublish:_publisher];
        [_session disconnect];
        [self updateSubscriber];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (IBAction) endRequested:(id)sender {
    NSLog(@"End Requested");
    self.message.text = @"Your ended your call";
    UIView* videoView = [self.view viewWithTag:100];
    [videoView removeFromSuperview];
    [_subscriber close];
    [_session unpublish:_publisher];
    [_session disconnect];
    [self updateSubscriber];    
    
}

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
   // [subscriber.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    subscriber.view.videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    subscriber.view.videoView.bounds = self.view.bounds;
    //  subscriber.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    subscriber.view.videoView.tag = 100;
    
    //Create In call buttons
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 20, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"arrow-right3.png"];
    [playButton setBackgroundImage:image forState:UIControlStateNormal];
    [playButton addTarget: self
                   action: @selector(shareRequested:)
         forControlEvents: UIControlEventTouchDown];
    
    UIButton *endButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 320, 60)];
    UIImage *endImage = [UIImage imageNamed:@"red.jpg"];
    [endButton setBackgroundImage:endImage forState:UIControlStateNormal];
    [endButton addTarget: self
                   action: @selector(endRequested:)
         forControlEvents: UIControlEventTouchDown];
    endButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    [endButton setTitle:@"End Call" forState:UIControlStateNormal];
    
    [subscriber.view.videoView addSubview:playButton];
    [subscriber.view.videoView addSubview:endButton];
    [self.view addSubview:subscriber.view.videoView];
}

- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error {
    NSLog(@"publisher didFailWithError %@", error);
    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"sessionDidFail");
    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}


- (void)showAlert:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from video session"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end

