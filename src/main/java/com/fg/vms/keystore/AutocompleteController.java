package com.fg.vms.keystore;

import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.util.JSON;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;


public class AutocompleteController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        MongoDatabase db = MongoConnector.connectMongo();
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        ArrayList<String> itemArray = new ArrayList<String>();
        MongoCursor<String> c = db.getCollection("Assets").distinct("CompanyCode", String.class).iterator();
        while (c.hasNext())
            itemArray.add("CompanyCode:"+c.next());

        c = db.getCollection("Assets").distinct("Environment", String.class).iterator();
        while (c.hasNext())
            itemArray.add("Environment:"+c.next());

        c = db.getCollection("Assets").distinct("AssetType", String.class).iterator();
        while (c.hasNext())
            itemArray.add("AssetType:"+c.next());

        itemArray.add("All");
        out.print(JSON.serialize(itemArray));
    }

}
