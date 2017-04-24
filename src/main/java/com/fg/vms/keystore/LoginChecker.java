package com.fg.vms.keystore;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;


public class LoginChecker extends HttpServlet {

	// Define the BCrypt workload to use when generating password hashes. 10-31 is a valid value.
	private static int workload = 31;

	/**Use this method when you create new user
	 * This method can be used to generate a string representing an account password
	 * suitable for storing in a database. It will be an OpenBSD-style crypt(3) formatted
	 * hash string of length=60
	 * The bcrypt workload is specified in the above static variable, a value from 10 to 31.
	 * A workload of 12 is a very reasonable safe default as of 2013.
	 * This automatically handles secure 128-bit salt generation and storage within the hash.
	 * @param password_plaintext The account's plaintext password as provided during account creation,
	 *			     or when changing an account's password.
	 * @return String - a string of length 60 that is the bcrypt hashed password in crypt(3) format.

	public static String hashPassword(String password_plaintext) {
		String salt = BCrypt.gensalt(workload);
		String hashed_password = BCrypt.hashpw(password_plaintext, salt);

		return(hashed_password);
	}
*/
	/**
	 * This method can be used to verify a computed hash from a plaintext (e.g. during a login
	 * request) with that of a stored hash from a database. The password hash from the database
	 * must be passed as the second variable.
	 * @param password_plaintext The account's plaintext password, as provided during a login request
	 * @param stored_hash The account's stored password hash, retrieved from the authorization database
	 * @return boolean - true if the password matches the password of the stored hash, false otherwise
	 */
	public static boolean checkPassword(String password_plaintext, String stored_hash) {
		boolean password_verified = false;

		if(null == stored_hash || !stored_hash.startsWith("$2a$"))
			throw new java.lang.IllegalArgumentException("Invalid hash provided for comparison");

		password_verified = BCrypt.checkpw(password_plaintext, stored_hash);

		return(password_verified);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//get session and undo error messages
		HttpSession theSession = request.getSession();

		//get database
		MongoDatabase db = MongoConnector.connectMongo();

		// Set response content type
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		//get input
		String UserName = request.getParameter("u");
		String password = request.getParameter("p");

		if ("".equals(UserName) || "".equals(password)) {

			out.print("login_failed");
		} else {

			FindIterable<Document> cursor = db.getCollection("Users").find(new Document("Username", UserName));
			MongoCursor<Document> iterC = cursor.iterator();

			//return to login or proceed to landing
			if(iterC.hasNext()) {
				while(iterC.hasNext()) {
					Document tempDoc = iterC.next();

					String db_hash = tempDoc.getString("Password");


					if (checkPassword(password, db_hash)) {
						theSession.setAttribute("Username", UserName);
						out.print("login_success");
					} else {
						out.print("login_failed");
					}
				}
			} else {
				out.print("login_failed");

			}


		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
