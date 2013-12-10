//
//  ContactBook.h
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface ContactBook : NSObject

@property (nonatomic, strong) NSMutableDictionary* contactsDictionary;


+(id)sharedBook;
-(void)addContact: (Contact*) contact;
-(void)deleteContactWithGroupId: (NSInteger) groupId andContactId: (NSInteger) contactId;

@end
