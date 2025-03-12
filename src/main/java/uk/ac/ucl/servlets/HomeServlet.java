package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uk.ac.ucl.model.Model;
import uk.ac.ucl.model.ModelFactory;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

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
    String jsonFilePath = context.getRealPath("/structure.json");

    Tree tree = new Tree(jsonFilePath);
    DirectoryNode root = tree.getRoot();

    request.setAttribute("tree", root);
    if (request.getAttribute("content") == null) {
      request.setAttribute("content", "Start Writing");
    }
    
    // Now forward to a JSP page instead of HTML for dynamic rendering
    RequestDispatcher dispatch = context.getRequestDispatcher("/home.jsp");
    dispatch.forward(request, response);
  }
}