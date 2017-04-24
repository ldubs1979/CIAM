package com.fg.vms.keystore;

import com.mongodb.BasicDBObject;
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

public class AddEncryption extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //undo any error messages
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        //get database
        MongoDatabase db = MongoConnector.connectMongo();
        //check mandatory fields for proper info
        String CompanyCode = request.getParameter("CC");
        String Environment = request.getParameter("Env");



            //build case insensitve Query in order to check on the composite key if it is in database
            Document x = new Document();
            x.append("AssetType", new BasicDBObject("$regex", "^Encryption$").append("$options", "i"));
            x.append("CompanyCode", new BasicDBObject("$regex", "^" + CompanyCode + "$").append("$options", "i"));
            x.append("Environment", new BasicDBObject("$regex", "^" + Environment + "$").append("$options", "i"));
            FindIterable<Document> cursor = db.getCollection("Assets").find(x);
            MongoCursor<Document> iterC = cursor.iterator();
            if (iterC.hasNext()) {
                out.print("exists");

            } else {
                //It is fresh data, insert document with the fields given
                Document y = new Document();

                //create the document
                y.append("AssetType", "Encryption");
                y.append("CompanyCode", CompanyCode.toUpperCase());
                y.append("Environment", Environment);
                y.append("EncryptKey", request.getParameter("EncK"));
                y.append("EncryptType", request.getParameter("EncT"));
                y.append("DecryptKey", request.getParameter("DecK"));
                y.append("SigningKey", request.getParameter("SignK"));
                y.append("SigningVerificationKey", request.getParameter("SignVer"));
                y.append("DecryptPassword", request.getParameter("DecP"));
                y.append("SigningPassword", request.getParameter("SignP"));
                y.append("Description", request.getParameter("Des"));

                // insert y into database
                db.getCollection("Assets").insertOne(y);
                cursor= db.getCollection("Assets").find(y);
                iterC=cursor.iterator();
                x= iterC.next();
                ObjectId id = (ObjectId)x.get( "_id" );
                out.print(id.toString());
            }
        }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
