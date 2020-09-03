# trello_board

A new Flutter application, for displaying columns and cards like Trello

### Approach

- A horizontal list view which will store columns.
- For each column, a nested list which can be scrollable vertically.
- Each column, has list of draggable and re-orderable cards.
- Each column, will be a target to drop the card, dragged from other column.
- On long tapping of a card, it will become re-orderable, drag and drop horzontally, then its position gets changed.
- On drag and drop in other column, it will be dismissed from the column which it was initially before dragging and gets added to the end of the list in new column.

### Running the application

- Download the application archive
- In terminal or cmd:
  ```
  flutter packages get
  flutter run
  ```
  
- Or simply download the apk file and install in mobile 


### Database structure
- Only one collection, `columns`
- Each column has two fields `Title, List of Cards`
- Each card has four fields   
```dart
int id;
String task;
String columnId;
int views;
int likes;
```
- In this approach, field `columnId` is useless. I used it just incase if we switch db like `MongoDB`, we can perfom complex operations like joins which is not possible in `firestore collections` by separating cards collection and replacing the list of cards here with their ids in the order which we have our Cards in the column. Refer the example below

```json
{
  "columns": [
    {
      "_id": "col-id",
      "title": "Col title",
      "cards": [
        "card-1-someid",
        "card-2-someid"
      ]
    }
  ],
  "cards": [
    {
      "_id": "card-1-someid",
      "other_data": "data"
    },
    {
      "_id": "card-2-someid",
      "other_data": "data"
    }
  ]
}
```
In case of re-odering, here we can just update the `cards` field in `columns` collection and while fetching the data, we can fetch in the order of the ids of that cards, which is not possible in `firestore` as it lacks join query.

### Screenshots
<img src="screenshots/home.png" width="35%" height="35%" alt="Home screen" />
<img src="screenshots/home-add-button.png" width="35%" height="35%" alt="Home screen with add add button" />
<img src="screenshots/add-col.png" width="35%" height="35%" alt="Add column" />
<img src="screenshots/add-card.png" width="35%" height="35%" alt="Add card" />