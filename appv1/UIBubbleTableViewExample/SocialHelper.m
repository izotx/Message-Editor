//iOSSocialHelper
//===============
//
//iOS 6 Social Framework Helper
//
//Copyright (c) 2012 DJ Mobile Inc
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//1. Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//3. All advertising materials mentioning features or use of this software
//must display the following acknowledgement:
//This product includes software developed by the DJ Mobile Inc
//4. Neither the name of the DJ Mobile Inc nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY DJ Mobile Inc ''AS IS'' AND ANY
//EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL DJ Mobile Inc BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "SocialHelper.h"

@implementation SocialHelper
@synthesize socialServiceTypesEnabled;

-(id)init{
    self = [super init];
    if(self)
    {
        //check service types
        socialServiceTypesEnabled = [[NSMutableArray alloc]initWithCapacity:0];
        [self checkServiceTypes];
    }
    return self;
}

-(NSArray * )checkServiceTypes{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        [socialServiceTypesEnabled addObject:SLServiceTypeFacebook];
    }
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        [socialServiceTypesEnabled addObject:SLServiceTypeTwitter];
    }
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]){
        [socialServiceTypesEnabled addObject:SLServiceTypeSinaWeibo];
    }
    return [NSArray arrayWithArray:self.socialServiceTypesEnabled];
}

-(BOOL)isServiceEnabled:(NSString *)service{
    for(NSString * _serviceType in socialServiceTypesEnabled)
    {
        if([_serviceType isEqualToString:service])
        {
            return YES;
        }
    }
    return NO;
}

-(void)postMessage:(NSString *)message image:(UIImage *)image andURL:(NSURL *)url forService:(NSString*)serviceType andTarget:(id)target {
    if(target == nil)
    {
        NSLog(@"ERROR. Social Helper's target can't be equal to nil");
        return;
    }
    if([self isServiceEnabled:serviceType])
    {
         SLComposeViewController * composeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeViewController setInitialText:message];
        BOOL  imgAdded = [composeViewController addImage:image];
        imgAdded = NO;
        BOOL  urlAdded = [composeViewController addURL:url];
        urlAdded = NO;
       
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            [composeViewController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"User Cancelled.");
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Successfully Posted");
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Successfully Posted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];

                    
                }
                    break;
            }};
        [composeViewController setCompletionHandler:completionHandler];
        [target presentViewController:composeViewController animated:YES completion:nil];
    
    }
    else{
        NSString * message = [NSString stringWithFormat:@"%@ is not enabled on this device. ", serviceType];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"OK" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];

    }
}





@end
