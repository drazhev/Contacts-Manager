//
//  ContactsTextTableViewCell.h
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/11/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;

@end
