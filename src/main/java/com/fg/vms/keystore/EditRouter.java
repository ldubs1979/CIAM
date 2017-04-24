package com.fg.vms.keystore;

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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


public class EditRouter extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession theSession = request.getSession();
        //get session and session variables
        ObjectId id=new ObjectId(request.getParameter("id"));
        theSession.setAttribute("_id",id);
        List<String> keys=new ArrayList<>();
        List<Object> values=new ArrayList<>();

        //undo any error messages
        PrintWriter out = response.getWriter();

        //get database
        MongoDatabase db= MongoConnector.connectMongo();

        //find document in database off of _id
            FindIterable<Document> newDoc = db.getCollection("Assets").find(new Document("_id",id));
        MongoCursor<Document> iterC = newDoc.iterator();
        while(iterC.hasNext()){
            Document tempDoc= iterC.next();
            Iterator<Map.Entry<String, Object>> iterD = tempDoc.entrySet().iterator();
            while(iterD.hasNext()){
                Map.Entry<String,Object> entry= iterD.next();
                keys.add(entry.getKey());
                values.add(entry.getValue());
            }
        }

        //check AssetType
            if(values.get(1).toString().equalsIgnoreCase("SFTP")){
                theSession.setAttribute("AssetType","SFTP");
            }
            else {
                theSession.setAttribute("AssetType", "Enc");
            }
                theSession.setAttribute("docKeys", keys);
        theSession.setAttribute("docValues", values);
                 response.setStatus(response.SC_MOVED_TEMPORARILY);

               if(request.getParameter("type").equals("0"))
            response.setHeader("Location", "/view.jsp");
        else
            response.setHeader("Location", "/edit.jsp");
    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
