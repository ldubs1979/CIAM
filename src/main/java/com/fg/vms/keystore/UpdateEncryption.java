package com.fg.vms.keystore;

import com.mongodb.BasicDBObject;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import org.bson.types.ObjectId;

public class UpdateEncryption extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ObjectId id = new ObjectId(request.getParameter("id"));
        System.out.print("in class");
        System.out.print(request.getParameter("id"));

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        //get database
        MongoDatabase db = MongoConnector.connectMongo();

        //check mandatory fields for proper info
        String CompanyCode = request.getParameter("CompanyCode");
        String Environment = request.getParameter("Environment");

        //build case insensitve Query in order to check on the composite key if it is in database
        Document x = new Document();
        x.append("AssetType", new BasicDBObject("$regex", "Encryption").append("$options", "i"));
        x.append("CompanyCode", new BasicDBObject("$regex", "^" + CompanyCode + "$").append("$options", "i"));
        x.append("Environment", new BasicDBObject("$regex", "^" + Environment + "$").append("$options", "i"));
        FindIterable<Document> cursor = db.getCollection("Assets").find(x);
        MongoCursor<Document> iterC = cursor.iterator();
        if (iterC.hasNext()) {
            Document tempDoc = iterC.next();
            if (id.toString().equals(tempDoc.get("_id").toString())) {
                updateRecord(request, response, id, db);
            }
            else {
                out.print("exists");
            }
        }
        else {
            updateRecord(request, response, id, db);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    //method to create document and replace old document with itself
    private void updateRecord(HttpServletRequest request, HttpServletResponse response,ObjectId id, MongoDatabase db){
        Document y = new Document();

        y.append("AssetType", "Encryption");
        y.append("CompanyCode", request.getParameter("CompanyCode").toUpperCase());
        y.append("Environment", request.getParameter("Environment"));
        y.append("EncryptKey", request.getParameter("EncryptKey"));
        y.append("EncryptType", request.getParameter("EncryptType"));
        y.append("DecryptKey", request.getParameter("DecryptKey"));
        y.append("SigningKey", request.getParameter("SigningKey"));
        y.append("SigningVerificationKey", request.getParameter("SigningVerificationKey"));
        y.append("DecryptPassword", request.getParameter("DecryptPassword"));
        y.append("SigningPassword", request.getParameter("SigningPassword"));
        y.append("Description", request.getParameter("Description"));

        db.getCollection("Assets").findOneAndReplace(new Document("_id",id),y);
    }
}