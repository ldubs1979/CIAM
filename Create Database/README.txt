1.)Move the AssetData.json and the UserData.json files onto the C drive (C:\)
2.)Move the import.bat file into your mongodb/bin directory
3.)Make sure the MongoDB server is running (mongod.exe)
4.)run the import.bat file in the cmd prompt(>import.bat)
5.)This will create the database CIAM2 if it does not exist, then it will drop any collection named Assets or Users. It will then populte new Assets and User collections