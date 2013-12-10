//
//  Contact.h
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, strong) NSMutableArray* phoneNumbers;
@property (nonatomic, strong) NSMutableArray* emails;
@property (nonatomic, copy) NSString* homeAddress;
@property (nonatomic, strong) UIImage* picture;
@property (nonatomic) NSInteger groupId;

// designated initializer

-(id)initWithFirstName: (NSString*) firstName lastName: (NSString*) lastName phoneNumbers: (NSMutableArray*) phoneNumbers emails: (NSMutableArray*) emails homeAddress: (NSString*) homeAddress picture: (UIImage*) picture groupId: (NSInteger) groupId;

@end
