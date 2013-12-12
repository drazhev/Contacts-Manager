//
//  ContactDetailsViewController.m
//  5-Home-Contacts
//
//  Created by Alexandar Drajev on 12/11/13.
//  Copyright (c) 2013 Alexander Drazhev. All rights reserved.
//

#import "ContactDetailsTableViewController.h"

@interface ContactDetailsTableViewController ()

@property (nonatomic, strong) ContactBook* contactsModel;
@property (nonatomic) BOOL isEditing;

@end

@implementation ContactDetailsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateTableView: (NSNotification*) not {
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateTableView:) name:@"updateTable" object:nil];

    self.contactsModel = [ContactBook sharedBook];
    
    self.isEditing = NO;
    
    
    if (self.currentState == controllerCreateViewState) {
        self.currentContact = [[Contact alloc] init];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    if (self.currentState == controllerDetailsViewState) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    }
}


-(void)addButtonTapped: (id)sender {
    [self.contactsModel addContact:self.currentContact];
    
    // add notification for table update so the other table view is updated accordingly
    NSNotification* notification = [NSNotification notificationWithName:@"updateTable" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)textFieldDidChange:(id)sender {
    UITextField* currentField = (UITextField*) sender;
    switch (currentField.tag) {
        case 0:
            self.currentContact.firstName = currentField.text;
            break;
        case 1:
            self.currentContact.lastName = currentField.text;
            break;
        case 2:
            self.currentContact.homeAddress = currentField.text;
            break;
    }
    if (currentField.tag >= 5) {
        self.currentContact.emails[currentField.tag - 5] = currentField.text;
    }
    if (currentField.tag <= -1) {
        self.currentContact.phoneNumbers[-currentField.tag - 1] = currentField.text;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentContact.groupId = row;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Other";
            break;
        case 1:
            return @"E-mail";
            break;
        case 2:
            return @"Phone";
            break;
        default:
            return @"";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
            if (indexPath.section == 0 && indexPath.row >= 3) {
                return 150;
            }
    return 40;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return [self.currentContact.emails count];
            break;
        case 2:
            return [self.currentContact.phoneNumbers count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"textCell";
            ContactTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.mainTextLabel.text = self.currentContact.firstName;
            cell.mainTextLabel.placeholder = @"First name...";
            if (self.currentState == controllerDetailsViewState) {
                cell.mainTextLabel.enabled = NO;
            }
            cell.subtitleTextLabel.text = @"First name:";
            cell.mainTextLabel.tag = 0;
            cell.mainTextLabel.delegate = self;
            return cell;
        }
        else if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"textCell";
            ContactTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.mainTextLabel.text = self.currentContact.lastName;
            cell.mainTextLabel.placeholder = @"Last name...";
            if (self.currentState == controllerDetailsViewState) {
                cell.mainTextLabel.enabled = NO;
            }
            cell.subtitleTextLabel.text = @"Last name:";
            cell.mainTextLabel.tag = 1;
            cell.mainTextLabel.delegate = self;
            return cell;
        }
        else if (indexPath.row == 2) {
            static NSString *CellIdentifier = @"textCell";
            ContactTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.mainTextLabel.text = self.currentContact.homeAddress;
            cell.mainTextLabel.placeholder = @"Address...";
            if (self.currentState == controllerDetailsViewState) {
                cell.mainTextLabel.enabled = NO;
            }
            cell.subtitleTextLabel.text = @"Address:";
            cell.mainTextLabel.tag = 2;
            cell.mainTextLabel.delegate = self;
            return cell;

        }
        else if (indexPath.row == 3) {
            static NSString *CellIdentifier = @"imageCell";
            ContactImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.imageView.image = self.currentContact.picture;
            return cell;
        }
        else if (indexPath.row == 4) {
            static NSString *CellIdentifier = @"groupCell";
            ContactGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.groupPicker.delegate = self;
            cell.groupPicker.dataSource = self;
            [cell.groupPicker selectRow:self.currentContact.groupId inComponent:0 animated:NO];
            if (self.currentState == controllerDetailsViewState) {
                cell.userInteractionEnabled = NO;
            }
            return cell;
        }
        return nil;
    }
    
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"textCell";
        ContactTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.mainTextLabel.text = self.currentContact.emails[indexPath.row];
        cell.mainTextLabel.placeholder = @"Email...";
        if (self.currentState == controllerDetailsViewState) {
            cell.mainTextLabel.enabled = NO;
        }
        if (self.isEditing) {
            cell.mainTextLabel.enabled = YES;
        }
        cell.subtitleTextLabel.text = [NSString stringWithFormat: @"Email %ld", (long)indexPath.row + 1];
        // this could be implemented in another way
        // with an array that matches the current tag with the email row
        cell.mainTextLabel.tag = 5 + indexPath.row;
        cell.mainTextLabel.delegate = self;
        cell.mainTextLabel.keyboardType = UIKeyboardTypeEmailAddress;
        return cell;
    }
    
    else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"textCell";
        ContactTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.mainTextLabel.text = self.currentContact.phoneNumbers[indexPath.row];
        cell.mainTextLabel.placeholder = @"Phone number...";
        if (self.currentState == controllerDetailsViewState) {
            cell.mainTextLabel.enabled = NO;
        }
        if (self.isEditing) {
            cell.mainTextLabel.enabled = YES;
        }
        cell.subtitleTextLabel.text = [NSString stringWithFormat: @"Phone %ld", (long)indexPath.row + 1];
        cell.mainTextLabel.tag = -1 - indexPath.row;
        cell.mainTextLabel.delegate = self;
        cell.mainTextLabel.keyboardType = UIKeyboardTypePhonePad;
        return cell;

    }
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.contactsModel.contactsDictionary count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.contactsModel.groupsArray[row];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == [self.currentContact.emails count] - 1) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == [self.currentContact.phoneNumbers count] - 1) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete ) {
        if (indexPath.section == 1) {
            [self.currentContact.emails removeObjectAtIndex:indexPath.row];
        }
        if (indexPath.section == 2) {
            [self.currentContact.phoneNumbers removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (indexPath.section == 1) {
            [self.currentContact.emails addObject:@""];
        }
        if (indexPath.section == 2) {
            [self.currentContact.phoneNumbers addObject:@""];
        }
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
    
    // add notification for table update so the other table view is updated accordingly
    NSNotification* notification = [NSNotification notificationWithName:@"updateTable" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.tableView reloadData];
}


- (IBAction)choosePictureButtonTapped:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    self.currentContact.picture = img;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        self.isEditing = YES;
    }
    else {
        self.isEditing = NO;
    }
    [self.tableView reloadData];
}

-(void)dealloc {
    // I know while using ARC, dealloc is not needed
    // but removing an observer is mandatory still
    // and this is the best method to do so
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // no need to call [super dealloc] though, because ARC does it
}



@end
