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

@WebServlet("/")
public class HomeServlet extends HttpServlet
{
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    ServletContext context = getServletContext();
    
    RequestDispatcher dispatch = context.getRequestDispatcher("/home.jsp");
    dispatch.forward(request, response);
  }
}