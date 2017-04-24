package com.fg.vms.keystore;

import com.mongodb.BasicDBObject;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public class DeleteAsset extends HttpServlet {



    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession theSession = request.getSession();
        ObjectId id=new ObjectId(request.getParameter("id"));


        //get database
        MongoDatabase db=MongoConnector.connectMongo();

        db.getCollection("Assets").deleteOne(new Document("_id",id));

        //return to landing after delete
        response.setStatus(response.SC_MOVED_TEMPORARILY);
        response.setHeader("Location", "/landing.jsp");

        }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
