# flutter_todo  project 



##  Task_T06   - Add Widget for one ToDo Entry Item

1.  Add a widget to display one $${\color{green}ToDoEntry}$$ Item
2.  Add a Cubit to load one entry item
3.  Add error/loading and loaded view states for this entry
4.  Add this entry into our $${\color{green}ToDoDetailLoaded}$$
5.  Add a UseCase and implement it in your $${\color{green}ToDoEntry}$$  Widget to update the entry if it is done or not


##  Task_T07   -  Improve ToDoEntryItemLoading 

- The $${\color{greem}CircularProgessIndicator}$$ looks ugly, so replace it with a better  loading state.
- ideas: Shimmer Loading ?? 


##  Task_To8  Add a reload to ToDoEntryItemError

- If we have a loading error for one item, we want to reload it after clicking on this item
- Update the mock to simulate a few error  
- Adjust the text to show this function to the user


##   Task_T09  create a ToDo Entry

- Add a button to our ToDoDetailPage
- If we click this button, we want to see a CreateToDoEntryPage
- Add a form to be able to add new items
- Add a validator for all field(s)
- Add all files and functions that we can save an entry in our mockmode


### Task-T10 Reload ToDoDetailPage

-  Reload all items from your ToDoDetailPage after a ToDoEntry Item was created
-  Rewrite the mockmode for this pupose.
-  Following the recommendation, use a callback instead of a previous solution:<submit().then(reload)>  to reload the Detail/Overview pages after items were added .
-  Here is a screen shoot showing the new items after they were created 
![alt screenshot] (https://github.com/PaulMatencio/flutter_to_do/blob/task_t10/todo_create_collection_and_entry.png)
  
                  
###  Task-T11 Add an own repository
- Add an own ToDo Repository implementation
- This implementation should store all data in the memory
- Create a new main file to start the app with your  ToDoRepositoryMemory implementation

- #### Bonus : Add a delete button to delete an entry +  Alert box for confirmation 
  #### Bonus : Add a modify button to modify an entry such as description  
  
- Here is are screenshots to show the app in desktop mode
![alt screenshot] (https://github.com/PaulMatencio/flutter_to_do/blob/task_t11/Todo_list_Task_T11.png)
![alt screenshot] (https://github.com/PaulMatencio/flutter_to_do/blob/task_t11/Alert_delete_box.png)



###  Task-T13  ColorPicker for Create Collection Form

- Improve our form create collection form  to select a color by  using a color picker
- Here are some screnshots to show the color picker 
![alt screenshot] (https://github.com/PaulMatencio/flutter_to_do/blob/task_t13/CreateCollection_color_picker.png)
![alt screenshot] (https://github.com/PaulMatencio/flutter_to_do/blob/task_t13/overview_page_collection_color.png)

- ####  add delete and modify entry for Hive local store in addition to memory local store which were done in Task-T11
- ####  add test for HiveLocalDataSource


###  Task-T14: Delete a Collection  
    
-  (1) Delete collection will only delete tasks (entries) if they are $${\color{green}checked (isDone: true)}$$
-  (2) Raise a warning if there are some tasks which are $${\color{red}unchecke (isDone:false)}$$
-  (3) The collection is deleted when all tasks are $${\color{green}checked (isDone:true)}$$ or when it is empty
-  ####  Alternatively you could also $${\color{green}empty}$$ a collection by deleting each entry before deleting it  

   ####  Ups  forgot to commit changes. Now code for delete collecion is commited

  
###  Task-T15: dashboard &&  screenshots  for delete collection (Task-T14)
    
  - screenshot for todo dashboard (https://github.com/PaulMatencio/flutter_to_do/blob/task_t15/dashboard-4.png)
  - screenshot for todo dashboard (https://github.com/PaulMatencio/flutter_to_do/blob/task_t15/dashboard-3.png)
  - screenshot for todo dashboard (https://github.com/PaulMatencio/flutter_to_do/blob/task_t15/dashboard-2.png)
  - screenshot for todo dashboard (https://github.com/PaulMatencio/flutter_to_do/blob/task_t15/dashboard-1.png)
  
  
  ####  Task14 screenshots
  - screenshot for before delete collection
  (https://github.com/PaulMatencio/flutter_to_do/blob/task_t15/todo_before_collection_isdeleted.png)
  - screenshot for after after collection is deleted
   (https://github.com/PaulMatencio/flutter_to_do/blob/task_t15/todo_after_collection_isdeleted.png)
   
   
   
###   Task-B01:   Add a login button

  - Add go routes for login page and profile page   
  - Add a login/profile button to the app
  - If the user is logged in, the user is redirected to the profile page
  - If the user is not logged in, the user is redirected to the login  page
  
  - Add an email-authentication provider in addition to the phone-authentication provider because it is easier to test the redirection. 
  - Redirection exception-> (!keyReservation.contains(key)is not true). Fix it by replacing $${\color{red}context.pushNamed()}$$  with $${\color{green}context.goNamed()}$$ 


###  Task-B02  Add a top navigation bar (small breakpoint)
  - Add the login button to the top navigation bar
  - Customize SignInScreen & ProfileScreen


###  Task-B03  Encapsulate Firebase auth

   - Implement an interface  for 
   - Create an account (register a user ) 
   - login with email/password
   - login with phone number/ confirmation code 
   - profile page with account deletion  
   - logout 
   - auth  stream

   #### Screenshots:
   - create an account page https://github.com/PaulMatencio/flutter_to_do/blob/task_bo3/register_page.png
   - Login with email/password page  https://github.com/PaulMatencio/flutter_to_do/blob/task_b03/Login-email_password_page.png
   - Login with phone/number page  https://github.com/PaulMatencio/flutter_to_do/blob/task_b03/Login-email_password_page.png
   - Confirmation code page https://github.com/PaulMatencio/flutter_to_do/blob/task_b03/Confirmation_code.png
   - Profile page ( under construction)


###  task-B04  implement of  fireStore methods 
  ####  implementation of the following methods  for fireStore remote datasource  
  ####  Class FireStoreRemoteDatasource implements ToDoRemoteDataSourceInterface 

   - init       ( Not requested)
   - getToDoEntryIds
   - getToDoEntry
   - createToDoEntry
   - deleteToDoEntry   ( Not requested)
   - updateToDoEntry   ( ot requested)
   - updateTodoEntry to replace  updateToDoEntry   ( Not requested)   
   - modifyToDoEntry   ( Not requested)
   - deleteToDoCollection  ( Not requested)

  ####  (not requested) implementation of the ToDoRepositoryRemote for firestore  ( Not requested)
  ####  class ToDoRepositoryRemote implements ToDoRepository  (  User must be logged in)  
  ####  user must be logged in to test   
       - createToDoCollection(ToDoCollection todoCollection);
       - readToDoCollections();
       - createToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry});
       - readToDoEntryIds(CollectionId collectionId);
       - readToDoEntry(CollectionId collectionId, EntryId entryId);
       - updateToDoEntry({required CollectionId collectionId, required EntryId entryId});
       - deleteToDoEntry({required CollectionId collectionId, required EntryId entryId});
       - deleteToDoEntries(CollectionId collectionId);
       - deleteToDoCollection(CollectionId collectionId);
       - modifyToDoEntry({required CollectionId collectionId, required ToDoEntry toDoEntry});
       - createToDoDashboard();

  ####  (not requested) Update the repository provider to use fireStore 
  ####   run  todo app with fireStare



###  task-B05  implement update in remote repository 
  ####   Already implemented in task_b04 
  - improve handling of error message when user is not logged in 
  - revisit
    - updateTodoEntry to replace  updateToDoEntry 



###  Task-B06   Update firestore rules
  - Only the todo collection owner should be able to read his collection
  - An unregistered or different user should not be able to access the data
    from another user!

rules_version = '2';
service cloud.firestore {
   match /databases/{database}/documents {
     match /{userId}/{document = **} {
        // allow create: if request.auth.uid != null;
        allow read, write: if request.auth.uid != null && request.auth.uid == userId ;
        }
    }
}

## task-B07  Create a hybrid repository 

   - If a user is logged in we want that his data stored in our database  ( Firestore )
   - If a user is not logged in the data should be stored on our device ( Hive )


##  task-B08   Add a crash button to the App
   - Test crashlytics configuration 
       - Add a button that throws an exception 

##  task-Completed   Localisation &  Testing 
   - Add  easy-localisation 
   - Add  tests