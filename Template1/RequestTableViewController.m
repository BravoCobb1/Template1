//
//  RequestTableViewController.m
//  Template1
//
//  Created by Collier, Jeff on 3/2/13.
//  Copyright (c) 2013 Jeff Collier. All rights reserved.
//

#import "RequestTableViewController.h"

@interface RequestTableViewController ()

@property (nonatomic) NSMutableData *receivedData;

- (IBAction)inviteJeff:(id)sender;
- (IBAction)inviteJonathan:(id)sender;

@end

@implementation RequestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)inviteJeff:(id)sender
{
    [self sendInvitationToNumber:@"%2B14043863975"];
}

- (IBAction)inviteJonathan:(id)sender
{
    [self sendInvitationToNumber:@"%2B19196193963"];
}

- (void)sendInvitationToNumber:(NSString *)toNumberString
{
    NSMutableURLRequest *smsPostRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twilio.com/2010-04-01/Accounts/AC32c2c40bf031902d2f0483f6a8770a95/SMS/Messages.json"]];
    
    [smsPostRequest setHTTPMethod: @"POST"];
    //[smsPostRequest addValue:@"%2B12029993740" forHTTPHeaderField:@"From"];
    //[smsPostRequest addValue:@"%2B14043863975" forHTTPHeaderField:@"To"];
    
    // TODO: Figure out the import for NSData+Base64 and replace the hard-coding. Also move to Keychain
    /*NSString *authString = [NSString stringWithFormat:@"%@:%@",
                            @"AC32c2c40bf031902d2f0483f6a8770a95",
                            @"9a90a634c7a56057845f12e9d196702a"];
    NSData *authBytes = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authBase64 = [NSString stringWithFormat:@"Basic %@", [authBytes base64EncodingWithLineLength:80]];*/
    NSString *authBase64 = @"QUMzMmMyYzQwYmYwMzE5MDJkMmYwNDgzZjZhODc3MGE5NTo5YTkwYTYzNGM3YTU2MDU3ODQ1ZjEyZTlkMTk2NzAyYQ==";
    [smsPostRequest setValue:authBase64 forHTTPHeaderField:@"Authorization"];
    
    NSString *httpBodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@",
                              @"%2B12029993740",
                              toNumberString,
                              @"How+bout+them+apples"];    
    // TODO: Replace with C CFURLCreateStringByAddingPercentEscapes after reading why it does not always work */
    NSString *httpBodyEncodedString = httpBodyString;
    NSData *httpBodyBytes = [httpBodyEncodedString dataUsingEncoding:NSUTF8StringEncoding];
    [smsPostRequest setHTTPBody:httpBodyBytes];

    NSURLConnection *smsPostConnection = [[NSURLConnection alloc] initWithRequest:smsPostRequest delegate:self startImmediately:YES];
    
    if (smsPostConnection)
    {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
    }
    else
    {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // receivedData is declared as a method instance elsewhere
    self.receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    NSLog(@"Response text = %@", [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);

    self.receivedData = nil;
}

// Handle basic authentication challenge if needed
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSString *username = @"AC32c2c40bf031902d2f0483f6a8770a95";
    NSString *password = @"9a90a634c7a56057845f12e9d196702a";
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                             password:password
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}
@end
