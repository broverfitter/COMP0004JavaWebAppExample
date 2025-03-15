package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import uk.ac.ucl.model.Tree;
import uk.ac.ucl.model.DirectoryNode;

// The servlet invoked to perform a search.
// The url http://localhost:8080/runsearch.html is mapped to calling doPost on the servlet object.
// The servlet object is created automatically, you just provide the class.

@WebServlet("/")
public class HomeServlet extends HttpServlet
{
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    ServletContext context = getServletContext();
    
    // Load the JSON structure and create the Tree object
    String jsonFilePath = context.getRealPath("/structure.json");
    Tree tree = new Tree(jsonFilePath);
    DirectoryNode root = tree.getRoot();
    
    // Set the tree root as a request attribu
    request.setAttribute("tree", root);
    
    // Now forward to a JSP page instead of HTML for dynamic rendering
    RequestDispatcher dispatch = context.getRequestDispatcher("/home.jsp");
    dispatch.forward(request, response);
  }
}