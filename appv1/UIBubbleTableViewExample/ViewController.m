//Project modified by DJ Mobile Inc.
// Some Speech Bubbles are from : http://pixelsdaily.com/about/
//http://www.uiinterface.com/Tool-Tips/speech-bubble-ui.html
//  ViewController.m
//Free psd Misc Chat Bubbles
//Photoshop psd ( .psd ) file format
//Author: Dan Eden Licence: Creative Commons Attribution
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//http://all-free-download.com/free-psd/misc/chat_bubbles_175862.html
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//



#import "ViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "NSBubbleData.h"
#import "SocialHelper.h"


@interface ViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    IBOutlet UIImageView *messageInputBar;
    IBOutlet UIButton *sendButton;
    UIActionSheet * editOptions;
    NSMutableArray *bubbleData;
}
@property (retain, nonatomic) IBOutlet UILabel *addresseLabel;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (retain, nonatomic) IBOutlet UIView *messageEditorView;
@property (retain, nonatomic) IBOutlet UITextView *messageEditorTextView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *messageTypeSegmentedControl;
@property (retain, nonatomic) IBOutlet UIDatePicker *messageDate;

@property (retain, nonatomic) NSBubbleData * editingMessage;
@property (retain, nonatomic) IBOutlet UIToolbar *topToolbarMessageEditor;
@property (retain, nonatomic) IBOutlet ADBannerView *adBannerView;
@property (retain, nonatomic) IBOutlet UILabel *addresseText;
@property (retain, nonatomic) IBOutlet UIView *editAddresseeView;
@property (retain, nonatomic) IBOutlet UITextField *addresseeTextField;
@property (retain, nonatomic) IBOutlet UIButton *previewButton;

@property (retain, nonatomic) IBOutlet UIView *previewView;




- (IBAction)deleteMessage:(id)sender;
- (IBAction)finishEditing:(id)sender;
-(IBAction)editMessage;
- (IBAction)dismissAddresseeView:(id)sender;
- (IBAction)dismissPreview:(id)sender;
-(void)startEditingMessage:(NSBubbleData*)bubbleData;

@end

@implementation ViewController

-(void)startEditingMessage:(NSBubbleData*)messageData{
    self.editingMessage = messageData;
    [self.view addSubview:_messageEditorView];
    _messageEditorView.frame = self.view.bounds;
    _messageEditorTextView.text=messageData.bubbleText;
    if(messageData.type == BubbleTypeMine)
    {
        [_messageTypeSegmentedControl setSelectedSegmentIndex:1];
    }
    else{
        [_messageTypeSegmentedControl setSelectedSegmentIndex:0];
    }
    _messageDate.date= messageData.date;

}

- (IBAction)deleteMessage:(id)sender {
    for(NSBubbleData * b in bubbleData)
    {
        if(self.editingMessage == b)
        {
            NSLog(@"Data Found");
            [bubbleData removeObject:b];
            break;
        }
    }
    
    self.editingMessage = nil;
    [_messageEditorView removeFromSuperview];

    [bubbleTable reloadData];


}

- (IBAction)finishEditing:(id)sender {
    //apply changes
    NSString * text =   _messageEditorTextView.text;
    int bubbleType;
    if(_messageTypeSegmentedControl.selectedSegmentIndex == 0)
    {
        bubbleType = 1;
    }
    else{
        bubbleType = 0;
    }

    int i =0;
    for(NSBubbleData * b in bubbleData)
    {
        if(_editingMessage == b)
        {
            NSLog(@"Data Found");
            break;
        }
        i++;
    }
    
    NSBubbleData *editedMessage = [NSBubbleData dataWithText:text date:_messageDate.date type:bubbleType];
    [bubbleData replaceObjectAtIndex:i withObject:editedMessage];

    self.editingMessage = nil;
    [_messageEditorView removeFromSuperview];
    [bubbleTable reloadData];
}

-(IBAction)editMessage{
    NSLog(@"Edit Message ");
        
    editOptions = [[UIActionSheet alloc]initWithTitle:@"Edit" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Edit Sender",@"Preview",@"Save Screenshot", @"Share with Twitter",@"Share with Facebook",@"Share with Sina Weibo", nil];
    [editOptions showInView:self.view];
}


- (IBAction)showPreview{
    [_previewButton setBackgroundImage:[self createScreenshot] forState:UIControlStateNormal];
     [self.view addSubview: _previewView];
    _previewView.frame = self.view.bounds;
}

- (IBAction)dismissPreview:(id)sender{
    [_previewView removeFromSuperview];
}

- (IBAction)showAddresseeView:(id)sender {
    [self.view addSubview:_editAddresseeView];
    [self.addresseeTextField  becomeFirstResponder];
    self.addresseeTextField.text = self.addresseLabel.text;
}

- (IBAction)dismissAddresseeView:(id)sender {
    [self.editAddresseeView removeFromSuperview];
    self.addresseLabel.text= self.addresseeTextField.text;
    [_addresseeTextField resignFirstResponder];
}


-(UIImage *)createScreenshot{
    //[_adBannerView removeFromSuperview];
    _adBannerView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //[bubbleTable.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _adBannerView.hidden = NO;
  
    
    return myScreenshot;
}

-(void)saveScreenshot{
  UIImageWriteToSavedPhotosAlbum([self createScreenshot], self, @selector(image:didFinishWithError:contextInfo:), nil);
}


- (void) image: (UIImage *) image
didFinishWithError: (NSError *) error
   contextInfo: (void *) contextInfo{
    if(error!=nil)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Image couldn't be saved at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Screenshot was successfully saved.You can access it from the Photos app" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}





-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
                //Cancel
        }
            break;
        case 1: //Edit Sender
        {
            [self showAddresseeView:nil];
            
        }
            break;
        case 2: //Preview
        {
            [self showPreview];
            
        }
            break;
        case 3: //Save Screenshot
        {
            [self saveScreenshot];

        }
            break;
        
        case 4: //Share
        {
            
            
        }
            break;
   
        default:
            break;
    }
    
    UIImage * resultImage = [self createScreenshot];
    SocialHelper * helper = [[SocialHelper alloc]init];
    //Create image from Current Canvas
    NSString * urlString = @"https://itunes.apple.com/us/app/autocorrect/id597597047?ls=1&mt=8";
    
    NSURL *  url = [NSURL URLWithString:urlString];
    
    
    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Share with Twitter"])
    {
        [helper postMessage:@"Message" image:resultImage  andURL:url forService:SLServiceTypeTwitter andTarget:self];
    }
    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Share with Facebook"])
    {
        [helper postMessage:@"Message" image:resultImage  andURL:url forService:SLServiceTypeFacebook andTarget:self];
        
    }
    if( [[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Share with Sina Weibo"])
    {
        [helper postMessage:@"Message" image:resultImage  andURL:url forService:SLServiceTypeSinaWeibo andTarget:self];
    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _messageEditorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    self.title = @" Amanda ";
    //Set the navigation bar
 UIBarButtonItem * barButton =[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editMessage)];
    
  self.navigationItem.rightBarButtonItem = barButton;   
    
      
    NSBubbleData *heyBubble0 = [NSBubbleData dataWithText:@"Hey, thanks for downloading the app! Here is what you can do with it: " date:[NSDate dateWithTimeIntervalSinceNow:-10] type:BubbleTypeSomeoneElse];
    NSBubbleData *heyBubble1 = [NSBubbleData dataWithText:@"Tap on the message bubble to edit it's text and date. " date:[NSDate dateWithTimeIntervalSinceNow:-10] type:BubbleTypeSomeoneElse];

    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Tap me! tap me ! Tap me!" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    NSBubbleData *heyBubble2 = [NSBubbleData dataWithText:@"Tap on the Edit button to change the sender of the message or share the screenshot!" date:[NSDate dateWithTimeIntervalSinceNow:-10] type:BubbleTypeSomeoneElse];
    
    NSBubbleData *replyBubble2 = [NSBubbleData dataWithText:@"Wow.. Yeah it's a cool app! " date:[NSDate dateWithTimeIntervalSinceNow:-3] type:BubbleTypeMine];
    
    NSBubbleData *replyBubble3 = [NSBubbleData dataWithText:@"Entertaiment use only! " date:[NSDate dateWithTimeIntervalSinceNow:-2] type:BubbleTypeSomeoneElse];
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble0,heyBubble1,replyBubble, heyBubble2,  replyBubble2,replyBubble3, nil];
    bubbleTable.bubbleDataSource = self;
    bubbleTable.viewControllerTarget = self;
    
    //bubbleTable.delegate = self;
        
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = NO;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [bubbleTable reloadData];
    
    self.view.backgroundColor =[UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1];
    
    //setting up the bar
    messageInputBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    messageInputBar.opaque = YES;
    messageInputBar.userInteractionEnabled = YES; // makes subviews tappable
    messageInputBar.image = [[UIImage imageNamed:@"MessageInputBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 3, 19, 3)]; // 8 x 40
    //setting up text view

     UIImageView *messageInputBarBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MessageInputFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 12, 18, 18)]];
        
    messageInputBarBackgroundImageView.frame = CGRectMake(textField.frame.origin.x-2, 0, textField.frame.size.width+2, textInputView.frame.size.height);
    [textInputView addSubview:messageInputBarBackgroundImageView];
    textInputView.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
    
    UIEdgeInsets sendButtonEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13); // 27 x 27
    UIImage *sendButtonBackgroundImage = [[UIImage imageNamed:@"SendButton"] resizableImageWithCapInsets:sendButtonEdgeInsets];
    [sendButton setBackgroundImage:sendButtonBackgroundImage forState:UIControlStateNormal];
    
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark delegate called
-(void)selectedCellWithData:(NSBubbleData *)data{
    for(NSBubbleData * b in bubbleData)
    {
        if(data == b)
        {
            NSLog(@"Data Found");
            [self  startEditingMessage:data];
            break;
        }
    }

}



#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
        bubbleTable.userInteractionEnabled = NO;
        
    }];
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithTitle:@"Dismiss" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTextView)];
    NSArray * a = [NSArray arrayWithObject:bbi];
    [self.topToolbarMessageEditor setItems:a animated:YES];
    
}

-(void)dismissTextView{
    [_messageEditorTextView resignFirstResponder];
}
                             
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
        bubbleTable.userInteractionEnabled = YES;
    }];
    [_topToolbarMessageEditor setItems:nil];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
    textField.text = @"";
    [textField resignFirstResponder];
}

- (void)dealloc {
    [_navigationBar release];
    [messageInputBar release];
    [sendButton release];
    [_messageEditorView release];
    [_messageEditorTextView release];
    [_messageTypeSegmentedControl release];
    [_messageDate release];
    [_topToolbarMessageEditor release];
    [_adBannerView release];
    [_addresseText release];
    [_editAddresseeView release];
    [_addresseeTextField release];
    [_addresseLabel release];
    [_previewView release];
    [_previewButton release];
    [super dealloc];
}


-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    return  YES;
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    banner.hidden = NO;
    NSLog(@"Loading banner");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    banner.hidden = YES;
    NSLog(@"Hiding banner %@ ", [error debugDescription]);
}

- (BOOL)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown;
}


@end
