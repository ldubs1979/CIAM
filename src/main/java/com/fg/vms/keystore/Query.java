package com.fg.vms.keystore;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.mongodb.BasicDBObject;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.util.JSON;
import org.bson.Document;
/**
 * Servlet implementation class Query
 */

public class Query extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//get session and session variables
		HttpSession theSession= request.getSession();
		List<Document> documentArray = new ArrayList<>();
		theSession.setAttribute("ErrorMessage", null);

		//get database
		MongoDatabase db=MongoConnector.connectMongo();

			//get search criteria
		String query = request.getParameter("query");
		theSession.setAttribute("LastQuery",query);

		// Set response content type
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		//unique case of "all", for all records
		if (query.equalsIgnoreCase("all") || query.equalsIgnoreCase("all;")) {
			FindIterable<Document> cursor = db.getCollection("Assets").find().sort(new Document("CompanyCode", 1).append("Environment", 1).append("AssetType", 1));
			MongoCursor<Document> iterC = cursor.iterator();

			while (iterC.hasNext()) {
				Document tempDoc = iterC.next();
				documentArray.add(tempDoc);


			}
		//	theSession.setAttribute("returnQuery", documentArray);
			out.print(JSON.serialize(documentArray));
		}

		//If there is a query go here
		else if (query.length() > 0) {

			//if the query has the proper form start going through here
			if (query.indexOf(';') > 0) {

				String[] splited = query.split(";");
				Document x = new Document();
				for (int i = 0; i < splited.length; i++) {
					String[] splited2 = splited[i].split(":");
					if (splited2.length >= 2) {
						try {
							x.append(splited2[0],
									new BasicDBObject("$regex", splited2[1])
											.append("$options", "i"));
						} catch (NullPointerException e) {
							out.print("failed");
							//theSession.setAttribute("returnQuery", null);
							x = null;
						}
					} else {
						out.print("failed");
					//	theSession.setAttribute("returnQuery", null);
						x = null;
					}
				}
				//if x found some results while being of the correct form then sort and add to the returnQuery list
				if (x != null) {
					FindIterable<Document> cursor = db.getCollection("Assets").find(x).sort(new Document("CompanyCode", 1).append("Environment", 1).append("AssetType", 1));
					MongoCursor<Document> iterC = cursor.iterator();

					while (iterC.hasNext()) {
						Document tempDoc = iterC.next();

						documentArray.add(tempDoc);
					}
					out.print(JSON.serialize(documentArray));


				}
			} else {
				out.print("failed");
			//	theSession.setAttribute("returnQuery", null);
			}
		}


	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
