package com.fg.vms.keystore;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;

/**
 * Created by I854655 on 7/12/2016.
 */
public class MongoConnector {
    private static  MongoDatabase db= null;
    private static MongoClientURI clientURI = new MongoClientURI("mongodb://localhost:27017/CIAM2");
    private static MongoClient client = new MongoClient(clientURI);


    //get database CIAM2 from client
    public static MongoDatabase connectMongo(){
        db = client.getDatabase("CIAM2");
        return db;
    }
}
