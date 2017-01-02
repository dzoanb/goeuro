# Go Euro Demo
**Author:** Joanna Bednarz (PGS Software)

Project uses third party frameworks integrated with CocoaPods: 

* SDWebImage
* XLPagerTabStrip

To run it requires:

* Xcode version 8.2.1,
* iOS 9,
* pods installation with command: `pod install`.

### Disclaimer
To enable offline access application uses CoreData to store text data and SDWebImage for images.

Unit tests covers most vulnerable parts of data provider. But if there would be more time also model, view model, data source and api client should be tested.

UI tests would be very helpful but requires significant amount of time for initial setup, especially mocking data.

For better user experience custom notification about offline work and refresh control.