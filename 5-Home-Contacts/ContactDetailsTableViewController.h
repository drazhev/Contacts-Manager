//
//  ContactDetailsViewController.h
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/11/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ContactTextTableViewCell.h"
#include "ContactGroupTableViewCell.h"
#include "ContactImageTableViewCell.h"
#include "Contact.h"
#include "ContactBook.h"

typedef enum controllerViewState {
    controllerDetailsViewState,
    controllerCreateViewState
    } controllerViewState;

@interface ContactDetailsTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) controllerViewState currentState;
@property (nonatomic, strong) Contact* currentContact;

@end
