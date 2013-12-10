//
//  SendMailViewController.h
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SendMailViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *recipientLabel;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) NSString* recipientEmail;


@end
