//
//  Contact.m
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/10/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import "Contact.h"

@implementation Contact

-(id)initWithFirstName: (NSString*) firstName lastName: (NSString*) lastName phoneNumbers: (NSMutableArray*) phoneNumbers emails: (NSMutableArray*) emails homeAddress: (NSString*) homeAddress picture: (UIImage*) picture groupId: (NSInteger) groupId {
    if (self = [super init]) {
        _firstName = firstName;
        _lastName = lastName;
        _phoneNumbers = phoneNumbers;
        _emails = emails;
        _homeAddress = homeAddress;
        _picture = picture;
        _groupId = groupId;
    }
    return self;
}

-(id) init {
    return [self initWithFirstName:@"FirstName" lastName:@"LastName" phoneNumbers:[@[@"0888888888"] mutableCopy] emails:[@[@"email@gmail.com"] mutableCopy] homeAddress:@"HomeAddress" picture:[UIImage imageNamed:@"defaultImage.png"] groupId:2];
}

@end
